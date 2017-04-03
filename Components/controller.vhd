library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controller is
	generic (
		WIDTH : positive := 32
	);
	port (
		clk	: in std_logic;
		rst : in std_logic;
		data : in std_logic_vector(4 downto 0);
		MemToReg		: out std_logic; --select between â€œMemory data registerâ€ or â€œALU outputâ€ as input 
											 --to â€œwrite dataâ€ signal.
		RegDst			: out std_logic; --select between IR20-16 or IR15-11 as the input to the â€œWrite Regâ€
		RegWrite		: out std_logic; --enables the register file 
		JumpAndLink 	: out std_logic; -- when asserted, $s31 will be selected as the write register.
		PCWriteCond		: out std_logic; --enables the PC register if the â€œBranchâ€ signal is asserted. 
		PCWrite 		: out std_logic; --enables the PC register.
		IorD 			: out std_logic; --select between the PC or the ALU output as the memory address.
		ALUSrcA			: out std_logic; --select between the PC or the A reg
		ALUSrcB			: out std_logic_vector(2 downto 0);
		PCSource		: out std_logic_vector(1 downto 0);
		MemWrite		: out std_logic
	);
end controller;