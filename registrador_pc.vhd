library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registrador_pc is
	port(
		pc_in		: in std_logic_vector(31 downto 0);
		clock : in std_logic;
		pc_rst	: in std_logic;
		pc_out	: out std_logic_vector(31 downto 0)
	);
end registrador_pc;

architecture behavior_pc of registrador_pc is
	constant vzero : std_logic_vector(31 downto 0) := X"00000000";
begin 	
	process(pc_in, clock, pc_rst) begin
		if (pc_rst = '1') then
			pc_out <= vzero;
		elsif (rising_edge(clock)) then
			pc_out <= pc_in;
		end if;
	end process;
end architecture behavior_pc;

