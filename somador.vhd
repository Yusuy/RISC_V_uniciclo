library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity somador is
	port (
		inputadd_0      : in std_logic_vector(31 downto 0);
		inputadd_1     : in std_logic_vector(31 downto 0);
		outputadd    : out std_logic_vector(31 downto 0)
	);
end somador;

architecture adder_behave of somador is
	signal add32: std_logic_vector(31 downto 0);
begin
	sominha : process(add32, inputadd_0, inputadd_1)
	begin
		add32 <= std_logic_vector(unsigned(inputadd_0)+unsigned(inputadd_1));
		outputadd <= add32;
	end process sominha;
end architecture adder_behave;