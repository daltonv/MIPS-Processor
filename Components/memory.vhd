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
	signal input1_reg : std_logic_vector(31 downto 0);
	signal input2_reg	: std_logic_vector(31 downto 0);
	signal wren2 : std_logic;

begin

	U_RAM : entity work.ram
		port map(
			address => address(7 downto 0),
			clock => clk,
			data => data_in,
			wren => wren2,
			q => hold_out
		);

	U_INPUT1_REG : entity work.reg
		generic map(
			width => 32
		)
		port map (
			clk => clk,
			rst => rst,
			en => input1_en, --should always be enabled
			input => input1,
			output => input1_reg
		);

	U_INPUT2_REG : entity work.reg
		generic map(
			width => 32
		)
		port map (
			clk => clk,
			rst => rst,
			en => input2_en, --should always be enabled
			input => input2,
			output => input2_reg
		);

	process(clk, input1_reg, input2_reg, hold_out, data_in, wren, address)
	begin
		output <= (others => '0');
		data_out <= hold_out;
		wren2 <= wren;

		if(unsigned(address) = to_unsigned(65528,address'length)) then
			data_out <= input1_reg;
		elsif(unsigned(address) = to_unsigned(65532,address'length) AND wren='0') then
			data_out <= input2_reg;
		elsif(unsigned(address) = to_unsigned(65532,address'length) AND wren='1') then
			output <= data_in;
			data_out <= hold_out;
			wren2 <= '0';
		end if;		
	end process;

end STR;