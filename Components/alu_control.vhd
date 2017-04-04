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
		func	: in std_logic_vector(5 downto 0);

		OPSelect : out std_logic_vector(5 downto 0);

		HI_en	: out std_logic;
		LO_en	: out std_logic;
		
		ALU_LO_HI	: out std_logic_vector(1 downto 0) 
	);
end alu_control;

architecture BHV of alu_control is
begin
	process(ALUOp, func)
	begin
	
		OPSelect <= (others => '0');
		HI_en <= '0';
		LO_en <= '0';
		ALU_LO_HI <= (others => '0');
		
		case ALUOp is
			when "00" =>
				OPSelect <= ADDU;
				LO_en <= '1';
				ALU_LO_HI <= "00";

			--let the function field determine the instruction
			when "10" =>
				OPSelect <= func; --send the function to the alu
				LO_en <= '1'; --load LO

				if func = MULT OR func = MULTU then
					HI_en <= '1'; --only load high if it's a mult
				end if;

				ALU_LO_HI <= "00"; --load the alu

			when others => null;

		end case;
	end process;	

end BHV;