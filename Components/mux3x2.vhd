library ieee;
use ieee.std_logic_1164.all;

entity mux3x2 is
	generic (
        WIDTH : positive := 16);
	port(
		in1    : in  std_logic_vector(WIDTH-1 downto 0);
		in2    : in  std_logic_vector(WIDTH-1 downto 0);
    in3    : in  std_logic_vector(WIDTH-1 downto 0);
		sel    : in  std_logic_vector(1 downto 0);
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
    end if;
	
  end process;
end IF_STATEMENT;