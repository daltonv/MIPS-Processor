library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registers_file is
	generic (
		WIDTH : positive :=32
	)
	port (
		--clock
		clk			: in std_logic;
		rst 		: in std_logic;

		--data inputs
		read_reg_A 	: in std_logic_vector(4 downto 0); --select reg for A
		read_reg_B 	: in std_logic_vector(4 downto 0); --select reg for B
		write_reg 	: in std_logic;	--select reg to be written to
		write_data 	: in std_logic;	--data to be written to reg

		--ctrls
		RegWrite	: in std_logic;
		JumpAndLink : in std_logic;

		--outputs
		data_A		: out std_logic_vector(WIDTH-1 downto 0);
		data_B		: out std_logic_vector(WIDTH-1 downto 0)
	);
end registers_file;

architecture STR of registers_file
	type registerArray is array(0 to 31) of std_logic_vector(WIDTH-1 downto 0); --array that acts as 32 registers
	signal registers : registerArray;

begin

	process(clk, rst)
	begin
	if (rst = '1') then
      data_A   <= (others => '0');
      data_B   <= (others => '0');
      registers <= (others => (others => '0'));
    
	elsif (clk'event and clk = '1') then
		--fetch requested registers
		data_A <= registers(to_integer(unsigned(read_reg1)));
		data_B <= registers(to_integer(unsigned(read_reg2)));

		--handle writing instructions
		if RegWrite = '1' AND JumpAndLink = '1' then
			registers(to_integer(unsigned(31))) <= write_data;
		elsif RegWrite = '1' AND JumpAndLink = '0' then
			if RegWrite = '1' AND JumpAndLink = '1' then
			registers(to_integer(unsigned(write_reg))) <= write_data;
		end if;
    
	end if;
  end process;