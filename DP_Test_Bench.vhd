--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:41:23 11/24/2016
-- Design Name:   
-- Module Name:   C:/Users/Jacob/Desktop/VHDL/DSD_Final/DP_Test_Bench.vhd
-- Project Name:  Final_Project
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: datapath
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY DP_Test_Bench IS
END DP_Test_Bench;
 
ARCHITECTURE behavior OF DP_Test_Bench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT datapath
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         RegSrc : IN  std_logic_vector(1 downto 0);
         RegWrite : IN  std_logic;
         ImmSrc : IN  std_logic_vector(1 downto 0);
         ALUSrc : IN  std_logic;
         ALUControl : IN  std_logic_vector(1 downto 0);
         MemtoReg : IN  std_logic;
         PCSrc : IN  std_logic;
         ALUFlags : OUT  std_logic_vector(3 downto 0);
         PC : OUT  std_logic_vector(31 downto 0);
         Instr : IN  std_logic_vector(31 downto 0);
         ALUResult : OUT  std_logic_vector(31 downto 0);
         WriteData : OUT  std_logic_vector(31 downto 0);
         ReadData : IN  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    
	-- Test Data
	type test_vector is record
		RegSrc : std_logic_vector(1 downto 0);
		RegWrite : std_logic;
		ImmSrc : std_logic_vector(1 downto 0);
		ALUSrc : std_logic;
		ALUControl : std_logic_vector(1 downto 0);
		MemtoReg : std_logic;
		PCSrc : std_logic;
		Instr : std_logic_vector(31 downto 0);
		ReadData : std_logic_vector(31 downto 0);
	end record;
	
	type test_data_array is array (natural range <>) of test_vector;
	constant test_data : test_data_array :=
	(
	-- RegSrc(2), RegWrite(1),ImmSrc(2), ALUSrc(1)
	-- ALUControl(2), MemtoReg, PCSrc(1), Instr, ReadData(32)
	
		--("00", '1',"00",), -- Load data into R5
		(""), -- Load data into R6
		(""), -- R7 = R5 + R6
		("") -- Branch to 0
	);
	
   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal RegSrc : std_logic_vector(1 downto 0) := (others => '0');
   signal RegWrite : std_logic := '0';
   signal ImmSrc : std_logic_vector(1 downto 0) := (others => '0');
   signal ALUSrc : std_logic := '0';
   signal ALUControl : std_logic_vector(1 downto 0) := (others => '0');
   signal MemtoReg : std_logic := '0';
   signal PCSrc : std_logic := '0';
   signal Instr : std_logic_vector(31 downto 0) := (others => '0');
   signal ReadData : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal ALUFlags : std_logic_vector(3 downto 0);
   signal PC : std_logic_vector(31 downto 0);
   signal ALUResult : std_logic_vector(31 downto 0);
   signal WriteData : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: datapath PORT MAP (
          clk => clk,
          reset => reset,
          RegSrc => RegSrc,
          RegWrite => RegWrite,
          ImmSrc => ImmSrc,
          ALUSrc => ALUSrc,
          ALUControl => ALUControl,
          MemtoReg => MemtoReg,
          PCSrc => PCSrc,
          ALUFlags => ALUFlags,
          PC => PC,
          Instr => Instr,
          ALUResult => ALUResult,
          WriteData => WriteData,
          ReadData => ReadData
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
