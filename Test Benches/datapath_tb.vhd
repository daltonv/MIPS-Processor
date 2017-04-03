library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity datapath_tb is
end datapath_tb;

architecture TB of datapath_tb is

	signal clk	: std_logic := '0';
	signal rst : std_logic;
	signal input1 : std_logic_vector(31 downto 0);
	signal input2 : std_logic_vector(31 downto 0);
	signal input1_en : std_logic;
	signal input2_en : std_logic;
	signal output : std_logic_vector(31 downto 0);

	--controller signals
	signal MemToReg			: std_logic; --select between “Memory data register” or “ALU output” as input 
										 --to “write data” signal.
	signal RegDst			: std_logic; --select between IR20-16 or IR15-11 as the input to the “Write Reg”
	signal RegWrite			: std_logic; --enables the register file 
	signal JumpAndLink 		: std_logic; -- when asserted, $s31 will be selected as the write register.
	signal PCWriteCond		: std_logic; --enables the PC register if the “Branch” signal is asserted. 
	signal PCWrite 			: std_logic; --enables the PC register.
	signal IorD 			: std_logic; --select between the PC or the ALU output as the memory address.
	signal ALUSrcA			: std_logic_vector(1 downto 0);
	signal ALUSrcB			: std_logic_vector(2 downto 0);
	signal PCSource			: std_logic_vector(1 downto 0);
	signal MemWrite	: std_logic;
	signal mem_address : std_logic_vector(31 downto 0) := (others => '0');

	signal done		: std_logic := '0';

begin

	UUT : entity work.datapath
		generic map(
			width => 32
		)
		port map (
			clk => clk,
			rst => rst,
			input1 => input1,
			input2 => input2,
			input1_en => input1_en,
			input2_en => input2_en,
			output => output,
			MemToReg => MemToReg,
			RegDst => RegDst,
			RegWrite => RegWrite,
			JumpAndLink => JumpAndLink,
			PCWriteCond => PCWriteCond,
			PCWrite => PCWrite,
			IorD => IorD,
			ALUSrcA => ALUSrcA,
			ALUSrcB => ALUSrcB,
			PCSource => PCSource,
			MemWrite => MemWrite,
			mem_address => mem_address
		);

		clk <= not clk and not done after 10 ns;

		process
		begin

			rst      <= '1';
			wait for 100 ns;
			rst 	 <= '0';

			input1 <= "11111111111111111111111111111110";
			input2 <= conv_std_logic_vector(752, input2'length);
			input1_en <= '1';
			input2_en <= '1';

			wait for 40 ns;

			input1_en <= '0';
			input2_en <= '0';
			input1 <= conv_std_logic_vector(0, input1'length);
			input2 <= conv_std_logic_vector(0, input2'length);

			mem_address <= conv_std_logic_vector(65528, mem_address'length);

			ALUSrcB <= conv_std_logic_vector(2,ALUSrcB'length);

			MemToReg <= '1';

			wait for 40 ns;

			done <= '1';
			wait;


		end process;

end TB;