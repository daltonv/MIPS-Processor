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
		data_out : out std_logic_vector(31 downto 0)
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
			data => hold_in,
			wren => wren,
			q => hold_out
		);

	process(clk, input1, input2, hold_out)
	begin
		if(unsigned(address) = to_unsigned(65528,address'length)) then
			data_out <= input1;
		elsif(unsigned(address) = to_unsigned(65532,address'length) AND wren='0') then
			data_out <= input2;
		elsif(unsigned(address) = to_unsigned(65532,address'length) AND wren='1') then
			hold_in <= input2;
		else 
			data_out <= hold_out;
			hold_in <= data_in;
		end if;		
	end process;

end STR;