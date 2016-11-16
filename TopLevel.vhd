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
	
	-- Declare the Controller
	COMPONENT controller
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		Instr : IN std_logic_vector(31 downto 12);
		ALUFlags : IN std_logic_vector(3 downto 0);          
		RegSrc : OUT std_logic_vector(1 downto 0);
		RegWrite : OUT std_logic;
		ImmSrc : OUT std_logic_vector(1 downto 0);
		ALUSrc : OUT std_logic;
		ALUControl : OUT std_logic_vector(1 downto 0);
		MemWrite : OUT std_logic;
		MemtoReg : OUT std_logic;
		PCSrc : OUT std_logic
		);
	END COMPONENT;
	
	-- Declare Datapath
	COMPONENT datapath
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		RegSrc : IN std_logic_vector(1 downto 0);
		RegWrite : IN std_logic;
		ImmSrc : IN std_logic_vector(1 downto 0);
		ALUSrc : IN std_logic;
		ALUControl : IN std_logic_vector(1 downto 0);
		MemtoReg : IN std_logic;
		PCSrc : IN std_logic;
		Instr : IN std_logic_vector(31 downto 0);
		ReadData : IN std_logic_vector(31 downto 0);          
		ALUFlags : OUT std_logic_vector(3 downto 0);
		PC : OUT std_logic_vector(31 downto 0);
		ALUResult : OUT std_logic_vector(31 downto 0);
		WriteData : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;
	
	-- Interconnect signals
	signal HexDisp : std_logic_vector(15 downto 0) := x"0000";
	signal PC_sig : std_logic_vector(31 downto 0);
	signal instruction : std_logic_vector(31 downto 0);
begin

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
--	Data_Memory: Data_Memory PORT MAP(
--		clk => Osc_Clk,
--		WE => ,
--		A => ,
--		WD => ,
--		RD => 
--	);

	
	-- Instatiate Instruction Memory Component
--	IMem: Instruction_Memory PORT MAP(
--		A => PC,
--		RD => 
--	);
	
	-- Instantiate the controller
--	Inst_controller: controller PORT MAP(
--		clk => Osc_clk,
--		reset => ,
--		Instr => ,
--		ALUFlags => ,
--		RegSrc => ,
--		RegWrite => ,
--		ImmSrc => ,
--		ALUSrc => ,
--		ALUControl => ,
--		MemWrite => ,
--		MemtoReg => ,
--		PCSrc => 
--	);
	
	-- Instantiate the Datapath
--	Inst_datapath: datapath PORT MAP(
--		clk => Osc_clk,
--		reset => ,
--		RegSrc => ,
--		RegWrite => ,
--		ImmSrc => ,
--		ALUSrc => ,
--		ALUControl => ,
--		MemtoReg => ,
--		PCSrc => ,
--		ALUFlags => ,
--		PC => ,
--		Instr => ,
--		ALUResult => ,
--		WriteData => ,
--		ReadData => 
--	);

	-- Misc connections
	LED(7 downto 0) <= "00000000";	
		
end Behavioral;
