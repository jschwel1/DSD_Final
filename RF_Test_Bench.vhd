--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:12:49 11/25/2016
-- Design Name:   
-- Module Name:   C:/Users/Jacob/Desktop/VHDL/DSD_Final/RF_Test_Bench.vhd
-- Project Name:  Final_Project
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Register_File
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
 
ENTITY RF_Test_Bench IS
END RF_Test_Bench;
 
ARCHITECTURE behavior OF RF_Test_Bench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Register_File
    PORT(
         clk : IN  std_logic;
         WE3 : IN  std_logic;
         A1 : IN  std_logic_vector(3 downto 0);
         A2 : IN  std_logic_vector(3 downto 0);
         A3 : IN  std_logic_vector(3 downto 0);
         WD3 : IN  std_logic_vector(31 downto 0);
         R15 : IN  std_logic_vector(31 downto 0);
         RD1 : OUT  std_logic_vector(31 downto 0);
         RD2 : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
   -- Test data
	type Test_vector is record
		A1 : std_logic_vector(3 downto 0);
		A2 : std_logic_vector(3 downto 0);
		A3 : std_logic_vector(3 downto 0);
		WD3 : std_logic_vector(31 downto 0);
		R15 : std_logic_vector(31 downto 0);
	end record;
	
	
	type test_data_array is array(natural range <>) of Test_vector;
	constant test_data : test_data_array :=(
		(x"1", x"1", x"4", x"00000004", x"00000001"),
		(x"1", x"1", x"5", x"00000054", x"00000002"),
		(x"1", x"1", x"6", x"00000074", x"00000003"),
		(x"1", x"1", x"7", x"00000904", x"00000004"),
		(x"1", x"1", x"8", x"00002004", x"00000005")
	);

   --Inputs
   signal clk : std_logic := '0';
   signal WE3 : std_logic := '1';
   signal A1 : std_logic_vector(3 downto 0) := (others => '0');
   signal A2 : std_logic_vector(3 downto 0) := (others => '0');
   signal A3 : std_logic_vector(3 downto 0) := (others => '0');
   signal WD3 : std_logic_vector(31 downto 0) := (others => '0');
   signal R15 : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal RD1 : std_logic_vector(31 downto 0);
   signal RD2 : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Register_File PORT MAP (
          clk => clk,
          WE3 => WE3,
          A1 => A1,
          A2 => A2,
          A3 => A3,
          WD3 => WD3,
          R15 => R15,
          RD1 => RD1,
          RD2 => RD2
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
   --   wait for 100 ns;	

   --   wait for clk_period*10;

      -- insert stimulus here 

		for i in test_data'range loop
			A1 <= test_data(i).A1;
			A2 <= test_data(i).A2;
			A3 <= test_data(i).A3;
			WD3 <= test_data(i).WD3;
			R15 <= test_data(i).R15;
			wait for clk_period;
		end loop;
      wait;
   end process;

END;
