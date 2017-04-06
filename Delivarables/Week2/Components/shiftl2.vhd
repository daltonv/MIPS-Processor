library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shiftl2 is
	generic (
        WIDTH : positive := 16);
	port(
		input  : in  std_logic_vector(WIDTH-1 downto 0);
		output : out std_logic_vector(WIDTH+2-1 downto 0)
	);
end shiftl2;

architecture BHV of shiftl2 is
begin
  
  output <="00" & std_logic_vector(unsigned(input) sll 2);

end BHV;