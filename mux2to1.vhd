library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux2to1 is
	port(
		input0	:	in std_logic_vector(31 downto 0);
		input1	:	in std_logic_vector(31 downto 0);
		sel_b		: 	in std_logic;
		output	: 	out std_logic_vector(31 downto 0)
	);	
end mux2to1;

architecture behavior_mux2to1 of mux2to1 is
begin 	
	process(sel_b, input1, input0) begin
		
		if (sel_b = '0') then
			output <= input0;
		elsif (sel_b = '1') then
			output <= input1;
		end if;
	
	end process;
end architecture behavior_mux2to1;

