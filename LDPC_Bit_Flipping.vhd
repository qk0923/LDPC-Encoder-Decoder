LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.all;


ENTITY Bit_Flipping IS
GENERIC(
	-- Define Generics
	 N :natural := 10 -- Length of Codeword Bits
);

PORT(
	-- Clock and Reset
	clk : IN std_logic;
	rstb : IN std_logic;


	-- Input Interface I/O
	isop : IN std_logic;
	input_data : IN std_logic_vector(N-1 downto 0);

	-- Output Interface I/O
	msg_decode_done : OUT std_logic;
	odata : OUT std_logic_vector (N-1 downto N-5)
);

END Bit_Flipping;



ARCHITECTURE behav OF Bit_Flipping IS

-- Define State of the State Machine
TYPE state_type IS (ONRESET, IDLE, PARITY_CHECK, BIT_CHECK, HOLD_1, HOLD_2, DONE);

-- Define States
SIGNAL current_state, next_state : state_type;

-- Define Signals
SIGNAL B1_2,B1_3,B1_4,B1_6 : std_logic; --Represent Each Bit Protection Equation
SIGNAL B2_1,B2_3,B2_7  : std_logic;
SIGNAL B3_1,B3_3,B3_5,B3_8 : std_logic;
SIGNAL B4_3,B4_4,B4_5,B4_9 : std_logic;
SIGNAL B5_1,B5_2,B5_5,B5_10 : std_logic;

SIGNAL Bit1_0, Bit1_1 : integer; 
SIGNAL Bit2_0, Bit2_1 : integer; 
SIGNAL Bit3_0, Bit3_1 : integer; 
SIGNAL Bit4_0, Bit4_1 : integer; 
SIGNAL Bit5_0, Bit5_1 : integer; 
SIGNAL Bit6_0, Bit6_1 : integer; 
SIGNAL Bit7_0, Bit7_1 : integer; 
SIGNAL Bit8_0, Bit8_1 : integer; 
SIGNAL Bit9_0, Bit9_1 : integer; 
SIGNAL Bit10_0, Bit10_1 : integer; 

SIGNAL idata: std_logic_vector (N-1 downto 0);


BEGIN


	clock_state_machine:
	PROCESS(clk,rstb)
	BEGIN
	IF (rstb /= '1') THEN
	current_state <= ONRESET;
	ELSIF (clk'EVENT and clk = '1') THEN
	current_state <= next_state;
	END IF;
	END PROCESS clock_state_machine;



	sequential:
	PROCESS(clk, rstb)
	BEGIN

	CASE current_state IS
	
	WHEN ONRESET =>
	next_state <= IDLE;

	WHEN IDLE =>
	IF( isop = '1') THEN
	next_state <= PARITY_CHECK;
	ELSE
	next_state <= IDLE;
	END IF;

	WHEN PARITY_CHECK =>
	next_state <= HOLD_1;


	WHEN HOLD_1 =>
	next_state <= BIT_CHECK;



	WHEN BIT_CHECK =>
	next_state <= HOLD_2;


	
	WHEN HOLD_2 =>
	next_state <= DONE;


	WHEN DONE =>
	next_state <= IDLE;


	WHEN OTHERS =>
	next_state <= ONRESET;


	END CASE;

	END PROCESS sequential;

------------------------------------------------------------

	combinational:
	PROCESS(clk, rstb)	
	BEGIN
	
	IF ( clk'EVENT and clk = '0') THEN

	IF ( current_state = ONRESET) THEN
 		odata <= (OTHERS => 'U') ;
		msg_decode_done <= 'U';
	END IF;

	IF (current_state = IDLE) THEN
		idata <= input_data;
		Bit1_0 <= 0;
		Bit1_1 <= 0;
		Bit2_0 <= 0;
		Bit2_1 <= 0;
		Bit3_0 <= 0;
		Bit3_1 <= 0;
		Bit4_0 <= 0;
		Bit4_1 <= 0;
		Bit5_0 <= 0;
		Bit5_1 <= 0;
		Bit6_0 <= 0;
		Bit6_1 <= 0;
		Bit7_0 <= 0;
		Bit7_1 <= 0; 
		Bit8_0 <= 0; 
		Bit8_1 <= 0; 
		Bit9_0 <= 0; 
		Bit9_1 <= 0; 
		Bit10_0 <= 0; 
		Bit10_1 <= 0;
				
	END IF;

-------------------------------------------------------------
	IF (current_state = PARITY_CHECK) THEN
	
	B1_2 <= idata(N-3) xor idata(N-4) xor idata(N-6);
	B1_3 <= idata(N-2) xor idata(N-4) xor idata(N-6);
	B1_4 <= idata(N-2) xor idata(N-3) xor idata(N-6);
	B1_6 <= idata(N-2) xor idata(N-3) xor idata(N-4);
------------------------------------------------------------
	B2_1 <= idata(N-3) xor idata(N-7);
	B2_3 <= idata(N-1) xor idata(N-7);
	B2_7 <= idata(N-1) xor idata(N-3);
------------------------------------------------------------
	B3_1 <= idata(N-3) xor idata(N-5) xor idata(N-8);
	B3_3 <= idata(N-1) xor idata(N-5) xor idata(N-8);
	B3_5 <= idata(N-1) xor idata(N-3) xor idata(N-8);
	B3_8 <= idata(N-1) xor idata(N-3) xor idata(N-5);
------------------------------------------------------------
	B4_3 <= idata(N-4) xor idata(N-5) xor idata(N-9);
	B4_4 <= idata(N-3) xor idata(N-5) xor idata(N-9);
	B4_5 <= idata(N-3) xor idata(N-4) xor idata(N-9);
	B4_9 <= idata(N-3) xor idata(N-4) xor idata(N-5);
-------------------------------------------------------------
	B5_1 <= idata(N-2) xor idata(N-5) xor idata(N-10);
	B5_2 <= idata(N-1) xor idata(N-5) xor idata(N-10);
	B5_5 <= idata(N-1) xor idata(N-2) xor idata(N-10);
	B5_10 <= idata(N-1) xor idata(N-2) xor idata(N-5);

	IF (idata(N-1) = '0') THEN
	Bit1_0 <= Bit1_0 + 1;
	ELSIF (idata(N-1) = '1') THEN 
	Bit1_1 <= Bit1_1 + 1;
	END IF;

	IF (idata(N-2) = '0') THEN
	Bit2_0 <= Bit2_0 + 1;
	ELSIF (idata(N-2) = '1') THEN  
	Bit2_1 <= Bit2_1 + 1;
	END IF;

	IF (idata(N-3) = '0') THEN
	Bit3_0 <= Bit3_0 + 1;
	ELSIF (idata(N-3) = '1') THEN  
	Bit3_1 <= Bit3_1 + 1;
	END IF;	

	IF idata(N-4) = '0' THEN
	Bit4_0 <= Bit4_0 + 1;
	ELSIF (idata(N-4) = '1') THEN  
	Bit4_1 <= Bit4_1 + 1;
	END IF;

	IF idata(N-5) = '0' THEN
	Bit5_0 <= Bit5_0 + 1;
	ELSIF (idata(N-5) = '1') THEN  
	Bit5_1 <= Bit5_1 + 1;
	END IF;

	IF (idata(N-6) = '0') THEN
	Bit6_0 <= Bit6_0 + 1;
	ELSIF (idata(N-6) = '1') THEN 
	Bit6_1 <= Bit6_1 + 1;
	END IF;

	IF (idata(N-7) = '0') THEN
	Bit7_0 <= Bit7_0 + 1;
	ELSIF (idata(N-7) = '1') THEN  
	Bit7_1 <= Bit7_1 + 1;
	END IF;

	IF (idata(N-8) = '0') THEN
	Bit8_0 <= Bit8_0 + 1;
	ELSIF (idata(N-8) = '1') THEN  
	Bit8_1 <= Bit8_1 + 1;
	END IF;

	IF (idata(N-9) = '0') THEN
	Bit9_0 <= Bit9_0 + 1;
	ELSIF (idata(N-9) = '1') THEN  
	Bit9_1 <= Bit9_1 + 1;
	END IF;

	IF (idata(N-10) = '0') THEN
	Bit10_0 <= Bit10_0 + 1;
	ELSIF (idata(N-10) = '1') THEN  
	Bit10_1 <= Bit10_1 + 1;
	END IF;

	END IF;
-----------------------------------------------------------------------------


	IF (current_state = HOLD_1) THEN
	



	END IF;
-----------------------------------------------------------------------------

	IF (current_state = BIT_CHECK) THEN
	

	END IF;



	IF ( current_state = DONE) THEN
		msg_decode_done <= '1';
		odata <= idata(N-1 downto N-5) ;
	ELSE 
		msg_decode_done <= '0';
		odata <= (OTHERS => 'U');
	END IF;

	END IF;

	END PROCESS combinational;


END behav;
