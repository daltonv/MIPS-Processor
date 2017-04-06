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
		input1 : in std_logic_vector(9 downto 0);
		input2 : in std_logic_vector(9 downto 0);
		input1_en : in std_logic;
		input2_en : in std_logic;
		output : out std_logic_vector(WIDTH-1 downto 0);

		--controller signals
		MemToReg			: in std_logic; --select between ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã¢â‚¬Å“Memory data registerÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â or ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã¢â‚¬Å“ALU outputÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â as input 
											 --to ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã¢â‚¬Å“write dataÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â signal.
		RegDst			: in std_logic; --select between IR20-16 or IR15-11 as the input to the ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã¢â‚¬Å“Write RegÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â
		RegWrite			: in std_logic; --enables the register file 
		JumpAndLink 		: in std_logic; -- when asserted, $s31 will be selected as the write register.
		PCWriteCond		: in std_logic; --enables the PC register if the ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã¢â‚¬Å“BranchÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â signal is asserted. 
		PCWrite 			: in std_logic; --enables the PC register.
		IorD 			: in std_logic; --select between the PC or the ALU output as the memory address.
		ALUSrcA			: in std_logic; --select between the PC or the A reg
		ALUSrcB			: in std_logic_vector(1 downto 0);
		PCSource			: in std_logic_vector(1 downto 0);
		MemWrite	: in std_logic;
		MemRead		: in std_logic;
		IRWrite		: in std_logic;
		ALUOp		: in std_logic_vector(1 downto 0);
		isSigned	: in std_logic;

		opcode : out std_logic_vector(5 downto 0)
	);
end datapath;

architecture STR of datapath is
	--Memory Signal
	signal ram_in : std_logic_vector(31 downto 0);
	signal ram_out : std_logic_vector(31 downto 0);
	signal mem_address : std_logic_vector(31 downto 0);
	signal wren : std_logic;

	--PC signals
	signal PC_in : std_logic_vector(31 downto 0);
	signal PC_out : std_logic_vector(31 downto 0);
	signal PC_en : std_logic;
	signal PC_shifted_out : std_logic_vector(31 downto 0); 

	--memory data register signals
	signal mem_data_out : std_logic_vector(31 downto 0);
	signal write_data : std_logic_vector(31 downto 0);

	--instruction register signals
	signal instruction_reg_out : std_logic_vector(31 downto 0);
	signal write_reg : std_logic_vector(4 downto 0);
	signal sign_extended_data : std_logic_vector(31 downto 0);
	signal sign_extended_data_shift : std_logic_vector(31 downto 0);

	--register file signals
	signal data_A	: std_logic_vector(31 downto 0);
	signal data_B	: std_logic_vector(31 downto 0);

	--regsiter A signals
	signal reg_A 	: std_logic_vector(31 downto 0); --output of register A
	signal alu_in1	: std_logic_vector(31 downto 0);

	--regsiter Bsignals
	signal reg_B	: std_logic_vector(31 downto 0); --output of register B
	signal alu_in2	: std_logic_vector(31 downto 0);

	--alu signals (including it's output registers and mux)
	signal branch_taken	: std_logic;
	signal alu_result_LO : std_logic_vector(31 downto 0);
	signal alu_result_HI : std_logic_vector(31 downto 0);
	signal alu_out_reg : std_logic_vector(31 downto 0);
	signal alu_LO_reg : std_logic_vector(31 downto 0);
	signal alu_HI_reg : std_logic_vector(31 downto 0);
	signal alu_mux_out : std_logic_vector(31 downto 0);

	signal muxA_in2 : std_logic_vector(31 downto 0);

	--alu control signals
	signal OPSelect : std_logic_vector(5 downto 0);
	signal ALU_LO_HI : std_logic_vector(1 downto 0);
	signal LO_en	: std_logic;
	signal HI_en	: std_logic;

	signal notClk : std_logic;

begin
	
	PC_en <= (branch_taken and PCWriteCond) or PCWrite;

	notClk <= not clk;

	U_PC : entity work.reg
		generic map(
			width => 32
		)
		port map (
			clk => clk,
			rst => rst,
			en => PC_en,
			input => PC_in,
			output => PC_out
		);

	U_PC_MUX : entity work.mux2x1
		generic map(
			width => 32
		)
		port map(
			in1 => PC_out,
			in2 => alu_out_reg,
			sel => IorD,
			output => mem_address
		);

	U_MEMORY : entity work.memory
		port map(
			clk => clk,
			rst => rst,
			input1 => input1,
			input2 => input2,
			input1_en => input1_en,
			input2_en => input2_en,
			wren => MemWrite,
			MemRead => MemRead,
			address => mem_address,
			output => output,
			data_in => reg_B,
			data_out => ram_out
		);

	U_MEM_DATA_REG : entity work.reg
		generic map(
			width => 32
		)
		port map (
			clk => notClk,
			rst => rst,
			en => '1', --should always be enabled
			input => ram_out,
			output => mem_data_out
		);

	U_MEM_DATA_MUX : entity work.mux2x1
		generic map(
			width => 32
		)
		port map(
			in1 => alu_mux_out,
			in2 => mem_data_out,
			sel => MemToReg,
			output => write_data
		);

	U_INSTRUCTION_REG : entity work.reg
		generic map(
			width => 32
		)
		port map (
			clk => notClk,
			rst => rst,
			en => IRWrite, --should always be enabled
			input => ram_out,
			output => instruction_reg_out
		);

	opcode <= instruction_reg_out(31 downto 26);

	--mux connected to 20 to 16 and 15 to 11 of instruction reg output
	U_INSTRUCTION_MUX : entity work.mux2x1
		generic map(
			width => 5
		)
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
		)
		port map(
			input => instruction_reg_out(15 downto 0),
			isSigned => isSigned,
			output => sign_extended_data
		);

	U_SHIFT_LEFT2_B : entity work.shiftl2
		generic map(
			width => 30
		)
		port map(
			input => sign_extended_data(29 downto 0),
			output => sign_extended_data_shift
		);

	U_REGISTERS_FILE : entity work.registers_file
		generic map(
			width => 32
		)
		port map(
			clk => clk,
			rst => rst,
			read_reg_A => instruction_reg_out(25 downto 21),
			read_reg_B => instruction_reg_out(20 downto 16),
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
		)
		port map (
			clk => notClk,
			rst => rst,
			en => '1', --should always be enabled
			input => data_A,
			output => reg_A
		);

	U_MUX_A : entity work.mux2x1
		generic map(
			width => 32
		)
		port map(
			in1 => PC_out,
			in2 => reg_A,
			sel => ALUSrcA,
			output => alu_in1
		);

	U_REG_B : entity work.reg
		generic map(
			width => 32
		)
		port map (
			clk => notClk,
			rst => rst,
			en => '1', --should always be enabled
			input => data_B,
			output => reg_B
		);

	U_MUX_B : entity work.mux4x3
		generic map(
			width => 32
		)
		port map(
			in1 => reg_B,
			in2 => std_logic_vector(to_unsigned(4,32)),
			in3 => sign_extended_data,
			in4 => sign_extended_data_shift,
			sel => ALUSrcB,
			output => alu_in2
		);

	U_ALU_CTRL : entity work.alu_control
		generic map(
			width => 32
		)
		port map(
			ALUOp => ALUOp,
			func => instruction_reg_out(5 downto 0),
			opcode => instruction_reg_out(31 downto 26),
			OPSelect => OPSelect,
			HI_en => HI_en,
			LO_en => LO_en,
			ALU_LO_HI => ALU_LO_HI
		);

	U_ALU : entity work.alu
		generic map(
			width => 32
		)
		port map(
			input1 => alu_in1,
			input2 => alu_in2,
			op => OPSelect,
			branch_taken => branch_taken,
			result_LO => alu_result_LO,
			result_HI => alu_result_HI
		);

	U_ALU_OUT_REG : entity work.reg
		generic map(
			width => 32
		)
		port map (
			clk => clk,
			rst => rst,
			en => '1', --should always be enabled
			input => alu_result_LO,
			output => alu_out_reg
		);

	U_ALU_LO_REG : entity work.reg
		generic map(
			width => 32
		)
		port map (
			clk => clk,
			rst => rst,
			en => LO_en,
			input => alu_result_LO,
			output => alu_LO_reg
		);

	U_ALU_HI_REG : entity work.reg
		generic map(
			width => 32
		)
		port map (
			clk => clk,
			rst => rst,
			en => HI_en,
			input => alu_result_HI,
			output => alu_HI_reg
		);

	U_ALU_MUX : entity work.mux3x2
		generic map(
			width => 32
		)
		port map(
			in1 => alu_out_reg,
			in2 => alu_LO_reg,
			in3 => alu_HI_reg,
			sel => ALU_LO_HI,
			output => alu_mux_out
		);


	PC_shifted_out <= PC_out(31 downto 28) & "00" & std_logic_vector(unsigned(instruction_reg_out(25 downto 0)) sll 2);  

	U_PC_SRC_MUX : entity work.mux3x2
		generic map(
			width => 32
		)
		port map(
			in1 => alu_result_LO,
			in2 => alu_out_reg,
			in3 => PC_shifted_out,
			sel => PCSource,
			output => PC_in
		);
		
end STR;