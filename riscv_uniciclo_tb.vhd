library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity riscv_uniciclo_tb is
end riscv_uniciclo_tb;

architecture test of riscv_uniciclo_tb is
	
	--Sinais de PC
		--signal clock_fetch, clock_MI, clock_breg, clock_MD: std_logic;
		signal clock, clock_m : std_logic;
		
		signal signalout_reset: std_logic;
		signal signalout_pc, signalout_pc4, signalout_pc_proximo, signalout_pc_salto, signalout_pc_selecionado, signalout_mux_ula_out: std_logic_vector(31 downto 0);
		
		signal signalout_instrucao: std_logic_vector(31 downto 0);
		
		--Sinais do xregs
		signal signalout_r_out1: std_logic_vector(31 downto 0);
		signal signalout_r_out2: std_logic_vector(31 downto 0);
		signal signalout_rs1: std_logic_vector(4 downto 0);
		signal signalout_rs2: std_logic_vector(4 downto 0);
		signal signalout_rd: std_logic_vector(4 downto 0);
		signal signalout_banco_input, signalout_banco_data_write: std_logic_vector(31 downto 0);
		
		signal signalout_control_branch: std_logic;
		signal signalout_control_memread: std_logic;
		signal signalout_control_memtoreg: std_logic;
		signal signalout_control_aluop: std_logic_vector(1 downto 0);
		signal signalout_control_memwrite: std_logic;
		signal signalout_control_alusrc: std_logic;
		signal signalout_control_regwrite: std_logic;
		signal signalout_control_reg_data: std_logic;
		signal signalout_pc_ctrl: std_logic;
		signal signalout_control_lui: std_logic;
		
		signal signalout_saida_ula, signalout_ula_in_1, signalout_ula_in_2: std_logic_vector(31 downto 0);
		signal signalout_ula_zero, signalout_ula_less: std_logic;
		signal signalout_mux_ula_1: std_logic_vector(31 downto 0);
		
		signal signalout_beq, signalout_bne, signalout_blt, signalout_bge, signalout_mux_comparado: std_logic;
		
		signal signalout_saida_imm_gerador: std_logic_vector(31 downto 0);
		signal signalout_saida_mem_dado: std_logic_vector(31 downto 0);
		signal signalout_f3_concatenado: std_logic_vector(1 downto 0);
		signal signalout_imm_shiftado: std_logic_vector(31 downto 0);
		signal signalout_ula_jalr: std_logic_vector(31 downto 0);
	
	component riscv_uniciclo port(
		
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
	end component;
	
	begin
	i1:riscv_uniciclo
	
		port map(
		
--		clock_fetch => clock_fetch, 
--		clock_MI => clock_MI, 
--		clock_breg => clock_breg, 
--		clock_MD => clock_MD,
		
		clock => clock,
		clock_m => clock_m,
		signalout_reset => signalout_reset,
		
		--Sinais de PC
		signalout_pc => signalout_pc,
		signalout_pc4 => signalout_pc4,
		signalout_pc_proximo => signalout_pc_proximo,
		signalout_pc_salto => signalout_pc_salto,
		signalout_pc_selecionado => signalout_pc_selecionado,
		signalout_mux_ula_out => signalout_mux_ula_out,
		signalout_mux_ula_1 => signalout_mux_ula_1,
		
		signalout_instrucao => signalout_instrucao,
		
		--Sinais do xregs
		signalout_r_out1 => signalout_r_out1,
		signalout_r_out2 => signalout_r_out2,
		signalout_rs1 => signalout_rs1,
		signalout_rs2 => signalout_rs2,
		signalout_rd => signalout_rd,
		signalout_banco_input => signalout_banco_input,
		signalout_banco_data_write => signalout_banco_data_write,
		
		signalout_control_branch => signalout_control_branch,
		signalout_control_memread => signalout_control_memread,
		signalout_control_memtoreg => signalout_control_memtoreg,
		signalout_control_aluop => signalout_control_aluop,
		signalout_control_memwrite => signalout_control_memwrite,
		signalout_control_alusrc => signalout_control_alusrc,
		signalout_control_regwrite => signalout_control_regwrite,
		signalout_control_reg_data => signalout_control_reg_data,
		signalout_pc_ctrl => signalout_pc_ctrl,
		signalout_control_lui => signalout_control_lui,
		
		signalout_saida_ula => signalout_saida_ula, 
		signalout_ula_in_1 => signalout_ula_in_1,
		signalout_ula_in_2 => signalout_ula_in_2,
		signalout_ula_zero => signalout_ula_zero,
		signalout_ula_less => signalout_ula_less,
		
		signalout_beq => signalout_beq,
		signalout_bne => signalout_bne,
		signalout_blt => signalout_blt,
		signalout_bge => signalout_bge,
		signalout_mux_comparado => signalout_mux_comparado,
		
		signalout_saida_imm_gerador => signalout_saida_imm_gerador,
		signalout_saida_mem_dado => signalout_saida_mem_dado,
		
		signalout_f3_concatenado => signalout_f3_concatenado,
		signalout_imm_shiftado => signalout_imm_shiftado,
		signalout_ula_jalr => signalout_ula_jalr
		);
		
init: process
		begin
			signalout_reset <= '1';
			wait for 10 ps;
			signalout_reset <= '0';
			wait;
		end process;
	
genclk: process begin

			clock <= '1';
			wait for 20 ps;
			clock <= '0';
			wait for 20 ps;
			
		end process;
		
genclkm: process begin

			clock_m <= '1';
			wait for 1 ps;
			clock_m <= '0';
			wait for 1 ps;
			
		end process;
			
			
--		clock: process
--			begin
--				signalout_reset <= '1';
--				clock_MD <= '0';
--				clock_MI <= '0';
--				clock_breg <= '0';
--				clock_fetch <= '0';
--				wait for 10 ps;
--				signalout_reset <= '0';
--				for x in 1 to 10000 loop
--					
--					clock_MD <= '0';
--					clock_MI <= '1';
--					clock_breg <= '0';
--					clock_fetch <= '0';
--					wait for 2 ps;
--					
--					clock_MD <= '1';
--					clock_MI <= '0';
--					clock_breg <= '0';
--					clock_fetch <= '0';
--					wait for 2 ps;
--					
--					clock_MD <= '0';
--					clock_MI <= '0';
--					clock_breg <= '1';
--					clock_fetch <= '0';
--					wait for 2 ps;
--					
--					clock_MD <= '0';
--					clock_MI <= '0';
--					clock_breg <= '0';
--					clock_fetch <= '1';
--					wait for 2 ps;
--				end  loop;
--				
--		end process clock;
end architecture test;