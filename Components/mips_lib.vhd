library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package MIPS_LIB is
  --OPCODES
  constant RTYPE  : std_logic_vector(5 downto 0) := x"00";
  constant ADDI   : std_logic_vector(5 downto 0) := x"09";
  constant SUBI   : std_logic_vector(5 downto 0) := x"10";
  constant ANDI   : std_logic_vector(5 downto 0) := x"0C";
  constant ORI    : std_logic_vector(5 downto 0) := x"0D";
  constant XORI   : std_logic_vector(5 downto 0) := x"0E";
  constant SLTI   : std_logic_vector(5 downto 0) := x"0A";
  constant SLTU   : std_logic_vector(5 downto 0) := x"0B";
  constant LW     : std_logic_vector(5 downto 0) := x"23";
  constant SW     : std_logic_vector(5 downto 0) := x"2B";
  constant BEQ    : std_logic_vector(5 downto 0) := x"04";
  constant BNE    : std_logic_vector(5 downto 0) := x"05";
  constant BLEZ   : std_logic_vector(5 downto 0) := x"06";
  constant BGTZ   : std_logic_vector(5 downto 0) := x"07";
  constant BLTZ   : std_logic_vector(5 downto 0) := x"01";
  constant BGEZ   : std_logic_vector(5 downto 0) := x"01";
  constant J      : std_logic_vector(5 downto 0) := x"02";
  constant JAL    : std_logic_vector(5 downto 0) := x"03";
  
  --ALU Function Codes
  constant ADDU   : std_logic_vector(5 downto 0) := x"21";
  constant SUBU   : std_logic_vector(5 downto 0) := x"23";
  constant MULT   : std_logic_vector(5 downto 0) := x"18";
  constant MULTU  : std_logic_vector(5 downto 0) := x"19";
  constant ANDU   : std_logic_vector(5 downto 0) := x"24";
  constant ORU    : std_logic_vector(5 downto 0) := x"25";
  constant CSRL   : std_logic_vector(5 downto 0) := x"02";
  constant CSLL   : std_logic_vector(5 downto 0) := x"00";
  constant CSRA   : std_logic_vector(5 downto 0) := x"03";
  constant CSLT   : std_logic_vector(5 downto 0) := x"2A";
  constant MFHI   : std_logic_vector(5 downto 0) := x"10";
  constant MFLO   : std_logic_vector(5 downto 0) := x"12";
  constant JR     : std_logic_vector(5 downto 0) := x"08";

end MIPS_LIB;