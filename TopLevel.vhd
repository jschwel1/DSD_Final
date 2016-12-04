----------------------------------------------------------------------------------
-- Company: 		 Binghamton University
-- Engineer(s): 
-- 
-- Create Date:    23:13:36 11/13/2016 
-- Design Name: 
-- Module Name:    TopLevel - Behavioral 
-- Project Name: 	 ARM Processor (Single Cycle)
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TopLevel is
    Port ( Osc_Clk : in STD_LOGIC;
			  Switch : in  STD_LOGIC_VECTOR (7 downto 0);
			  JOY_UP, JOY_DOWN, JOY_LEFT, JOY_SELECT : in STD_LOGIC;
           LED : out  STD_LOGIC_VECTOR (7 downto 0);
			  Seg7_SEG : out STD_LOGIC_VECTOR (6 downto 0); 
			  Seg7_DP  : out STD_LOGIC; 
			  Seg7_AN  : out STD_LOGIC_VECTOR (3 downto 0)
			  );
end TopLevel;

architecture Behavioral of TopLevel is

	-- Declare HEXon7segDisp component
	COMPONENT HEXon7segDisp
	PORT(
		hex_data_in1 : IN std_logic_vector(3 downto 0);
		hex_data_in2 : IN std_logic_vector(3 downto 0);
		hex_data_in3 : IN std_logic_vector(3 downto 0);
		hex_data_in4 : IN std_logic_vector(3 downto 0);
		dp_in : IN std_logic_vector(2 downto 0);
		clk : IN std_logic;          
		seg_out : OUT std_logic_vector(6 downto 0);
		an_out : OUT std_logic_vector(4 downto 1);
		dp_out : OUT std_logic
		);
	END COMPONENT;
	
	
	-- Declare the data memory element
	COMPONENT Data_Memory
	PORT(
		clk : IN std_logic;
		WE : IN std_logic;
		A : IN std_logic_vector(8 downto 0);
		WD : IN std_logic_vector(31 downto 0);          
		RD : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;
	
	-- Declare the Instruction Memory Component
	COMPONENT Instruction_Memory
	PORT(
		A : IN std_logic_vector(8 downto 0);          
		RD : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;
	
	-- Declare Debouncer
	COMPONENT debounce
	PORT(
		clk : IN std_logic;
		sig_in : IN std_logic;          
		sig_out : OUT std_logic
		);
	END COMPONENT;

	
	-- Declare the ARM Processor
	COMPONENT arm
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		Instr : IN std_logic_vector(31 downto 0);
		ReadData : IN std_logic_vector(31 downto 0);          
		PC : OUT std_logic_vector(31 downto 0);
		MemWrite : OUT std_logic;
		ALUResult : OUT std_logic_vector(31 downto 0);
		WriteData : OUT std_logic_vector(31 downto 0);
		en_arm : 	IN STD_LOGIC
		);
	END COMPONENT;
	
	-- Interconnect signals
	signal HexDisp : std_logic_vector(15 downto 0) := x"0000";
	signal PC, Instr, ReadData, WriteData, ALUResult : std_logic_vector(31 downto 0);
	signal MemWrite : std_logic := '0';
	
	-- implementation signals
	signal run,stop,step :std_logic := '0';
	signal reset, step_sync : std_logic := '0';
	signal run_ARM, en_ARM : std_logic := '0';
	
begin
	run <= not JOY_UP;
	stop <= not JOY_DOWN;
	step <= not JOY_LEFT;
	reset <= not JOY_SELECT;
	
	-- Logic stuff
	-- RUN_ARM
	process (osc_clk, reset, stop, run)
	begin
		if (rising_edge(osc_clk)) then
			if (reset = '1' or stop = '1') then
				run_ARM <= '0';
			elsif (run = '1') then
				run_ARM <= '1';
			end if;
		end if;
	end process;
	-- EN_ARM
	process(osc_clk)
	begin
		if (rising_edge(osc_clk)) then
			if (run_ARM = '1' or step_sync = '1') then
				en_ARM <= '1';
			else
				en_ARM <= '0';
			end if;
		end if;
	end process;
	
	-- Component Connections
	-- Instantiate the Debounce
	Inst_debounce: debounce PORT MAP(
		clk => osc_clk,
		sig_in => step,
		sig_out => step_sync
	);

	

	-- Instantiate Hex to 7-segment conversion module
	HEXon7segDisp1: HEXon7segDisp PORT MAP(
		hex_data_in1 => HexDisp(3 downto 0),
		hex_data_in2 => HexDisp(7 downto 4),
		hex_data_in3 => HexDisp(11 downto 8),
		hex_data_in4 => HexDisp(15 downto 12),
		dp_in => "000",  -- no decimal point
		seg_out => Seg7_SEG,
		an_out => Seg7_AN,
		dp_out => Seg7_DP,
		clk => Osc_Clk
	);
	
	-- Instatiate Data Memory Element
	Data_Memory_Comp: Data_Memory PORT MAP(
		clk => Osc_Clk,
		WE => MemWrite,
		A => ALUResult(8 downto 0),
		WD => WriteData,
		RD => ReadData
	);

	
	-- Instatiate Instruction Memory Component
	IMem: Instruction_Memory PORT MAP(
		A => (PC(10 downto 2)),
		RD => Instr
	);
	
	-- Instantiate the ARM
	ARM_Comp: arm PORT MAP(
		clk => Osc_Clk,
		reset => reset,
		PC => PC,
		Instr => Instr,
		MemWrite => MemWrite,
		ALUResult => ALUResult,
		WriteData => WriteData,
		ReadData =>  ReadData,
		en_ARM => en_ARM
	);

	-- Misc connections
	LED(7 downto 0) <= "00000000";	
		
end Behavioral;
