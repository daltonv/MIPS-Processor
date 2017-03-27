library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity alu is 
	generic (
		WIDTH : positive := 32
	);
	port (
		input1			: in std_logic_vector(WIDTH-1 downto 0);
		input2			: in std_logic_vector(WIDTH-1 downto 0);
		op				: in std_logic_vector(4 downto 0);
		branch_taken	: out std_logic;
		result_LO		: out std_logic_vector(WIDTH-1 downto 0);
		result_HI		: out std_logic_vector(WIDTH-1 downto 0);
	);
end alu;

architecture BHV of alu is

	--constants for mips instruction op codes
	constant C_ADD 		: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(0,5));
	constant C_ADD_IM 	: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(1,5));
	constant C_SUB 		: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(2,5));
	constant C_SUB_IM	: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(3,5));
	constant C_MULT 	: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(4,5));
	constant C_MULT_UN 	: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(5,5));
	constant C_AND  	: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(6,5));
	constant C_ANDI  	: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(7,5));
	constant C_OR  		: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(8,5));
	constant C_ORI 		: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(9,5));
	constant C_XOR  	: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(10,5));
	constant C_XORI  	: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(11,5));
	constant C_SRL  	: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(12,5));
	constant C_SLL  	: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(13,5));
	constant C_SRA  	: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(14,5));
	constant C_SLT  	: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(15,5));
	constant C_SLTI		: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(16,5));
	constant C_SLTIU	: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(17,5));
	constant C_SLTU		: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(18,5));
	constant C_MFHI		: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(19,5));
	constant C_MFLO		: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(20,5));
	constant C_LW		: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(21,5));
	constant C_SW		: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(22,5));
	constant C_BEQ		: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(23,5));
	constant C_BNE		: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(24,5));
	constant C_BLEZ		: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(25,5));
	constant C_BGTZ		: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(26,5));
	constant C_BLTZ		: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(27,5));
	constant C_BGEZ		: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(28,5));
	constant C_J		: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(29,5));
	constant C_JAL		: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(30,5));
	constant C_JR		: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(31,5));
	constant C_HALT		: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(32,5));

begin

end BHV;