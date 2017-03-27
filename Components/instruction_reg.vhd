library ieee;
use ieee.std_logic_1164.all;

entity intrsuction_reg is
  port (
    clk    : in  std_logic;
    rst    : in  std_logic;
    en   : in  std_logic;
    input  : in  std_logic_vector(32 downto 0);
    31_26 : out std_logic_vector(width-1 downto 0));
end instruction reg;

architecture BHV of reg is
begin
  process(clk, rst)
  begin
    
	if (rst = '1') then
      output   <= (others => '0');
    
	elsif (clk'event and clk = '1') then
      
	  if (en = '1') then
        output <= input;
      end if;
    
	end if;
  end process;
end BHV;