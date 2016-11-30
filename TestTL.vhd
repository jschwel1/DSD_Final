--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:35:42 11/28/2016
-- Design Name:   
-- Module Name:   /home/local/PODS/jschwel1/EECE351/DSD_Final/TestTL.vhd
-- Project Name:  Final_Project
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: TopLevel
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
 
ENTITY TestTL IS
END TestTL;
 
ARCHITECTURE behavior OF TestTL IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT TopLevel
    PORT(
         Osc_Clk : IN  std_logic;
         Switch : IN  std_logic_vector(7 downto 0);
         LED : OUT  std_logic_vector(7 downto 0);
         Seg7_SEG : OUT  std_logic_vector(6 downto 0);
         Seg7_DP : OUT  std_logic;
         Seg7_AN : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Osc_Clk : std_logic := '0';
   signal Switch : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal LED : std_logic_vector(7 downto 0);
   signal Seg7_SEG : std_logic_vector(6 downto 0);
   signal Seg7_DP : std_logic;
   signal Seg7_AN : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant Osc_Clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: TopLevel PORT MAP (
          Osc_Clk => Osc_Clk,
          Switch => Switch,
          LED => LED,
          Seg7_SEG => Seg7_SEG,
          Seg7_DP => Seg7_DP,
          Seg7_AN => Seg7_AN
        );

   -- Clock process definitions
   Osc_Clk_process :process
   begin
		Osc_Clk <= '0';
		wait for Osc_Clk_period/2;
		Osc_Clk <= '1';
		wait for Osc_Clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
   --   wait for 100 ns;	

   --   wait for Osc_Clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;