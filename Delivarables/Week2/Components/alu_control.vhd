library ieee;
use ieee.std_logic_1164.all;
use work.MIPS_LIB.all ;
use ieee.numeric_std.all;


entity alu_control is
	generic (
		WIDTH : positive := 32
	);
	port (
		ALUOp	: in std_logic_vector(1 downto 0); -- opcode in
		opcode  : in std_logic_vector(5 downto 0);
		func	: in std_logic_vector(5 downto 0);

		OPSelect : out std_logic_vector(5 downto 0);

		HI_en	: out std_logic;
		LO_en	: out std_logic;
		
		ALU_LO_HI	: out std_logic_vector(1 downto 0) 
	);
end alu_control;

architecture BHV of alu_control is
begin
	process(ALUOp, func, opcode)
	begin
	
		OPSelect <= (others => '0');
		HI_en <= '0';
		LO_en <= '0';
		ALU_LO_HI <= (others => '0');
		
		case ALUOp is
			when "00" =>
				OPSelect <= ADDU;
				LO_en <= '0';

				if func = MFHI then
					ALU_LO_HI <= "10";
				elsif func = MFLO then
					ALU_LO_HI <= "01";
				else
					ALU_LO_HI <= "00"; 
				end if;

			--let the function field determine the instruction
			when "10" =>
				OPSelect <= func; --send the function to the alu

				if func = MULT OR func = MULTU then
					HI_en <= '1'; --only load high if it's a mult
					LO_en <= '1'; --load LO
				end if;

				ALU_LO_HI <= "00"; --load the alu

				if func = MFHI then
					HI_en <= '0';
					ALU_LO_HI <= "10";
				elsif func = MFLO then
					LO_en <= '0';
					ALU_LO_HI <= "01";
				end if;

			-- i type instructions
			when "11" => 
				case opcode is 
					when ADDI =>
						OPSelect <= ADDU;
					when SUBI =>
						OPSelect <= SUBU;
					when ANDI =>
						OPSelect <= ANDU;
					when ORI =>
						OPSelect <= ORU;
					when XORI =>
						OPSelect <= XORU;
					when SLTI =>
						OPSelect <= CSLT;
					when SLTU =>
						OPSelect <= CSLTU;

					when others => null;
				end case;

				LO_en <= '0'; --load LO
				ALU_LO_HI <= "00"; --load the alu

			when others => null;

		end case;
	end process;	

end BHV;