LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.all;


ENTITY LDPC IS

GENERIC(
	-- Define Generics
	 N :natural := 5; -- Length of Message Bits
	 C : natural := 10 -- Length of Codewords
);

PORT(
	-- Clock and Reset
	clk : IN std_logic;
	rstb : IN std_logic;


	-- Input Interface I/O
	code_data : IN std_logic_vector(N-1 downto 0);

	-- Output Interface I/O
	edone : OUT std_logic;
	error_data : OUT std_logic_vector (N-1 downto 0)
);

END LDPC;



ARCHITECTURE behav OF Top_Level IS


COMPONENT encoder IS

GENERIC(
	-- Define Generics
	 N :natural := 5; -- Length of Message Bits
	 C : natural := 10 -- Length of Codewords
);

PORT(
	-- Clock and Reset
	clk : IN std_logic;
	rstb : IN std_logic;


	-- Input Interface I/O
	isop : IN std_logic;
	ivalid: IN std_logic;
	idata : IN std_logic_vector(N-1 downto 0);

	-- Output Interface I/O
	edone : OUT std_logic;
	odata : OUT std_logic_vector (C-1 downto 0)
);

END COMPONENT;

COMPONENT Bit_Erasure IS

GENERIC(
	-- Define Generics
	 C : natural := 10 -- Length of Codewords
);

PORT(
	-- Clock and Reset
	clk : IN std_logic;
	rstb : IN std_logic;


	-- Input Interface I/O
	isop : IN std_logic;
	code_data : IN std_logic_vector(C-1 downto 0);

	-- Output Interface I/O
	edone : OUT std_logic;
	error_data : OUT std_logic_vector (C-1 downto 0)
);

END COMPONENT;




BEGIN


END behav;