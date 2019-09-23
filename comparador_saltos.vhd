library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparador_saltos is
	port(
		signal_zero : in std_logic;
		signal_less : in std_logic;
		signal_branch : in std_logic;
		signal_beq : out std_logic;
		signal_bne : out std_logic;
		signal_blt : out std_logic;
		signal_bge : out std_logic
	);
end comparador_saltos;

architecture behavior_branch of comparador_saltos is

begin
	process(signal_zero, signal_less, signal_branch)
	begin
		signal_beq <= signal_branch and signal_zero;
		signal_bne <= signal_branch and not signal_zero;
		signal_blt <= signal_branch and signal_less;
		signal_bge <= signal_branch and not signal_less;
	end process;
end architecture behavior_branch;

