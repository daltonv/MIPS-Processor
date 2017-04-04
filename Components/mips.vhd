library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mips is
	generic (
		WIDTH : positive := 32
	);
	port (
		clk	: in std_logic;
		rst : in std_logic;
		input1 : in std_logic_vector(9 downto 0);
		input2 : in std_logic_vector(9 downto 0);
		input1_en : in std_logic;
		input2_en : in std_logic;
		output : out std_logic_vector(WIDTH-1 downto 0)
	);
end mips;

architecture FSM_D of mips is
	--control signals
	signal MemToReg			: std_logic; --							 
	signal RegDst			: std_logic; --select between IR20-16 or IR15-11 as the input to the 
	signal RegWrite			: std_logic; --enables the register file 
	signal JumpAndLink 		: std_logic; -- when asserted, $s31 will be selected as the write register.
	signal PCWriteCond		: std_logic; --enables the PC register if 
	signal PCWrite 			: std_logic; --enables the PC register.
	signal IorD 			: std_logic; --select between the PC or the ALU output as the memory address.
	signal ALUSrcA			: std_logic; --select between the PC or the A reg
	signal ALUSrcB			: std_logic_vector(1 downto 0);
	signal PCSource			: std_logic_vector(1 downto 0);
	signal MemWrite			: std_logic;
	signal MemRead			: std_logic;
	signal IRWrite			: std_logic;
	signal ALUOp			: std_logic_vector(1 downto 0);
	signal opcode 			: std_logic_vector(5 downto 0);

begin

	U_DATAPATH : entity work.datapath
		generic map (
			width => width
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

	U_CONTROLLER : entity work.controller
		port map(
			clk => clk,	
			rst => rst, 
			opcode => opcode, 
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
			ALUOp => ALUOp
		);

end FSM_D;