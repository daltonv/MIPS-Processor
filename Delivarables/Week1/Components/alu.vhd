library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is 
	generic (
		WIDTH : positive := 32
	);
	port (
		input1			: in std_logic_vector(WIDTH-1 downto 0);
		input2			: in std_logic_vector(WIDTH-1 downto 0);
		op				: in std_logic_vector(4 downto 0);
		branch_taken	: out std_logic;
		result_LO		: out std_logic_vector(WIDTH-1 downto 0);
		result_HI		: out std_logic_vector(WIDTH-1 downto 0)
	);
end alu;

--ALU (showing ADDU, SUBU, MULTU, BGTZ, SLL, SRA, BEQ, BNE)
architecture BHV of alu is

	--constants for mips instruction op codes
	constant C_ADD 		: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(0,5));
	constant C_SUB 		: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(2,5));
	constant C_MULT 	: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(4,5));
	constant C_AND  	: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(6,5));
	constant C_OR  		: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(8,5));
	constant C_XOR  	: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(10,5));
	constant C_SRL  	: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(12,5));
	constant C_SLL  	: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(13,5));
	constant C_SRA  	: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(14,5));
	constant C_SLT  	: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(15,5));
	constant C_SLTU		: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(18,5));
	constant C_MFHI		: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(19,5));
	constant C_MFLO		: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(20,5));
	constant C_LW		: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(21,5));
	constant C_SW		: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(22,5));
	constant C_BEQ		: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(23,5));
	constant C_BNE		: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(24,5));
	constant C_BLEZ		: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(25,5));
	constant C_BGTZ		: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(26,5));
	constant C_BLTZ		: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(27,5));
	constant C_BGEZ		: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(28,5));
	constant C_J		: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(29,5));
	constant C_JAL		: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(30,5));
	constant C_JR		: std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(31,5));

begin

	process(input1,input2,op)
		variable arith_result : unsigned(WIDTH*2-1 downto 0);

	begin

	--init outputs to zero to prevent latches
	branch_taken <= '0';
	result_LO <= (others => '0');
	result_HI <= (others => '0');

	case op is
		when C_ADD 		=> --$s1 = $s2 + $s3
			arith_result := resize(unsigned(input1),arith_result'length)+resize(unsigned(input2),arith_result'length);
			result_LO <= std_logic_vector(arith_result(WIDTH-1 downto 0));
			result_HI <= std_logic_vector(arith_result(WIDTH*2-1 downto WIDTH));

		when C_SUB 		=> --$s1 = $s2 - $s3
			arith_result := resize(unsigned(input1),arith_result'length)-resize(unsigned(input2),arith_result'length);
			result_LO <= std_logic_vector(arith_result(WIDTH-1 downto 0));
			result_HI <= std_logic_vector(arith_result(WIDTH*2-1 downto WIDTH));
		
		when C_MULT 	=> --$LO= $s * $t
			arith_result := resize(unsigned(input1),result_LO'length)*resize(unsigned(input2),result_LO'length);
			result_LO <= std_logic_vector(arith_result(WIDTH-1 downto 0));
			result_HI <= std_logic_vector(arith_result(WIDTH*2-1 downto WIDTH));
		
		when C_AND  	=> --$s1 = $s2 and $s3
			result_LO <= input1 and input2;
		
		when C_OR  		=> --$s1 = $s2 or $s3
			result_LO <= input1 or input2;
		
		when C_XOR  	=> --$s1 = $s2 xor $s3
			result_LO <= input1 xor input2;
		
		when C_SRL  	=> --$s1 = $s2 >> H (H is bits 10-6 of IR)
			result_LO <= std_logic_vector(unsigned(input1) srl to_integer(unsigned(input2)));

		when C_SLL  	=> --$s1 = $s2 << H (H is bits 10-6 of IR)
			result_LO <= std_logic_vector(unsigned(input1) sll to_integer(unsigned(input2)));

		when C_SRA  	=>
			result_LO <= to_stdlogicvector(to_bitvector(input1) sra to_integer(unsigned(input2)));

		when C_SLT  	=> --$s1=1 if $s2 < $s3 else $s1=0
			if(signed(input1) < signed(input2)) then
				result_LO <= std_logic_vector(to_unsigned(1,result_LO'length));
			end if;
		
		when C_SLTU		=> --$s1=1 if $s2 < $s3 else $s1=0
			if(unsigned(input1) < unsigned(input2)) then
				result_LO <= std_logic_vector(to_unsigned(1,result_LO'length));
			end if;
		
		--Don't think the alu handles these next two
		--when C_MFHI		=> --$s1= HI
		
		--when C_MFLO		=> --$s1= LO
		
		when C_LW		=> --$s1 = RAM[$s2+offset]
		
		when C_SW		=> -- RAM[$s2+offset] = $s1
		
		when C_BEQ		=> --if $s1=$s2, PC += TARGET
			if(unsigned(input1) = unsigned(input2)) then
				branch_taken <= '1';
				--result_LO <= std_logic_vector(unsigned(input1) + unsigned(input2));
			end if;
		
		when C_BNE		=> --if $s1/=$s2, PC += TARGET
			if(unsigned(input1) /= unsigned(input2)) then
				branch_taken <= '1';
				--result_LO <= std_logic_vector(unsigned(input1) + unsigned(input2));
			end if;
		
		when C_BLEZ		=> --if $s1 <= 0, PC += TARGET
			if(signed(input1) <= 0) then
				branch_taken <= '1';
				--result_LO <= std_logic_vector(unsigned(input1) + unsigned(input2));
			end if;
		
		when C_BGTZ		=> --if $s1 > 0, PC += TARGET
			if(signed(input1) > 0) then
				branch_taken <= '1';
				--result_LO <= std_logic_vector(unsigned(input1) + unsigned(input2));
			end if;
		
		when C_BLTZ		=> --if $s1 < 0, PC += TARGET
			if(signed(input1) < 0) then
				branch_taken <= '1';
				--result_LO <= std_logic_vector(unsigned(input1) + unsigned(input2));
			end if;
		
		when C_BGEZ		=> --if $s1 >= 0, PC += TARGET
			if(signed(input1) >= 0) then
				branch_taken <= '1';
				--result_LO <= std_logic_vector(unsigned(input1) + unsigned(input2));
			end if;
		
		when C_J		=> --PC = TARGET
			result_LO <= input2;
		
		when C_JAL		=> --$ra = PC+8 and PC = TARGET 
			result_LO <= input2;
		
		when C_JR		=> --PC = $ra
			result_LO <= input2;
		
		when others => null;

	end case;

	end process;
end BHV;