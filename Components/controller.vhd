library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath is
	generic (
		WIDTH : positive := 32
	);
	port (
		clk	: in std_logic;
		rst : in std_logic;
		input1 : in std_logic_vector(WIDTH-1 downto 0);
		input2 : in std_logic_vector(WIDTH-1 downto 0);
		input1_en : in std_logic;
		input2_en : in std_logic;
		output : out std_logic_vector(WIDTH-1 downto 0);
	);
end datapath;