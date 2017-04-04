library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity memory_tb is
end memory_tb;

architecture TB of memory_tb is
	--clocks
	signal clk			: std_logic := '0';
	signal rst 		: std_logic;

	--data inputs
	signal input1 		: std_logic_vector(9 downto 0) := (others => '0');
	signal input2 		: std_logic_vector(9 downto 0) := (others => '0');
	signal input1_en 	: std_logic := '0';
	signal input2_en 	: std_logic := '0';
	signal wren 		: std_logic := '0';
	signal MemRead		: std_logic := '0';
	signal address 		: std_logic_vector(31 downto 0) := (others => '0');
	signal output 		: std_logic_vector(31 downto 0) := (others => '0');
	signal data_in 		: std_logic_vector(31 downto 0) := (others => '0');
	signal data_out 	: std_logic_vector(31 downto 0) := (others => '0');

	signal done		: std_logic := '0';

begin

	U_MEMORY : entity work.memory
		port map(
			clk => clk,
			rst => rst,
			input1 => input1,
			input2 => input2,
			input1_en => input1_en,
			input2_en => input2_en,
			wren => wren,
			MemRead => MemRead,
			address => address,
			output => output,
			data_in => data_in,
			data_out => data_out
		);

	clk <= not clk and not done after 10 ns;
	
	process
	begin
		wren <= '0';

		rst      <= '1';
		wait for 100 ns;
		rst 	 <= '0';



		input1 <= conv_std_logic_vector(4, input1'length);
		input2 <= conv_std_logic_vector(752, input2'length);
		input1_en <= '1';
		input2_en <= '1';

		MemRead <= '0';

		wait for 40 ns;

		input1_en <= '0';
		input2_en <= '0';
		input1 <= conv_std_logic_vector(0, input1'length);
		input2 <= conv_std_logic_vector(0, input2'length);

		address <= conv_std_logic_vector(65528, address'length);

		wait for 40 ns;

		assert(data_out = 4) report "input1 not loaded correctly";

		address <= conv_std_logic_vector(65532, address'length);

		wait for 40 ns;

		assert(data_out = 752) report "input2 not loaded correctly";

		wren <= '1';
		address <= conv_std_logic_vector(65532,address'length);
		data_in <= conv_std_logic_vector(323, data_in'length);

		wait for 40 ns;

		assert(output = 323) report "input2 not loaded correctly";

		wren <= '0';
		address <= conv_std_logic_vector(4,address'length);
		MemRead <= '1';

		wait for 40 ns;

		address <= conv_std_logic_vector(8,address'length);

		wait for 40 ns;

		done <= '1';
		report "simulation finished";
		wait;
		
	end process;
end TB;