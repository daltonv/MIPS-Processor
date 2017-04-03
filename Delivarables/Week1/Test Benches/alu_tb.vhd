library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity alu_tb is
end alu_tb;

architecture TB of alu_tb is
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

	signal input1			: std_logic_vector(31 downto 0);
	signal input2			: std_logic_vector(31 downto 0);
	signal op				: std_logic_vector(4 downto 0);
	signal branch_taken		: std_logic;
	signal result_LO		: std_logic_vector(31 downto 0);
	signal result_HI		: std_logic_vector(31 downto 0);

begin

	UUT : entity work.alu
		generic map(
			width => 32
		)
		port map (
			input1 => input1,
			input2 => input2,
			op => op,
			branch_taken => branch_taken,
			result_LO => result_LO,
			result_HI => result_HI
		);

	process
	begin
		-- test 2+6 (no overflow)
        op    <= C_ADD;
        input1 <= conv_std_logic_vector(2, input1'length);
        input2 <= conv_std_logic_vector(6, input2'length);
        wait for 40 ns;
        assert(result_LO = conv_std_logic_vector(8, result_LO'length)) report "Error : 2+6 = " & integer'image(conv_integer(result_LO)) & " instead of 8" severity warning;
        assert(result_HI = conv_std_logic_vector(0, result_LO'length)) report "Error                                   : overflow incorrect for 2+8" severity warning;

        -- test 56-10 (no overflow)
        op    <= C_SUB;
        input1 <= conv_std_logic_vector(56, input1'length);
        input2 <= conv_std_logic_vector(10, input2'length);
        wait for 40 ns;
        assert(result_LO = conv_std_logic_vector(46, result_LO'length)) report "Error : 56-10 = " & integer'image(conv_integer(result_LO)) & " instead of 46" severity warning;
        assert(result_HI = conv_std_logic_vector(0, result_LO'length)) report "Error : overflow incorrect for 56-10" severity warning;

        -- test 10*12 (no overflow)
        op    <= C_MULT;
        input1 <= conv_std_logic_vector(10, input1'length);
        input2 <= conv_std_logic_vector(12, input2'length);
        wait for 40 ns;
        assert(result_LO = conv_std_logic_vector(120, result_LO'length)) report "Error : 10*12 = " & integer'image(conv_integer(result_LO)) & " instead of 120" severity warning;
        assert(result_HI = conv_std_logic_vector(0, result_LO'length)) report "Error : overflow incorrect for 10*12" severity warning;
        
        -- test BGTZ
        op    <= C_BGTZ;
        input1 <= conv_std_logic_vector(5, input1'length);
        input2 <= conv_std_logic_vector(79, input2'length);
        wait for 40 ns;
        assert(branch_taken = '1') report "Error : 5>0" severity warning;

        -- test 20<<2 (no overflow)
        op    <= C_SLL;
        input1 <= conv_std_logic_vector(20, input1'length);
        input2 <= conv_std_logic_vector(2, input2'length);
        wait for 40 ns;
        assert(result_LO = conv_std_logic_vector(80, result_LO'length)) report "Error : 20<<2 = " & integer'image(conv_integer(result_LO)) & " instead of 80" severity warning;
        assert(result_HI = conv_std_logic_vector(0, result_LO'length)) report "Error : overflow incorrect for 10<<2" severity warning;

         -- test 20>>2 (no overflow)
        op    <= C_SRA;
        input1 <= conv_std_logic_vector(-20, input1'length);
        input2 <= conv_std_logic_vector(2, input2'length);
        wait for 40 ns;
        assert(result_LO = conv_std_logic_vector(-5, result_LO'length)) report "Error : -20>>2 = " & integer'image(conv_integer(result_LO)) & " instead of -5" severity warning;
        assert(result_HI = conv_std_logic_vector(0, result_LO'length)) report "Error : overflow incorrect for -20>>2" severity warning;

        -- test BEQ
        op    <= C_BEQ;
        input1 <= conv_std_logic_vector(79, input1'length);
        input2 <= conv_std_logic_vector(79, input2'length);
        wait for 40 ns;
        assert(branch_taken = '1') report "Error : 79=79" severity warning;

        -- test BNE
        op    <= C_BNE;
        input1 <= conv_std_logic_vector(79, input1'length);
        input2 <= conv_std_logic_vector(90, input2'length);
        wait for 40 ns;
        assert(branch_taken = '1') report "Error : 79 != 90" severity warning;

        report "FINISHED";
        wait;

	end process;

end TB;