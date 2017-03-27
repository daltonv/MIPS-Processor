librarY ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory is
	port (
		clk	: in std_logic;
		rst : in std_logic;
		input1 : in std_logic_vector(31 downto 0);
		input2 : in std_logic_vector(31 downto 0);
		input1_en : in std_logic;
		input2_en : in std_logic;
		wren : in std_logic;
		address : in std_logic_vector(31 downto 0);
		output : out std_logic_vector(31 downto 0);
		data_in : in std_logic_vector(31 downto 0);
		data_out : out std_logic_vector(31 downto 0);
	);
end memory;

architecture STR of memory is
	signal hold_out : std_logic_vector(31 downto 0);
	signal hold_in	: std_logic_vector(31 downto 0);

begin

	U_RAM : entity work.ram
		port map(
			address => address(7 downto 0),
			clock => clk,
			data => data_in,
			wren => wren,
			q => hold_out
		);

	process(clk, input1, input2, hold_out)
	begin
		if(address = "0xFFF8") then
			data_out <= input1
		elsif(address = "0xFFFC" AND wren='0') then
			data_out <= input2
		elsif(address = "0xFFFC" AND wren='1') then
			output <= hold_out;
		else 
			data_out <= hold_out;
		end if;		
	end process;

end STR;