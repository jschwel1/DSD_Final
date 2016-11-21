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

	-- Instruction Signals
	signal cond : std_logic_vector(3 downto 0) := Instr(31 downto 28);
	signal op : std_logic_vector(1 downto 0) := Instr(27 downto 26);
	signal funct : std_logic_vector(5 downto 0) := Instr(25 downto 20);
	signal Rn : std_logic_vector(3 downto 0) := Instr(19 downto 16);
	signal Rd : std_logic_vector(3 downto 0) := Instr(15 downto 12);
	-- Other internal signals
	signal FlagW : std_logic_vector(1 downto 0) := "00"; -- [1] NZ (3:2) 
																		  -- [0] CV (1:0)
	
	
begin

	-- signals are direct connections to the instr input
	cond <= instr(31 downto 28);
	op <= Instr(27 downto 26);
	funct <= instr(25 downto 20);
	Rn <= Instr(19 downto 16);
	Rd <= Instr(15 downto 12);

	process (Instr, clk, reset)
	begin
		
	end process;
end Behavioral;

