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
	signal MemWrite			: std_logic := '0';
	signal MemRead 			: std_logic := '0';
	signal IRWrite			: std_logic := '0';
	signal ALUOp			: std_logic_vector(1 downto 0) := (others => '0');
	signal opcode 			: std_logic_vector(5 downto 0) := (others => '0');
	signal isSigned			: std_logic := '1';

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
			opcode => opcode,
			isSigned => isSigned
		);

	clk <= not clk and not done after 10 ns;

	process
	begin

		rst      <= '1';
		wait for 40 ns;
		rst 	 <= '0';

		--instr fetch
		MemRead <= '1';
		ALUSrcB <= "01"; --select constant 4
		ALUOp <= "00"; --something with alu control
		PCWrite <= '1'; --allow PC to be written too

		wait until clk = '1';

		--instr decode
		PCWrite <= '0'; --allow PC to be written too
		IRWrite <= '1';
		MemRead <= '0';
		ALUSrcB <= "11";
		wait for 1 ns;		

		wait until clk = '1';

		assert(opcode = LW) report "opcode not working = " & integer'image(conv_integer(opcode)) severity warning;

		--mem compute
		IRWrite <= '0';
		ALUSrcA <= '1';
		ALUSrcB <= "10";
		ALUOp <= "00";

		wait until clk = '1';

		--LW
		ALUSrcA <= '1';
		ALUSrcB <= "10";
		MemRead <= '1';
		IorD <= '1'; 

		wait until clk = '1';

		--mem complete
		ALUSrcA <= '0';
		ALUSrcB <= "00";
		MemRead <= '0';
		IorD <= '1';
		RegWrite <= '1'; --allow writing reg
		RegDst <= '0'; --select write reg in reg file
		MemtoReg <= '1'; --use alu data for reg

		wait until clk = '1';

		IorD <= '0';
		RegWrite <= '0'; --allow writing reg
		MemtoReg <= '0';

		--instr fetch
		MemRead <= '1';
		ALUSrcB <= "01"; --select constant 4
		ALUOp <= "00"; --something with alu control
		PCWrite <= '1'; --allow PC to be written too

		wait until clk = '1';

		--instr decode
		PCWrite <= '0'; --allow PC to be written too
		IRWrite <= '1';
		MemRead <= '0';
		ALUSrcB <= "11";
		wait for 1 ns;
				

		wait until clk = '1';

		assert(opcode = LW) report "opcode not working = " & integer'image(conv_integer(opcode)) severity warning;
		--mem compute
		IRWrite <= '0';
		ALUSrcA <= '1';
		ALUSrcB <= "10";
		ALUOp <= "00";

		wait until clk = '1';

		--LW
		ALUSrcA <= '0';
		ALUSrcB <= "00";
		MemRead <= '1';
		IorD <= '1'; 

		wait until clk = '1';

		--mem complete
		MemRead <= '0';
		IorD <= '0';
		RegWrite <= '1'; --allow writing reg
		RegDst <= '0'; --select write reg in reg file
		MemtoReg <= '1'; --use alu data for reg

		wait until clk = '1';

		RegWrite <= '0'; --allow writing reg
		MemtoReg <= '0';
		
		--instr fetch
		MemRead <= '1';
		ALUSrcB <= "01"; --select constant 4
		ALUOp <= "00"; --something with alu control
		PCWrite <= '1'; --allow PC to be written too

		wait until clk = '1';

		--instr decode
		PCWrite <= '0';
		IRWrite <= '1';
		MemRead <= '0';
		ALUSrcB <= "11";
		wait for 1 ns;
		

		wait until clk = '1';

		assert(opcode = RTYPE) report "opcode not working = " & integer'image(conv_integer(opcode)) severity warning;
		-- rtype execute
		IRWrite <= '0';
		ALUSrcA <= '1';
		ALUSrcB <= "00";
		ALUOp <= "10";

		wait until clk = '1';

		--rtype complete
		ALUSrcA <= '0';
		ALUOp <= "00";
		RegDst <= '1';
		RegWrite <= '1';
		MemtoReg <= '0';

		wait until clk = '1';

		RegWrite <= '0';
		RegDst <= '0';

		--instr fetch
		MemRead <= '1';
		ALUSrcB <= "01"; --select constant 4
		ALUOp <= "00"; --something with alu control
		PCWrite <= '1'; --allow PC to be written too

		wait until clk = '1';

		--instr decode
		PCWrite <= '0';
		IRWrite <= '1';
		MemRead <= '0';
		ALUSrcB <= "11";
		wait for 1 ns;
		
		wait until clk = '1';

		assert(opcode = ANDI) report "opcode not working = " & integer'image(conv_integer(opcode)) severity warning;
		-- itype execute
		IRWrite <= '0';
		ALUSrcA <= '1';
		ALUSrcB <= "10";
		ALUOp <= "11";

		wait until clk = '1';

		--itype complete
		ALUSrcA <= '0';
		ALUOp <= "00";
		RegDst <= '0';
		RegWrite <= '1';
		MemtoReg <= '0';

		input2 <= conv_std_logic_vector(752, input2'length);
		input2_en <= '1';

		wait until clk = '1';

		RegWrite <= '0';
		RegDst <= '0';

		--instr fetch
		MemRead <= '1';
		ALUSrcB <= "01"; --select constant 4
		ALUOp <= "00"; --something with alu control
		PCWrite <= '1'; --allow PC to be written too

		wait until clk = '1';

		--instr decode
		PCWrite <= '0'; --allow PC to be written too
		IRWrite <= '1';
		MemRead <= '0';
		ALUSrcB <= "11";
		wait for 1 ns;
				
		wait until clk = '1';

		assert(opcode = LW) report "opcode not working = " & integer'image(conv_integer(opcode)) severity warning;
		--mem compute
		IRWrite <= '0';
		ALUSrcA <= '1';
		ALUSrcB <= "10";
		ALUOp <= "00";
		isSigned <= '0';

		wait until clk = '1';

		--LW
		ALUSrcA <= '1';
		ALUSrcB <= "10";
		MemRead <= '1';
		IorD <= '1'; 

		wait until clk = '1';

		--mem complete
		ALUSrcA <= '0';
		ALUSrcB <= "00";
		MemRead <= '0';
		IorD <= '1';
		RegWrite <= '1'; --allow writing reg
		RegDst <= '0'; --select write reg in reg file
		MemtoReg <= '1'; --use alu data for reg

		wait until clk = '1';

		IorD <= '0';
		RegWrite <= '0'; --allow writing reg
		MemtoReg <= '0';

		--instr fetch
		MemRead <= '1';
		ALUSrcB <= "01"; --select constant 4
		ALUOp <= "00"; --something with alu control
		PCWrite <= '1'; --allow PC to be written too

		wait until clk = '1';

		--instr decode
		PCWrite <= '0'; --allow PC to be written too
		IRWrite <= '1';
		MemRead <= '0';
		ALUSrcB <= "11";
		wait for 1 ns;
				
		wait until clk = '1';

		assert(opcode = SW) report "opcode not working = " & integer'image(conv_integer(opcode)) severity warning;
		--mem compute
		IRWrite <= '0';
		ALUSrcA <= '1';
		ALUSrcB <= "10";
		ALUOp <= "00";
		isSigned <= '0';

		wait until clk = '1';

		--SW
		ALUSrcA <= '0';
		ALUSrcB <= "00";
		MemWrite <= '1';
		isSigned <= '0';
		IorD <= '1'; 

		wait until clk = '1';

		IorD <= '0';
		isSigned <= '1';
		MemWrite <= '0';

		--instr fetch
		MemRead <= '1';
		ALUSrcB <= "01"; --select constant 4
		ALUOp <= "00"; --something with alu control
		PCWrite <= '1'; --allow PC to be written too

		wait until clk = '1';

		--instr decode
		PCWrite <= '0'; --allow PC to be written too
		IRWrite <= '1';
		MemRead <= '0';
		ALUSrcB <= "11";
		wait for 1 ns;
				
		wait until clk = '1';

		assert(opcode = SW) report "opcode not working = " & integer'image(conv_integer(opcode)) severity warning;
		--mem compute
		IRWrite <= '0';
		ALUSrcA <= '1';
		ALUSrcB <= "10";
		ALUOp <= "00";
		isSigned <= '0';

		wait until clk = '1';

		--SW
		ALUSrcA <= '0';
		ALUSrcB <= "00";
		MemWrite <= '1';
		isSigned <= '0';
		IorD <= '1'; 

		wait until clk = '1';

		IorD <= '0';
		isSigned <= '1';
		MemWrite <= '0';

		--instr decode
		PCWrite <= '0'; --allow PC to be written too
		IRWrite <= '1';
		MemRead <= '0';
		ALUSrcB <= "11";
		wait for 1 ns;
				
		wait until clk = '1';

		assert(opcode = LW) report "opcode not working = " & integer'image(conv_integer(opcode)) severity warning;
		--mem compute
		IRWrite <= '0';
		ALUSrcA <= '1';
		ALUSrcB <= "10";
		ALUOp <= "00";
		isSigned <= '0';

		wait until clk = '1';

		--LW
		ALUSrcA <= '1';
		ALUSrcB <= "10";
		MemRead <= '1';
		IorD <= '1'; 

		wait until clk = '1';

		--mem complete
		ALUSrcA <= '0';
		ALUSrcB <= "00";
		MemRead <= '0';
		IorD <= '1';
		RegWrite <= '1'; --allow writing reg
		RegDst <= '0'; --select write reg in reg file
		MemtoReg <= '1'; --use alu data for reg

		wait until clk = '1';

		IorD <= '0';
		RegWrite <= '0'; --allow writing reg
		MemtoReg <= '0';

		wait for 40 ns;

		done <= '1';
		wait;


	end process;

end TB;