library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controller is
	generic (
		WIDTH : positive := 32
	);
	port (
		--clk and resets
		clk	: in std_logic;
		rst : in std_logic;

		data : in std_logic_vector(4 downto 0); -- data in

		--control out signals
		MemToReg		: out std_logic; --select between â€œMemory data registerâ€ or â€œALU outputâ€ as input 
											 --to â€œwrite dataâ€ signal.
		RegDst			: out std_logic; --select between IR20-16 or IR15-11 as the input to the â€œWrite Regâ€
		RegWrite		: out std_logic; --enables the register file 
		JumpAndLink 	: out std_logic; -- when asserted, $s31 will be selected as the write register.
		PCWriteCond		: out std_logic; --enables the PC register if the â€œBranchâ€ signal is asserted. 
		PCWrite 		: out std_logic; --enables the PC register.
		IorD 			: out std_logic; --select between the PC or the ALU output as the memory address.
		ALUSrcA			: out std_logic; --select between the PC or the A reg
		ALUSrcB			: out std_logic_vector(2 downto 0);
		PCSource		: out std_logic_vector(1 downto 0);
		MemWrite		: out std_logic
	);
end controller;

architecture FSM_2P of controller is
	
	--TODO add more states
	type STATE_TYPE is (INSTR_FETCH, INSTR_DECODE);
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

	process(data,state)
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
		ALUSrcB <= "000";
		PCSource <= "00";
		MemWrite <= '0';

		case state is
			when INSTR_FETCH =>
			
		end case;

	end process;


end FSM_2P; 