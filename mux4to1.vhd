library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux4to1 is
	port(
		input0	:	in std_logic;
		input1	:	in std_logic;
		input2	:	in std_logic;
		input3	:	in std_logic;
		sel_b		: 	in std_logic_vector(1 downto 0);
		output	: 	out std_logic
	);	
end mux4to1;

architecture behavior_mux4to1 of mux4to1 is
begin 	
	process(sel_b, input0, input1, input2, input3) begin
		
		if sel_b = "00" then
			output <= input0;
		elsif sel_b = "01" then
			output <= input1;
		elsif sel_b = "10" then
			output <= input2;
		elsif sel_b = "11" then
			output <= input3;
		end if;
		
	end process;
end architecture behavior_mux4to1;

