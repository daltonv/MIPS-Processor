library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity alu is 
	generic (
		WIDTH : positive := 32
	);
	port (
		input1			: in std_logic_vector(WIDTH-1 downto 0);
		input2			: in std_logic_vector(WIDTH-1 downto 0);
		sel				: in std_logic_vector();
		branch_taken	: out std_logic;
		result_LO		: out std_logic_vector(WIDTH-1 downto 0);
		result_HI		: out std_logic_vector(WIDTH-1 downto 0);
	);
end alu;