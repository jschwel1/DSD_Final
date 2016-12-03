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
			  JOY_SELECT: in STD_LOGIC;
			  JOY_UP: in STD_LOGIC;
			  JOY_DOWN: in STD_LOGIC;
			  JOY_LEFT: in STD_LOGIC;
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
	
	COMPONENT debounce
		PORT(
		    clk : in  STD_LOGIC;
			 sig_in : in  STD_LOGIC;
			 sig_out : out  STD_LOGIC
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
	
	COMPONENT arm
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		EnableARM : IN std_logic; 
		Instr : IN std_logic_vector(31 downto 0);
		ReadData : IN std_logic_vector(31 downto 0);          
		PC : OUT std_logic_vector(31 downto 0);
		MemWrite : OUT std_logic;
		ALUResult : OUT std_logic_vector(31 downto 0);
		WriteData : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;
	
	-- Interconnect signals
	signal HexDisp : std_logic_vector(15 downto 0) := x"0000";
	signal PC, Instr, ReadData, WriteData ,ALUResult : std_logic_vector(31 downto 0);
	signal MemWrite : std_logic := '0';
	signal Dm_Addr: std_logic_vector (8 downto 0);
	--signal JoyUp, JoyDown, JoyLeft, JoyRight : std_logic:='0';
	signal reset,run,stop,step:std_logic := '1';
	signal sync_step: std_logic;
	signal run_ARM,en_ARM: std_logic;
	signal WE_Data_Memory: std_logic;
	--Disable writes from memory and other 
	
begin

	reset <= (not JOY_SELECT);
	run <=  (not JOY_UP);
	stop <= (not JOY_DOWN);
	step <= (not JOY_LEFT);
	
	--Debouncer
	JOY_debounce: debounce PORT MAP(
		clk =>Osc_Clk ,
		sig_in => step,
		sig_out => sync_step
	);
	--run arm register
	process(Osc_Clk, reset,stop, run)
		begin 
			if rising_edge(Osc_Clk) then
				if reset='1' or stop='1' then
					run_ARM  <= '0';
				
				elsif run ='1' then
					run_ARM <= '1';
				end if;
			end if;
		end process;
		
	--enable arm register	
	process(Osc_Clk, sync_step, run_ARM)
		begin 
			if rising_edge(Osc_Clk) then
				if run_ARM='1' or sync_step='1' then
					en_ARM  <= '1';
				
				else
					en_ARM <= '0';
				end if;
			end if;
	end process;
		
	WE_Data_Memory <=  MemWrite and en_ARM;
	
	--Hex Display Out
	process (en_ARM, PC, ReadData)
	begin
	
		if en_ARM ='0' then
			HexDisp(3 downto 0) <= PC(3 downto 0);
			HexDisp(7 downto 4) <= PC(7 downto 4);
			HexDisp(11 downto 8) <= ReadData(3 downto 0);
			HexDisp(15 downto 12) <= ReadData(7 downto 4);
		else
			HexDisp <= x"0000";
		end if;
	
	end process;
	
	process (en_ARM,ALUResult, Switch)
	begin
		if en_ARM='1' then
			Dm_Addr <= ALUResult(8 downto 0);
		else
			Dm_Addr <= '0'&Switch;
		end if;
	end process;
	
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
		WE => WE_Data_Memory,
		A => Dm_Addr,
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
		EnableARM => en_ARM,
		PC => PC,
		Instr => Instr,
		MemWrite => MemWrite,
		ALUResult => ALUResult,
		WriteData => WriteData,
		ReadData =>  ReadData
	);
		
	-- Misc connections
	LED(7 downto 0) <= Instr(27 downto 20);	
		
end Behavioral;
