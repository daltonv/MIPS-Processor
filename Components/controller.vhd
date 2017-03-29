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
		PCWRiteCond : out std_logic;
		PCWrite : out std_logic;
		IorD : out std_logic;
		MemRead : out std_logic;
		MemToReg : out std_logic;
		IRWrite : out std_logic;
		JumpAndLink : out std_logic;
		isSigned : out std_logic;
		PCSource : out std_logic;
		ALUOp : out std_logic;
		ALUSrcB : out std_logic;
		ALUSrcA : out std_logic;
		RegWrite : out std_logic;
		RegDst : out std_logic
	);
end controller;