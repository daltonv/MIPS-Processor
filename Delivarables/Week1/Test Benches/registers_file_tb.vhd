library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity registers_file_tb is
end registers_file_tb;

architecture TB of registers_file_tb is
	--clocks
	signal clk			: std_logic := '0';
	signal rst 		: std_logic;

	--data inputs
	signal read_reg_A 	: std_logic_vector(4 downto 0); --select reg for A
	signal read_reg_B 	: std_logic_vector(4 downto 0); --select reg for B
	signal write_reg 	: std_logic_vector(4 downto 0);	--select reg to be written to
	signal write_data 	: std_logic_vector(31 downto 0);	--data to be written to reg

	--ctrls
	signal RegWrite	: std_logic;
	signal JumpAndLink : std_logic;

	--outputs
	signal data_A		: std_logic_vector(31 downto 0);
	signal data_B		: std_logic_vector(31 downto 0);

	signal done		: std_logic := '0';

begin

	UUT : entity work.registers_file
		generic map(
			width => 32
		)
		port map (
			clk => clk,
			rst => rst,
			read_reg_A => read_reg_A,
			read_reg_B => read_reg_B,
			write_reg => write_reg,
			write_data => write_data,
			RegWrite => RegWrite,
			JumpAndLink => JumpAndLink,
			data_A => data_A,
			data_B => data_B
		);

	clk <= not clk and not done after 10 ns;
	process
	begin
		RegWrite <= '0';
		JumpAndLink <= '0';

		rst      <= '1';
		wait for 100 ns;
		rst 	 <= '0';

		write_reg <= conv_std_logic_vector(4, write_reg'length);
		write_data <= conv_std_logic_vector(752, write_data'length);
		RegWrite <= '1';

		wait for 40 ns;

		RegWrite <= '0';
		read_reg_A <= conv_std_logic_vector(4, write_reg'length);

		wait for 40 ns;

		assert(data_A = 752) report "reg4 not loaded correctly";

		write_reg <= conv_std_logic_vector(2, write_reg'length);
		write_data <= conv_std_logic_vector(1023, write_data'length);
		RegWrite <= '1';
		JumpAndLink <= '1';

		wait for 40 ns;

		RegWrite <= '0';
		read_reg_B <= conv_std_logic_vector(31, write_reg'length);

		wait for 40 ns;

		assert(data_B = 1023) report "reg31 not loaded correctly";

		done <= '1';
		report "simulation finished";
		wait;
		
	end process;
end TB;