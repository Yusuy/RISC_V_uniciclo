library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is
	port (
		opcode_ULA : in std_logic_vector(3 downto 0);
		A, B   : in std_logic_vector(31 downto 0);
		Z      : out std_logic_vector(31 downto 0);
		zero : out std_logic;
		less_than_zero: out std_logic
	);
end ula;

architecture behavior of ula is
	signal a32: std_logic_vector(31 downto 0);
	constant v_zero: std_logic_vector := X"00000000";
	constant v_one: std_logic_vector := X"00000001";
	signal less, zerinho : std_logic;
	
	begin
	ula_RV_calc: process (opcode_ULA, A, B, a32, zerinho, less) 
	begin
		case opcode_ULA is 
			when "0000" => a32 <= std_logic_vector(signed(A) + signed(B));	--add
			when "0001" => a32 <= std_logic_vector(signed(A) - signed(B)); --sub
			when "0010" => a32 <= A and B; --and
			when "0011" => a32 <= A or B; --or
			when "0100" => a32 <= A xor B; --xor
			when "0101" => a32 <= std_logic_vector(shift_left(signed(A), to_integer(unsigned(B)))); --s
			when "0110" => a32 <= std_logic_vector(shift_right(unsigned(A), to_integer(unsigned(B)))); --s
			when "0111" => a32 <= std_logic_vector(shift_right(signed(A), to_integer(unsigned(B)))); --
			when "1000" => if (signed(A) < signed(B)) then a32 <= std_logic_vector(v_one);
									else a32 <= std_logic_vector(v_zero);
								end if;
			when "1001" => if (unsigned(A) < unsigned(B)) then a32 <= std_logic_vector(v_one);
									else a32 <= std_logic_vector(v_zero);
								 end if;
			when "1010" => if (signed(A) >= signed(B)) then a32 <= std_logic_vector(v_one);
									else a32 <= std_logic_vector(v_zero);
								end if;
			when "1011" => if (unsigned(A) >= unsigned(B)) then a32 <= std_logic_vector(v_one);
									else a32 <= std_logic_vector(v_zero);
								 end if;
			when "1100" => if (A = B) then a32 <= std_logic_vector(v_one);
									else a32 <= std_logic_vector(v_zero);
								end if;
			when "1101" => if (A /= B) then a32 <= std_logic_vector(v_one);
									else a32 <= std_logic_vector(v_zero);
								end if;
			when "1110" => a32 <= B;
			when others => a32 <= std_logic_vector(v_zero);
		end case;
			
			
		zero <= zerinho;
		less_than_zero <= less;
		Z <= a32;
		if(a32 = X"00000000") then
					zerinho <= '1';
					less <= '0';
		elsif (a32 > X"00000000") then
					zerinho <= '0'; less <= '0';
		elsif (a32 < X"00000000") then
					zerinho <= '0'; less <= '1';	
		end if;
	end process ula_RV_calc;
	
end architecture behavior;

