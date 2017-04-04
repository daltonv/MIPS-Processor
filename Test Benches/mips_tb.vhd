library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.MIPS_LIB.all;
use ieee.numeric_std.all;

entity mips_tb is
end mips_tb;

architecture TB of mips_tb is
	--clocks
	signal clk			: std_logic := '0';
	signal rst 		: std_logic;

	--data i/0
	signal input1 		: std_logic_vector(9 downto 0) := (others => '0');
	signal input2 		: std_logic_vector(9 downto 0) := (others => '0');
	signal input1_en 	: std_logic := '0';
	signal input2_en 	: std_logic := '0';
	signal output 		: std_logic_vector(31 downto 0) := (others => '0');

	signal done		: std_logic := '0';
begin

	U_MIPS : entity work.mips
		port map(
			clk => clk,
			rst => rst,
			input1 => input1,
			input2 => input2,
			input1_en => input1_en,
			input2_en => input2_en,
			output => output
		);

	clk <= not clk and not done after 10 ns;

	process
	begin

		rst      <= '1';
		wait for 20 ns;
		rst 	 <= '0';

	end process;
	
end TB;