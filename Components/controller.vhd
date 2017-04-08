library ieee;
use ieee.std_logic_1164.all;
use work.MIPS_LIB.all ;
use ieee.numeric_std.all;


entity controller is
	port (
		--clk and resets
		clk	: in std_logic;
		rst : in std_logic;

		opcode : in std_logic_vector(5 downto 0); -- opcode in

		--control out signals
		MemToReg		: out std_logic; --select between							
		RegDst			: out std_logic; --select between IR20-16 or IR15-11 as the input to the
		RegWrite		: out std_logic; --enables the register file 
		JumpAndLink 	: out std_logic; -- when asserted, $s31 will be selected as the write register.
		PCWriteCond		: out std_logic; --enables the PC register if the  signal is asserted. 
		PCWrite 		: out std_logic; --enables the PC register.
		IorD 			: out std_logic; --select between the PC or the ALU output as the memory address.
		ALUSrcA			: out std_logic; --select between the PC or the A reg
		ALUSrcB			: out std_logic_vector(1 downto 0);
		PCSource		: out std_logic_vector(1 downto 0);
		MemWrite		: out std_logic; --allows memory to be written too
		MemRead			: out std_logic; --allows memory to be read from
		IRWrite			: out std_logic; --allows IR reg to be written toos
		ALUOp			: out std_logic_vector(1 downto 0); 
		isSigned		: out std_logic
	);
end controller;

architecture FSM_2P of controller is
	
	--TODO add more states
	type STATE_TYPE is (INSTR_FETCH, INSTR_DECODE, R_EXECUTE, R_COMPLETE,
						MEM_COMPUTE, MEM_READ, MEM_WRITE, MEM_COMPLETE, I_EXECUTE,
						I_COMPLETE, BRANCH, JUMP);
	signal state, next_state : STATE_TYPE;

begin
	
	process(clk, rst)
	begin
		if (rst = '1') then
		  state <= INSTR_FETCH;
		elsif (clk'event and clk = '1') then
		  state <= next_state;
		end if;
	end process;

	process(opcode,state)
	begin
		next_state <= state;

		MemToReg <= '0';
		RegDst <= '0';
		RegWrite <= '0';
		JumpAndLink <= '0';
		PCWriteCond <= '0';
		PCWrite <= '0';
		IorD <= '0';
		ALUSrcA <= '0';
		ALUSrcB <= "00";
		PCSource <= "00";
		MemWrite <= '0';
		MemRead <= '0';
		IRWrite <= '0';
		ALUOp <= "00";
		isSigned <= '1';

		case state is
			when INSTR_FETCH =>
				MemRead <= '1';
				ALUSrcB <= "01"; --select constant 4
				ALUOp <= "00"; --something with alu control
				PCWrite <= '1'; --allow PC to be written too

				next_state <= INSTR_DECODE;


			when INSTR_DECODE =>
				IRWrite <= '1';
				ALUSrcB <= "11";

				if opcode = RTYPE then
					next_state <= R_EXECUTE;
				elsif opcode = LW OR opcode = SW then
					next_state <= MEM_COMPUTE;
				elsif opcode = ADDI OR opcode = SUBI  OR opcode = ANDI OR opcode = ORI OR opcode = XORI OR opcode = SLTI OR opcode = SLTU then
					next_state <= I_EXECUTE;
				elsif opcode = BEQ OR opcode = BNE OR opcode = BLEZ OR opcode = BGTZ OR opcode = BLTZ then
					next_state <= BRANCH;
				elsif opcode = J OR opcode = JAL then
					next_state <= JUMP;
				end if;

			--RTYPE Begin
			when R_EXECUTE =>
				ALUSrcA <= '1'; --select reg A for alu input1
				ALUSrcB <= "00"; --select reg B for alu input2
				ALUOp <= "10"; --idk yet

				next_state <= R_COMPLETE;

			when R_COMPLETE =>
				RegDst <= '1'; --used to select reg to write to
				RegWrite <= '1'; --allow writing in reg file
				MemToReg <= '0'; --use alu output as data to write to reg

				next_state <= INSTR_FETCH;
			--RTYPE End

			--LW or SW Begin
			when MEM_COMPUTE =>
				ALUSrcA <= '1'; --select reg A for alu input1
				ALUSrcB <= "10"; --select sign extended ir 15-0 for alu input2
				ALUOp <= "00";
				isSigned <= '0';

				if opcode = LW then
					next_state <= MEM_READ;
				elsif opcode = SW then
					next_state <= MEM_WRITE;
				end if;

			when MEM_WRITE =>
				IorD <= '1'; --use alu output as address
				MemWrite <= '1';
				--isSigned <= '0';

				next_state <= INSTR_FETCH;

			when MEM_READ =>
				ALUOp <= "00";
				ALUSrcA <= '1'; --select reg A for alu input1
				ALUSrcB <= "10"; --select sign extended ir 15-0 for alu input2
				IorD <= '1'; --use alu output as address
				MemRead <= '1';
				isSigned <= '0';

				next_state <= MEM_COMPLETE;

			when MEM_COMPLETE =>
				IorD <= '1';
				RegDst <= '0'; --select write reg in reg file
				RegWrite <= '1'; --allow writing to reg
				MemtoReg <= '1'; --use mem data for reg
				isSigned <= '1';

				next_state <= INSTR_FETCH;
			--LW or SW End

			--ITYPE Begin
			when I_EXECUTE =>
				ALUSrcA <= '1'; --select reg A for alu input1
				ALUSrcB <= "10"; --select imeddiate
				ALUOp <= "11"; --alu op to itype

				next_state <= I_COMPLETE;

			when I_COMPLETE =>
				RegDst <= '0'; --used to select reg to write to
				RegWrite <= '1'; --allow writing in reg file
				MemToReg <= '0'; --use alu output as data to write to reg

				next_state <= INSTR_FETCH;
			--ITYPE End

			--Branch start
			when BRANCH =>
				ALUSrcA <= '1';
				ALUSrcB <= "00";
				ALUOp <= "01";
				PCWriteCond <= '1';
				PCSource <= "01";

				next_state <= INSTR_FETCH;
			--branch end

			--jump start
			when JUMP =>
				PCWrite <= '1';
				PCSource <= "10";

				if opcode = JAL then
					JumpAndLink <= '1';
					RegWrite <= '1';
				end if;

				next_state <= INSTR_FETCH;
			--jump end


		end case;

	end process;


end FSM_2P; 