library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sign_extend is
	generic (
        WIDTH : positive := 16);
	port(
		input  : in  std_logic_vector(WIDTH-1 downto 0);
		output : out std_logic_vector(WIDTH*2-1 downto 0)
	);
end sign_extend;

architecture BHV of sign_extend is
begin
  
  output <= std_logic_vector(resize(signed(input), output'length));

end BHV;