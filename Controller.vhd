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
use IEEE.NUMERIC_STD.ALL;

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
	
	-- Conditional Logic Signals
	signal Flags : std_logic_vector(3 downto 0) := (others => '0');
	signal CondEx : std_logic := '0';
	signal FlagWrite : std_logic_vector (1 downto 0) := "00";
	signal NoWrite : std_logic := '0';
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
	MemtoReg <= MainDecoder_out(1); -- OUTPUT
	MemW <= MainDecoder_out(2);
	ALUSrc <= MainDecoder_out(3);	-- OUTPUT
	ImmSrc <= MainDecoder_out(5 downto 4); -- OUTPUT
	RegW <= MainDecoder_out(6);
	RegSrc <= MainDecoder_out(8 downto 7); -- OUTPUT
	ALUOp <= MainDecoder_out(9);
	
	-- ALU Decoder
	process(ALUOp, funct(4 downto 0))
	begin
		if (ALUOp = '0') then
			ALUControl <= "00";
			FlagW <= "00";
		else
			case Funct(4 downto 1) is
				-- ADD
				when "0100" =>
					ALUControl <= "00";
					NoWrite <= '0';
					if (Funct(0) = '0') then
						FlagW <= "00";
					else
						FlagW <= "11";
					end if;
				-- SUB
				when "0010" =>
					ALUControl <= "01";
					NoWrite <= '0';
					if (Funct(0) = '0') then
						FlagW <= "00";
					else
						FlagW <= "11";
					end if;
				-- AND
				when "0000" =>
					ALUControl <= "10";
					NoWrite <= '0';
					if (Funct(0) = '0') then
						FlagW <= "00";
					else
						FlagW <= "10";
					end if;
				-- ORR
				when "1100" =>
					ALUControl <= "11";
					NoWrite <= '0';
					if (Funct(0) = '0') then
						FlagW <= "00";
					else
						FlagW <= "10";
					end if;
				-- CMP
				when "1010" =>
					if (Funct(0) = '1') then
						ALUControl <= "01";
						FlagW <= "11";
						NoWrite <= '1';
					end if;
				when others =>
					ALUControl <= "00";
					FlagW <= "00";
					NoWrite <= '0';
			end case;
		end if;
	end process;
	
	-- PC Logic
	-- PC =1 if PC is written by and instruction or branch (B)
	-- PCS = ((Rd == 15) & RegW) | Branch
	process(Rd, RegW, Branch)
	begin
		if (((to_integer(unsigned(Rd)) = 15) and RegW = '1') or Branch = '1') then
			PCS <= '1';
		else
			PCS <= '0';
		end if;
	end process;
	
	
	------------------ Conditional Logic ------------
	-- Conditional Mnemmonics
	-- Flags(3:0) = NZCV
	process(Cond)
	begin
		case cond is
			when x"0" =>
				if (flags = "-1--") then
					CondEx <= '1';
				else
					CondEx <= '0';
				end if;
			when x"1" =>
				if (flags = "-0--") then
					CondEx <= '1';
				else
					CondEx <= '0';
				end if;
			when x"2" =>
				if (flags = "--1-") then
					CondEx <= '1';
				else
					CondEx <= '0';
				end if;
			when x"3" =>
				if (flags = "--0-") then
					CondEx <= '1';
				else
					CondEx <= '0';
				end if;
			when x"4" =>
				if (flags = "1---") then
					CondEx <= '1';
				else
					CondEx <= '0';
				end if;
			when x"5" =>
				if (flags = "0---") then
					CondEx <= '1';
				else
					CondEx <= '0';
				end if;
			when x"6" =>
				if (flags = "---1") then
					CondEx <= '1';
				else
					CondEx <= '0';
				end if;
			when x"7" =>
				if (flags = "---0") then
					CondEx <= '1';
				else
					CondEx <= '0';
				end if;
			when x"8" =>
				if (flags = "-01-") then
					CondEx <= '1';
				else
					CondEx <= '0';
				end if;
			when x"9" =>
				if (flags = "-1--" or flags = "--0-") then
					CondEx <= '1';
				else
					CondEx <= '0';
				end if;
			when x"A" =>
				if (not(flags = "1---" xor flags = "---1")) then
					CondEx <= '1';
				else
					CondEx <= '0';
				end if;
			when x"B" =>
				if (flags = "1---" xor flags = "---1") then
					CondEx <= '1';
				else
					CondEx <= '0';
				end if;
			when x"C" =>
				if (flags = "-1--" and (not (flags = "1---" xor flags = "---1"))) then
					CondEx <= '1';
				else
					CondEx <= '0';
				end if;
			when x"D" =>
				if (flags = "-1--" or ((flags = "1---" xor flags = "---1"))) then
					CondEx <= '1';
				else
					CondEx <= '0';
				end if;
			when x"E" =>
				CondEx <= '1';
			when others =>
				CondEx <= '0';
		end case;
	end process;
	
	-- Update flags
	FlagWrite(0) <= FlagW(0) and CondEx;
	FlagWrite(1) <= FlagW(1) and CondEx;
	process (clk,ALUFlags, FlagW, FlagWrite, CondEx)
	begin
		if (rising_edge(clk)) then
			if (flagWrite(1) = '1') then
				Flags(3 downto 2) <= ALUFlags(3 downto 2);
			end if;
			if (flagWrite(0) = '1') then
				Flags(1 downto 0) <= ALUFlags(1 downto 0);
			end if;
		end if;
	end process;
	
	-- Combinational logic/outputs
	PCSrc <= PCS and CondEx;
	RegWrite <= RegW and CondEx and (not NoWrite);
	MemWrite <= MemW and CondEx;
	
end Behavioral;

