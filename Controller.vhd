----------------------------------------------------------------------------------
-- Company: 		 Binghamton University
-- Engineer(s): 
-- 
-- Create Date:    23:13:36 11/13/2016 
-- Design Name: 
-- Module Name:    Controller - Behavioral 
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

entity controller is -- single cycle control decoder
  port(clk, reset:        in  STD_LOGIC;
       Instr:             in  STD_LOGIC_VECTOR(31 downto 12);
       ALUFlags:          in  STD_LOGIC_VECTOR(3 downto 0);
       RegSrc:            out STD_LOGIC_VECTOR(1 downto 0);
       RegWrite:          out STD_LOGIC;
       ImmSrc:            out STD_LOGIC_VECTOR(1 downto 0);
       ALUSrc:            out STD_LOGIC;
       ALUControl:        out STD_LOGIC_VECTOR(1 downto 0);
       MemWrite:          out STD_LOGIC;
       MemtoReg:          out STD_LOGIC;
       PCSrc:             out STD_LOGIC);
end;
architecture Behavioral of Controller is

begin


end Behavioral;

