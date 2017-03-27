library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath is
	generic (
		WIDTH : positive := 32
	);
	port (
		clk	: in std_logic;
		rst : in std_logic;
		input1 : in std_logic_vector(WIDTH-1 downto 0);
		input2 : in std_logic_vector(WIDTH-1 downto 0);
		input1_en : in std_logic;
		input2_en : in std_logic;
		output : out std_logic_vector(WIDTH-1 downto 0);
	);
end datapath;

architecture STR of datapath is
	signal ram_in : std_logic_vector(31 downto 0);
	signal ram_out : std_logic_vector(31 downto 0);
	signal ram_address : std_logic_vector(31 downto 0);
	signal wren : std_logic;

	--controller signals
	signal MemToReg			: std_logic; --select between “Memory data register” or “ALU output” as input 
										 --to “write data” signal.
	signal RegDst			: std_logic; --select between IR20-16 or IR15-11 as the input to the “Write Reg”
	signal RegWrite			: std_logic; --enables the register file 
	signal JumpAndLink 		: std_logic; -- when asserted, $s31 will be selected as the write register.
	signal ALUSrcA			: std_logic_vector(1 downto 0);
	signal ALUSrcB			: std_logic_vector(2 downto 0);

	--memory data register signals
	signal mem_data_out : std_logic_vector(31 downto 0);
	signal write_data : std_logic_vector(31 downto 0);

	--instruction register signals
	signal instruction_reg_out : std_logic_vector(31 downto 0);
	signal write_reg : std_logic_vector(31 downto 0);
	signal sign_extended_data : std_logic_vector(31 downto 0);
	signal sign_extended_data_shift : std_logic_vector(31 downto 0);

	--alu and alu reg signals
	signal alu_mux_out : std_logic_vector(31 downto 0);

	--register file signals
	signal data_A	: std_logic_vector(31 downto 0);
	signal data_B	: std_logic_vector(31 downto 0);

	--regsiter A signals
	signal reg_A 	: std_logic_vector(31 downto 0);
	signal alu_in1	: std_logic_vector(31 downto 0);

	--regsiter Bsignals
	signal reg_B	: std_logic_vector(31 downto 0);
	signal alu_in2	: std_logic_vector(31 downto 0);


begin

	U_SRAM : entity work.memory
		port map(
			clk => clk,
			rst => rst,
			input1 => input1,
			input2 => input2,
			wren => wren,
			address => ram_address,
			output => output,
			data_in => ram_in,
			data_out => ram_out
		);

	U_MEM_DATA_REG : entity work.reg
		generic map(
			width => 32
		);
		port map (
			clk => clk,
			rst => rst,
			en => '1', --should always be enabled
			input => ram_out,
			output => mem_data_out
		);

	U_MEM_DATA_MUX : entity work.mux2x1
		generic map(
			width => 32
		);
		port map(
			in1 => alu_mux_out,
			in2 => mem_data_out,
			sel => MemToReg,
			output => write_data
		);

	U_INSTRUCTION_REG : entity work.reg
		generic map(
			width => 32
		);
		port map (
			clk => clk,
			rst => rst,
			en => '1', --should always be enabled
			input => ram_out,
			output => instruction_reg_out
		);

	--mux connected to 20 to 16 and 15 to 11 of instruction reg output
	U_INSTRUCTION_MUX : entity work.mux2x1
		generic map(
			width => 5
		);
		port map(
			in1 => instruction_reg_out(20 downto 16),
			in2 => instruction_reg_out(15 downto 11),
			sel => RegDst,
			output => write_reg
		);

	--sign extension from instruction reg 15-0
	U_SIGN_EXTEND : entity work.sign_extend
		generic map(
			width => 16
		);
		port map(
			input => instruction_reg_out(15 downto 0),
			output => sign_extended_data
		);

	U_SHIFT_LEFT2_B : entity work.shiftl2
		generic map(
			width => 30
		);
		port map(
			input => sign_extended_data(29 downto 0)
			output => sign_extended_data_shift
		);

	U_REGISTERS_FILE : entity work.registers_file
		generic map(
			width => 32
		);
		port map(
			clk => clk,
			rst => rst,
			read_reg_A => instruction_reg_out(25 downto 21),
			read_reg_B => instruction_reg_out(15 downto 11),
			write_reg => write_reg,
			write_data => write_data,
			RegWrite => RegWrite,
			JumpAndLink => JumpAndLink,
			data_A => data_A,
			data_B => data_B
		);

	U_REG_A : entity work.reg
		generic map(
			width => 32
		);
		port map (
			clk => clk,
			rst => rst,
			en => '1', --should always be enabled
			input => data_A,
			output => reg_A
		);

	U_MUX_A : entity work.mux3x2
		generic map(
			width => 32
		);
		port map(
			in1 => --TODO
			in2 => instruction_reg_out(10 downto 6),
			in3 => reg_A,
			sel => ALUSrcA,
			output => alu_in1
		);

	U_REG_B : entity work.reg
		generic map(
			width => 32
		);
		port map (
			clk => clk,
			rst => rst,
			en => '1', --should always be enabled
			input => data_B,
			output => reg_B
		);

	U_MUX_B : entity work.mux4x3
		generic map(
			width => 32
		);
		port map(
			in1 => reg_B
			in2 => std_logic_vector(to_unsigned(4,32)),
			in3 => sign_extended_data,
			in4 => sign_extended_data_shift,
			sel => ALUSrcB,
			output => alu_in2
		);

	U_ALU : entity work.alu


end STR;