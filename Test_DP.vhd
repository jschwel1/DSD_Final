--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:22:42 11/16/2016
-- Design Name:   
-- Module Name:   /home/local/PODS/jschwel1/EECE351/Final_Project/Test_DP.vhd
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
USE ieee.numeric_std.ALL;
 
ENTITY Test_DP IS
END Test_DP;
 
ARCHITECTURE behavior OF Test_DP IS 
 
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
	
	
	-- Define things....
	type data
	
 
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
