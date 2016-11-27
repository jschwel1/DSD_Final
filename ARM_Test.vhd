--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:55:30 11/24/2016
-- Design Name:   
-- Module Name:   C:/Users/Jacob/Desktop/VHDL/DSD_Final/ARM_Test.vhd
-- Project Name:  Final_Project
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: arm
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
 
ENTITY ARM_Test IS
END ARM_Test;
 
ARCHITECTURE behavior OF ARM_Test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT arm
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         PC : OUT  std_logic_vector(31 downto 0);
         Instr : IN  std_logic_vector(31 downto 0);
         MemWrite : OUT  std_logic;
         ALUResult : OUT  std_logic_vector(31 downto 0);
         WriteData : OUT  std_logic_vector(31 downto 0);
         ReadData : IN  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal Instr : std_logic_vector(31 downto 0) := (others => '0');
   signal ReadData : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal PC : std_logic_vector(31 downto 0);
   signal MemWrite : std_logic;
   signal ALUResult : std_logic_vector(31 downto 0);
   signal WriteData : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
	-- Declare the instruction set
	type instr_set_type is array (natural range <>) of std_logic_vector(31 downto 0);
	constant instr_set : instr_set_type :=
		(
	--		x"E3A05064", -- MOV R5, #100
	--		x"E3A06045", -- MOV R6, #69
	--		x"E1550006", -- CMP R5, R6
	--		x"E0454006", -- SUB R4, R5, R6
	--		x"E0857006", -- ADD R7, R5, R6
	--		x"EA000000"  -- B #0
			x"E4105014", -- LD x14 into R5
			x"E4106020" -- LD x20 into R6
		);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: arm PORT MAP (
          clk => clk,
          reset => reset,
          PC => PC,
          Instr => Instr,
          MemWrite => MemWrite,
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
    --  wait for 100 ns;	

     -- wait for clk_period*10;

      -- insert stimulus here 
		for i in instr_set'range loop
			Instr <= instr_set(i);
			wait for clk_period*1;
		end loop;
      wait;
   end process;

END;
