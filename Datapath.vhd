----------------------------------------------------------------------------------
-- Company: 		 Binghamton University
-- Engineer(s): 
-- 
-- Create Date:    23:13:36 11/13/2016 
-- Design Name: 
-- Module Name:    Datapath - Behavioral 
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

entity datapath is  
  port(clk, reset:        in  STD_LOGIC;
       RegSrc:            in  STD_LOGIC_VECTOR(1 downto 0);
       RegWrite:          in  STD_LOGIC;
       ImmSrc:            in  STD_LOGIC_VECTOR(1 downto 0);
       ALUSrc:            in  STD_LOGIC;
       ALUControl:        in  STD_LOGIC_VECTOR(1 downto 0);
       MemtoReg:          in  STD_LOGIC;
       PCSrc:             in  STD_LOGIC;
       ALUFlags:          out STD_LOGIC_VECTOR(3 downto 0);
       PC:                out STD_LOGIC_VECTOR(31 downto 0);
       Instr:             in  STD_LOGIC_VECTOR(31 downto 0);
       ALUResult, WriteData: out STD_LOGIC_VECTOR(31 downto 0);
       ReadData:          in  STD_LOGIC_VECTOR(31 downto 0));
end;

architecture Behavioral of Datapath is

	COMPONENT ARM_ALU
	PORT(
		A : IN std_logic_vector(31 downto 0);
		B : IN std_logic_vector(31 downto 0);
		ALU_Ctrl : IN std_logic_vector(1 downto 0);          
		Result : OUT std_logic_vector(31 downto 0);
		ALU_Flags : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
	
	-- Sources A & B for the ALU
	Signal a,b : std_logic_vector(31 downto 0);
	
begin
	
	ALU: ARM_ALU PORT MAP(
		A => a,
		B => b,
		ALU_Ctrl => ALUControl,
		Result => ALUResult,
		ALU_Flags => ALUFlags
	);

end Behavioral;

