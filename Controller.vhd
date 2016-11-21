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
	signal PCS, RegW, MemW, ALUOp, Branch, RegWS : std_logic := '0';
	
	signal MainDecoder_out : std_logic_vector(9 downto 0);
	signal MainDecoder_in :std_logic_vector(3 downto 0);
	
begin

	-- signals are direct connections to the instr input
	cond <= instr(31 downto 28);
	op <= Instr(27 downto 26);
	funct <= instr(25 downto 20);
	Rn <= Instr(19 downto 16);
	Rd <= Instr(15 downto 12);

	--------------------- Decoder --------------------------
	-- Main Decoder
	MainDecoder_in <= op&funct(5)&funct(0);	
	process (op, funct)
	begin
		case MainDecoder_in is
			when "000-" =>
				MainDecoder_out <= "0000001001";
			when "001-" =>
				MainDecoder_out <= "0001001001";
			when "01-0" =>
				MainDecoder_out <= "0011010100";
			when "01-1" =>
				MainDecoder_out <= "0101011000";
			when "11--" =>
				MainDecoder_out <= "1001100010";
			when others =>
				MainDecoder_out <= "0000000000";
		end case;
	end process;
	-- Split up MainDecoder_out into appropriate signals
	Branch <= MainDecoder_out(0);
	MemtoReg <= MainDecoder_out(1);
	MemW <= MainDecoder_out(2);
	ALUSrc <= MainDecoder_out(3);
	ImmSrc <= MainDecoder_out(5 downto 4);
	RegW <= MainDecoder_out(6);
	RegSrc <= MainDecoder_out(8 downto 7);
	ALUOp <= MainDecoder_out(9);
	
	-- ALU Decoder
	process(ALUOp, funct(4 downto 0))
	begin
		
	end process;
	
end Behavioral;

