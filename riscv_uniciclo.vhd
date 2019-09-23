library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity riscv_uniciclo is
	port(
		--clock_fetch, clock_MI, clock_breg, clock_MD: in std_logic;
		clock, clock_m : in std_logic;
		
		signalout_reset: in std_logic;
		--Sinais de PC
		signalout_pc, signalout_pc4, signalout_pc_proximo, signalout_pc_salto, signalout_pc_selecionado, signalout_mux_ula_out: out std_logic_vector(31 downto 0);
		
		signalout_instrucao: out std_logic_vector(31 downto 0);
		
		--Sinais do xregs
		signalout_r_out1: out std_logic_vector(31 downto 0);
		signalout_r_out2: out std_logic_vector(31 downto 0);
		signalout_rs1: out std_logic_vector(4 downto 0);
		signalout_rs2: out std_logic_vector(4 downto 0);
		signalout_rd: out std_logic_vector(4 downto 0);
		signalout_banco_input, signalout_banco_data_write: out std_logic_vector(31 downto 0);
		
		signalout_control_branch: out std_logic;
		signalout_control_memread: out std_logic;
		signalout_control_memtoreg: out std_logic;
		signalout_control_aluop: out std_logic_vector(1 downto 0);
		signalout_control_memwrite: out std_logic;
		signalout_control_alusrc: out std_logic;
		signalout_control_regwrite: out std_logic;
		signalout_control_reg_data: out std_logic;
		signalout_pc_ctrl: out std_logic;
		signalout_control_lui: out std_logic;
		
		signalout_saida_ula, signalout_ula_in_1, signalout_ula_in_2: out std_logic_vector(31 downto 0);
		signalout_ula_zero, signalout_ula_less: out std_logic;
		signalout_mux_ula_1: out std_logic_vector(31 downto 0);
		
		signalout_beq, signalout_bne, signalout_blt, signalout_bge, signalout_mux_comparado: out std_logic;
		
		signalout_saida_imm_gerador: out std_logic_vector(31 downto 0);
		signalout_saida_mem_dado: out std_logic_vector(31 downto 0);
	
		signalout_f3_concatenado: out std_logic_vector(1 downto 0);
		signalout_imm_shiftado: out std_logic_vector(31 downto 0);
		signalout_ula_jalr: out std_logic_vector(31 downto 0)
		
	);
end riscv_uniciclo; 

architecture behavior of riscv_uniciclo is
	
	--Sinais do processador
	--Sinais de PC
	signal pc_atual, pc_proximo, pc_mais_quatro, pc_salto, pc_selecionado: std_logic_vector(31 downto 0);
	
	--Saida da memoria de instrucao
	signal mem_instrucao_out: std_logic_vector(31 downto 0);
	signal mux_ula_out: std_logic_vector(31 downto 0);
	
	--Banco de registradores
	signal r_out1, r_out2: std_logic_vector(31 downto 0);
	signal banco_data_write: std_logic_vector(31 downto 0);
	signal banco_input: std_logic_vector(31 downto 0);
	
	--Gerador de imediatos
	signal saida_imm: std_logic_vector(31 downto 0);
	
	--Unidade de controle
	signal control_branch: std_logic;
	signal control_memread: std_logic;
	signal control_memtoreg: std_logic;
	signal control_aluop: std_logic_vector(1 downto 0);
	signal control_memwrite: std_logic;
	signal control_alusrc: std_logic;
	signal control_reg_data: std_logic;
	signal control_pc_ctrl: std_logic;
	signal control_regwrite: std_logic;
	signal control_lui: std_logic;
	
	--ULA
	signal ula_in_1, ula_in_2: std_logic_vector(31 downto 0);
	signal ula_out: std_logic_vector(31 downto 0);
	signal zero, less_than: std_logic;
	signal mux_ula_1: std_logic_vector(31 downto 0);
	
	--Controle da ULA
	signal alu_control: std_logic_vector(3 downto 0);
	
	--Memoria de dados
	signal data_out: std_logic_vector(31 downto 0);
	
	--Comparador de salto
	signal beq, bne, blt, bge: std_logic;
	signal mux_comparador: std_logic;
	
	--Auxiliares
	signal f3_concatenado: std_logic_vector(1 downto 0);
	signal imm_shiftado: std_logic_vector(31 downto 0);
	signal ula_jalr: std_logic_vector(31 downto 0);
	
	begin
		process(f3_concatenado, imm_shiftado, ula_jalr)
			begin				
--				if(signalout_reset = '1') then
--					pc_atual <= X"00000000";
--				elsif (rising_edge(signalout_clock_lento)) then
--					pc_atual <= pc_proximo;
--				end if;
		end process;
		
		f3_concatenado <= mem_instrucao_out(14) & mem_instrucao_out(12);
		imm_shiftado <= std_logic_vector(signed(shift_left(unsigned(saida_imm), 1)));
		ula_jalr <= ula_out and not X"00000001";
		
		pc_reg: entity work.registrador_pc
			port map(
				pc_in => pc_selecionado,
				--clock => clock_fetch,
				clock => clock,
				pc_rst => signalout_reset,
				pc_out => pc_atual
			);
		
		controle: entity work.controle
			port map(
				opcode => mem_instrucao_out(6 downto 0),
				alusrc => control_alusrc,
				mem2reg => control_memtoreg,
				regwrite => control_regwrite,
				memread => control_memread,
				memwrite => control_memwrite,
				branch => control_branch,
				reg_data => control_reg_data,
				pc_ctrl => control_pc_ctrl,
				lui => control_lui,
				aluop => control_aluop
			);
			
		controle_ula: entity work.controle_ula
			port map(
				funct7 => mem_instrucao_out(31 downto 25),
				funct3 => mem_instrucao_out(14 downto 12),
				aluop => control_aluop,
				aluctr => alu_control
			);
			
		imm_gem: entity work.gerador_imediatos
			port map(
				instr => mem_instrucao_out,
				imm32 => saida_imm
			);
			
		mux_reg_write: entity work.mux2to1
			port map(
				input0 => banco_data_write,
				input1 => pc_mais_quatro,
				sel_b => control_reg_data,
				output => banco_input
			);
		
		xregs: entity work.banco_registradores
			port map(
				--clock => clock_breg,
				clock => clock,
				wren => control_regwrite,
				rst => '0',
				rs1 => mem_instrucao_out(19 downto 15),
				rs2 => mem_instrucao_out(24 downto 20),
				rd	=> mem_instrucao_out(11 downto 7),
				data => banco_input,
				r_out1 => r_out1,
				r_out2 => r_out2
			);
			
		mux_alu1: entity work.mux2to1
			port map(
				input0 => r_out1,
				input1 => pc_atual,
				sel_b => control_reg_data,
				output => mux_ula_1
			);
			
		mux_alu1_1: entity work.mux2to1
			port map(
				input0 => mux_ula_1,
				input1 => X"00000000",
				sel_b => control_lui,
				output => ula_in_1
			);
			
		ula: entity work.ula
			port map(
				opcode_ULA => alu_control,
				A => ula_in_1,
				B => ula_in_2,
				Z => ula_out,
				zero => zero,
				less_than_zero => less_than
			);
			
		mux_alu2: entity work.mux2to1
			port map(
				input0 => r_out2,
				input1 => saida_imm,
				sel_b => control_alusrc,
				output => ula_in_2
			);
			
		mux_pc: entity work.mux2to1
			port map(
				input0 => pc_mais_quatro,
				input1 => pc_salto,
				sel_b => mux_comparador,
				output => pc_proximo
			);
			
		mux_branch: entity work.mux4to1
			port map(
				input0 => beq,
				input1 => bne,
				input2 => blt,
				input3 => bge,
				sel_b => f3_concatenado,
				output => mux_comparador
			);
			
		saltos: entity work.comparador_saltos
			port map(
				signal_zero => zero,
				signal_less => less_than,
				signal_branch => control_branch,
				signal_beq => beq,
				signal_bne => bne,
				signal_blt => blt,
				signal_bge => bge
			);
			
		somador_salto: entity work.somador
			port map(
				inputadd_0 => pc_atual,
				inputadd_1 => saida_imm,
				outputadd => pc_salto
			);
			
		somador_pc4: entity work.somador
			port map(
				inputadd_0 => pc_atual,
				inputadd_1 => X"00000004",
				outputadd => pc_mais_quatro
			);
			
		mux_aluout: entity work.mux2to1
			port map(
				input0 => ula_jalr,
				input1 => ula_out,
				sel_b => mem_instrucao_out(3), --0 pra JALR, 1 pra JAL
				output => mux_ula_out
			);
		
		mux_pcjal: entity work.mux2to1
			port map(
				input0 => pc_proximo,
				input1 => mux_ula_out,
				sel_b => control_pc_ctrl,
				output => pc_selecionado
			);
		
		memoria_instr: entity work.MemIns
			port map(
				address => pc_atual(9 downto 2),
				--clock => clock_MI,
				clock => clock_m,
				data => X"00000000",
				wren => '0',
				q => mem_instrucao_out
			);
		
		mux_data: entity work.mux2to1
			port map(
				input0 => ula_out,
				input1 => data_out,
				sel_b => control_memtoreg,
				output => banco_data_write
			);
			
		memoria_dados: entity work.MemData
			port map(
				address => ula_out(9 downto 2),
				--clock => clock_MD,
				clock => clock_m,
				data => r_out2,
				wren => control_memwrite,
				rden => control_memread,
				q => data_out
			);
		
		--Sinais de Saida
		signalout_pc <= pc_atual;
		signalout_pc4 <= pc_mais_quatro;
		signalout_pc_proximo <= pc_proximo;
		signalout_pc_salto <= pc_salto;
		signalout_pc_selecionado <= pc_selecionado;
		signalout_mux_ula_out <= mux_ula_out;
		
		signalout_instrucao <= mem_instrucao_out;
		
		signalout_r_out1 <= r_out1;
		signalout_r_out2 <= r_out2;
		signalout_rs1 <= mem_instrucao_out(19 downto 15);
		signalout_rs2 <= mem_instrucao_out(24 downto 20);
		signalout_rd <= mem_instrucao_out(11 downto 7);
		signalout_banco_input <= banco_input;
		signalout_banco_data_write <= banco_data_write;
		
		signalout_control_branch <= control_branch;
		signalout_control_memread <= control_memread;
		signalout_control_memtoreg <= control_memtoreg;
		signalout_control_aluop <= control_aluop;
		signalout_control_memwrite <= control_memwrite;
		signalout_control_alusrc <= control_alusrc;
		signalout_control_regwrite <= control_regwrite;
		signalout_control_reg_data <= control_reg_data;
		signalout_pc_ctrl <= control_pc_ctrl;
		signalout_control_lui <= control_lui;
		
		signalout_saida_ula <= ula_out;
		signalout_ula_in_1 <= ula_in_1;
		signalout_ula_in_2 <= ula_in_2;
		signalout_ula_zero <= zero;
		signalout_ula_less <= less_than;
		signalout_mux_ula_1 <= mux_ula_1;
		
		signalout_beq <= beq;
		signalout_bne <= bne;
		signalout_blt <= blt;
		signalout_bge <= bge;
		signalout_mux_comparado <= mux_comparador;
		
		signalout_saida_imm_gerador <= saida_imm;
		signalout_saida_mem_dado <= pc_selecionado;
	
		signalout_f3_concatenado <= f3_concatenado;
		signalout_imm_shiftado <= imm_shiftado;
		signalout_ula_jalr <= ula_jalr;
		
end architecture behavior;