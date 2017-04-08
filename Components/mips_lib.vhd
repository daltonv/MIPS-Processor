library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package MIPS_LIB is
  --OPCODES
  constant RTYPE  : std_logic_vector(5 downto 0) := std_logic_vector(resize(unsigned'(x"00"),6));
  constant ADDI   : std_logic_vector(5 downto 0) := std_logic_vector(resize(unsigned'(x"09"),6));
  constant SUBI   : std_logic_vector(5 downto 0) := std_logic_vector(resize(unsigned'(x"10"),6));
  constant ANDI   : std_logic_vector(5 downto 0) := std_logic_vector(resize(unsigned'(x"0C"),6));
  constant ORI    : std_logic_vector(5 downto 0) := std_logic_vector(resize(unsigned'(x"0D"),6));
  constant XORI   : std_logic_vector(5 downto 0) := std_logic_vector(resize(unsigned'(x"0E"),6));
  constant SLTI   : std_logic_vector(5 downto 0) := std_logic_vector(resize(unsigned'(x"0A"),6));
  constant SLTU   : std_logic_vector(5 downto 0) := std_logic_vector(resize(unsigned'(x"0B"),6));
  constant LW     : std_logic_vector(5 downto 0) := std_logic_vector(resize(unsigned'(x"23"),6));
  constant SW     : std_logic_vector(5 downto 0) := std_logic_vector(resize(unsigned'(x"2B"),6));
  constant BEQ    : std_logic_vector(5 downto 0) := std_logic_vector(resize(unsigned'(x"04"),6));
  constant BNE    : std_logic_vector(5 downto 0) := std_logic_vector(resize(unsigned'(x"05"),6));
  constant BLEZ   : std_logic_vector(5 downto 0) := std_logic_vector(resize(unsigned'(x"06"),6));
  constant BGTZ   : std_logic_vector(5 downto 0) := std_logic_vector(resize(unsigned'(x"07"),6));
  constant BLTZ   : std_logic_vector(5 downto 0) := std_logic_vector(resize(unsigned'(x"01"),6));
  constant BGEZ   : std_logic_vector(5 downto 0) := std_logic_vector(resize(unsigned'(x"08"),6)); --actually one
  constant J      : std_logic_vector(5 downto 0) := std_logic_vector(resize(unsigned'(x"02"),6));
  constant JAL    : std_logic_vector(5 downto 0) := std_logic_vector(resize(unsigned'(x"03"),6));
  
  --ALU Function Codes
  constant ADDU   : std_logic_vector(5 downto 0) := std_logic_vector(resize(unsigned'(x"21"),6));
  constant SUBU   : std_logic_vector(5 downto 0) := std_logic_vector(resize(unsigned'(x"23"),6));
  constant MULT   : std_logic_vector(5 downto 0) := std_logic_vector(resize(unsigned'(x"18"),6));
  constant MULTU  : std_logic_vector(5 downto 0) := std_logic_vector(resize(unsigned'(x"19"),6));
  constant ANDU   : std_logic_vector(5 downto 0) := std_logic_vector(resize(unsigned'(x"24"),6));
  constant ORU    : std_logic_vector(5 downto 0) := std_logic_vector(resize(unsigned'(x"25"),6));
  constant XORU   : std_logic_vector(5 downto 0) := std_logic_vector(resize(unsigned'(x"26"),6));
  constant CSRL   : std_logic_vector(5 downto 0) := std_logic_vector(resize(unsigned'(x"02"),6));
  constant CSLL   : std_logic_vector(5 downto 0) := std_logic_vector(resize(unsigned'(x"00"),6));
  constant CSRA   : std_logic_vector(5 downto 0) := std_logic_vector(resize(unsigned'(x"03"),6));
  constant CSLT   : std_logic_vector(5 downto 0) := std_logic_vector(resize(unsigned'(x"2A"),6));
  constant CSLTU  : std_logic_vector(5 downto 0) := std_logic_vector(resize(unsigned'(x"2B"),6));
  constant MFHI   : std_logic_vector(5 downto 0) := std_logic_vector(resize(unsigned'(x"10"),6));
  constant MFLO   : std_logic_vector(5 downto 0) := std_logic_vector(resize(unsigned'(x"12"),6));
  constant JR     : std_logic_vector(5 downto 0) := std_logic_vector(resize(unsigned'(x"08"),6));

end MIPS_LIB;