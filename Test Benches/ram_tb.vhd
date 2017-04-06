library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.MIPS_LIB.all;
use ieee.numeric_std.all;

entity ram_tb is
end ram_tb;

architecture TB of ram_tb is
	--clocks
	signal clk			: std_logic := '0';
	signal rst 		: std_logic;

	--data i/0
	signal address : std_logic_vector(7 downto 0) := (others => '0');
	signal data 		: std_logic_vector(31 downto 0) := (others => '0');
	signal rden			: std_logic := '0';
	signal wren 		: std_logic := '0';
	signal q			: std_logic_vector(31 downto 0);
	

	signal done		: std_logic := '0';
begin

	U_RAM : entity work.ram
		port map(
			address => address,
			clock => clk,
			data => data,
			rden => rden,
			wren => wren,
			q => q
		);

	clk <= not clk and not done after 10 ns;
	
	process
	begin
		rden <= '1';



		address <= x"00";
		wait for 20 ns;

		address <= x"04";
		wait for 20 ns;

		address <= x"08";
		wait for 20 ns;

		address <= x"0C";
		wait for 20 ns;

		address <= x"10";
		wait for 20 ns;

		address <= x"14";
		wait for 20 ns;

		address <= x"18";
		wait for 20 ns;

		address <= x"1C";
		wait for 20 ns;

		address <= x"20";
		wait for 20 ns;

		done <= '1';
		report "simulation finished";
		wait;
		
	end process;
end TB;