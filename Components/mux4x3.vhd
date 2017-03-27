library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux4x3 is
	generic (
        WIDTH : positive := 16);
	port(
		in1    : in  std_logic_vector(WIDTH-1 downto 0);
		in2    : in  std_logic_vector(WIDTH-1 downto 0);
    in3    : in  std_logic_vector(WIDTH-1 downto 0);
    in4    : in  std_logic_vector(WIDTH-1 downto 0);
		sel    : in  std_logic_vector(2 downto 0);
		output : out std_logic_vector(WIDTH-1 downto 0)
	);
end mux3x2;

architecture IF_STATEMENT of mux3x2 is
begin

  process(in1, in2, sel)
  begin
  
    if (unsigned(sel) = unsigned(0)) then
      output <= in1;
    elsif (unsigned(sel) = unsigned(1)) then
      output <= in2;
    elsif (unsigned(sel) = unsigned(2)) then
      output <= in3;
    elsif (unsigned(sel) = unsigned(3)) then
      output <= in4;
    end if;
	
  end process;
end IF_STATEMENT;