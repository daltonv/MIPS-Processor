library ieee;
use ieee.std_logic_1164.all;
use work.MIPS_LIB.all;
use ieee.numeric_std.all;

entity alu is 
	generic (
		WIDTH : positive := 32
	);
	port (
		input1			: in std_logic_vector(WIDTH-1 downto 0);
		input2			: in std_logic_vector(WIDTH-1 downto 0);
		op					: in std_logic_vector(5 downto 0);
		branch_taken	: out std_logic;
		result_LO		: out std_logic_vector(WIDTH-1 downto 0);
		result_HI		: out std_logic_vector(WIDTH-1 downto 0)
	);
end alu;

--ALU (showing ADDU, SUBU, MULTU, BGTZ, SLL, SRA, BEQ, BNE)
architecture BHV of alu is
begin

	process(input1,input2,op)
		variable arith_result : unsigned(WIDTH*2-1 downto 0);

	begin

	--init outputs to zero to prevent latches
	branch_taken <= '0';
	result_LO <= (others => '0');
	result_HI <= (others => '0');

	case op is
		when ADDU	=> --$s1 = $s2 + $s3
			arith_result := resize(unsigned(input1),arith_result'length)+resize(unsigned(input2),arith_result'length);
			result_LO <= std_logic_vector(arith_result(WIDTH-1 downto 0));
			result_HI <= std_logic_vector(arith_result(WIDTH*2-1 downto WIDTH));

		when SUBU 		=> --$s1 = $s2 - $s3
			arith_result := resize(unsigned(input1),arith_result'length)-resize(unsigned(input2),arith_result'length);
			result_LO <= std_logic_vector(arith_result(WIDTH-1 downto 0));
			result_HI <= std_logic_vector(arith_result(WIDTH*2-1 downto WIDTH));
		
		when MULT 	=> --$LO= $s * $t
			arith_result := resize(unsigned(input1),result_LO'length)*resize(unsigned(input2),result_LO'length);
			result_LO <= std_logic_vector(arith_result(WIDTH-1 downto 0));
			result_HI <= std_logic_vector(arith_result(WIDTH*2-1 downto WIDTH));

		when MULTU 	=> --$LO= $s * $t
			arith_result := resize(unsigned(input1),result_LO'length)*resize(unsigned(input2),result_LO'length);
			result_LO <= std_logic_vector(arith_result(WIDTH-1 downto 0));
			result_HI <= std_logic_vector(arith_result(WIDTH*2-1 downto WIDTH));
		
		when ANDU  	=> --$s1 = $s2 and $s3
			result_LO <= input1 and input2;
		
		when ORU  		=> --$s1 = $s2 or $s3
			result_LO <= input1 or input2;
		
		when XORU  	=> --$s1 = $s2 xor $s3
			result_LO <= input1 xor input2;
		
		when CSRL  	=> --$s1 = $s2 >> H (H is bits 10-6 of IR)
			result_LO <= std_logic_vector(unsigned(input1) srl to_integer(unsigned(input2)));

		when CSLL  	=> --$s1 = $s2 << H (H is bits 10-6 of IR)
			result_LO <= std_logic_vector(unsigned(input1) sll to_integer(unsigned(input2)));

		when CSRA  	=>
			result_LO <= to_stdlogicvector(to_bitvector(input1) sra to_integer(unsigned(input2)));

		when CSLT  	=> --$s1=1 if $s2 < $s3 else $s1=0
			if(signed(input1) < signed(input2)) then
				result_LO <= std_logic_vector(to_unsigned(1,result_LO'length));
			end if;
		
		when CSLTU	=>  --$s1=1 if $s2 < $s3 else $s1=0
			if(unsigned(input1) < unsigned(input2)) then
				result_LO <= std_logic_vector(to_unsigned(1,result_LO'length));
			end if;
		
		--Don't think the alu handles these next two
		--when C_MFHI		=> --$s1= HI
		
		--when C_MFLO		=> --$s1= LO
		
		when BEQ		=> --if $s1=$s2, PC += TARGET
			if(unsigned(input1) = unsigned(input2)) then
				branch_taken <= '1';
			end if;
		
		when BNE		=> --if $s1/=$s2, PC += TARGET
			if(unsigned(input1) /= unsigned(input2)) then
				branch_taken <= '1';
			end if;
		
		when BLEZ		=> --if $s1 <= 0, PC += TARGET
			if(signed(input1) <= 0) then
				branch_taken <= '1';
			end if;
		
		when BGTZ		=> --if $s1 > 0, PC += TARGET
			if(signed(input1) > 0) then
				branch_taken <= '1';
			end if;
		
		when BLTZ		=> --if $s1 < 0, PC += TARGET
			if(signed(input1) < 0) then
				branch_taken <= '1';
			end if;

		when BGEZ 		=>
			if(signed(input1) >= 0) then
				branch_taken <= '1';
			end if;
		
		--when BGEZ		=> --if $s1 >= 0, PC += TARGET
			--if(signed(input1) >= 0) then
				--branch_taken <= '1';
				--result_LO <= std_logic_vector(unsigned(input1) + unsigned(input2));
			--end if;
		
		--when J		=> --PC = TARGET
			--result_LO <= input2;
		
		--when JAL		=> --$ra = PC+8 and PC = TARGET 
			--result_LO <= input2;
		
		--when JR		=> --PC = $ra
			--result_LO <= input2;
		
		when others => null;

	end case;

	end process;
end BHV;