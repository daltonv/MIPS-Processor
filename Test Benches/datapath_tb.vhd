library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.MIPS_LIB.all;
use ieee.numeric_std.all;

entity datapath_tb is
end datapath_tb;

architecture TB of datapath_tb is

	signal clk	: std_logic := '0';
	signal rst : std_logic := '0';
	signal input1 : std_logic_vector(9 downto 0) := (others => '0');
	signal input2 : std_logic_vector(9 downto 0) := (others => '0');
	signal input1_en : std_logic := '0';
	signal input2_en : std_logic := '0';
	signal output : std_logic_vector(31 downto 0) := (others => '0');

	--controller signals
	signal MemToReg			: std_logic := '0'; --select between “Memory data register” or “ALU output” as input 
										 --to “write data” signal.
	signal RegDst			: std_logic := '0'; --select between IR20-16 or IR15-11 as the input to the “Write Reg”
	signal RegWrite			: std_logic := '0'; --enables the register file 
	signal JumpAndLink 		: std_logic := '0'; -- when asserted, $s31 will be selected as the write register.
	signal PCWriteCond		: std_logic := '0'; --enables the PC register if the “Branch” signal is asserted. 
	signal PCWrite 			: std_logic := '0'; --enables the PC register.
	signal IorD 			: std_logic := '0'; --select between the PC or the ALU output as the memory address.
	signal ALUSrcA			: std_logic:= '0';
	signal ALUSrcB			: std_logic_vector(1 downto 0) := (others => '0');
	signal PCSource			: std_logic_vector(1 downto 0) := (others => '0');
	signal MemWrite	: std_logic := '0';
	signal MemRead : std_logic := '0';
	signal IRWrite			: std_logic := '0';
	signal ALUOp			: std_logic_vector(1 downto 0) := (others => '0');
	signal opcode 			: std_logic_vector(5 downto 0) := (others => '0');

	signal done		: std_logic := '0';

begin

	U_DATAPATH : entity work.datapath
		generic map (
			width => 32
		)
		port map (
			clk	=> clk,
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
			MemRead => MemRead,		
			IRWrite => IRWrite,		
			ALUOp => ALUOp,
			opcode => opcode
		);

	clk <= not clk and not done after 10 ns;

	process
	begin

		rst      <= '1';
		wait for 40 ns;
		rst 	 <= '0';

		MemRead <= '1';
		ALUSrcB <= "01"; --select constant 4
		ALUOp <= "00"; --something with alu control
		PCWrite <= '1'; --allow PC to be written too

		wait until clk = '1';

		MemRead <= '0';
		IRWrite <= '1';

		wait until clk = '1';

		IRWrite <= '0';
		wait for 1 ns;
		assert(opcode = LW) report "opcode not working = " & integer'image(conv_integer(opcode)) severity warning;

		wait for 40 ns;

		done <= '1';
		wait;


	end process;

end TB;