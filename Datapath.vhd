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
use IEEE.NUMERIC_STD.ALL;

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
	
	COMPONENT Register_File
	generic (data_size: natural := 32; addr_size: natural := 4 );
	PORT(
		clk : IN std_logic;
		WE3 : IN std_logic;
		A1 : IN std_logic_vector(3 downto 0);
		A2 : IN std_logic_vector(3 downto 0);
		A3 : IN std_logic_vector(3 downto 0);
		WD3 : IN std_logic_vector(31 downto 0);
		R15 : IN std_logic_vector(31 downto 0);          
		RD1 : OUT std_logic_vector(31 downto 0);
		RD2 : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;
	
	-- Sources A & B for the ALU
	Signal a,b : std_logic_vector(31 downto 0) := (others => '0'); -- inputs to the ALU
	Signal R_out2, ALUResult_sig  : std_logic_vector(31 downto 0) := (others => '0'); -- Output of RegFile RD2
	Signal PC_Sig, PC_Reg, PC_P8 : std_logic_vector(31 downto 0) := (others => '0'); -- PC signal to be loaded into the PC_Reg
	Signal Result : std_logic_vector(31 downto 0) := (others => '0'); -- Result of ReadData from the data memory
	Signal RA1, RA2 : std_logic_vector(3 downto 0) := (others => '0'); -- Read Addresses into the register file
	
begin
	
	ALU: ARM_ALU PORT MAP(
		A => a,
		B => b,
		ALU_Ctrl => ALUControl,
		Result => ALUResult_sig,
		ALU_Flags => ALUFlags
	);
	ALUResult <= ALUResult_sig;
	
		-- Instatiate the Register File
	RF: Register_File PORT MAP(
		clk => clk,
		WE3 => RegWrite,
		A1 => RA1,
		A2 => RA2,
		A3 => Instr(15 downto 12),
		WD3 => result,
		R15 => PC_P8,
		RD1 => a,
		RD2 => r_out2
	);
-- INSTRUCTION STUFF--------------------------------------
-- Extends and ALU src process	
	process(r_out2,ALUSrc,ImmSrc, Instr)
		begin
			if (ALUSrc='0') then
				b <= R_out2;
			else
				if (ImmSrc = "00") then
					b <= (others => '0');
					b(7 downto 0) <= instr(7 downto 0);
				elsif (ImmSrc = "01") then
					b <= (others => '0');
					b(11 downto 0) <= instr(11 downto 0);
				else
					b(31 downto 26) <= (others => instr(23));
					b(25 downto 2) <= instr(23 downto 0);
					b(1 downto 0) <= "00";
				end if;
			end if;
	end process;
	
-- ALU STUFF
	writeData <= R_out2;
-- Data from ALU/Data reg
	process(readData, ALUResult_Sig, memtoReg)
	begin 
		if (memtoReg = '1') then
			result <= readData;
		else
			result <= ALUResult_sig;
		end if;
	end process;
-- Read Data

-- PROGRAM COUNTER STUFF----------------------------------
--PC Register

	process(clk,PC_Sig, PC_Reg, reset)
		begin
			if rising_edge(clk) then
				if (reset = '1') then
					PC_Reg <= (others => '0');
				else
					PC_Reg <= PC_Sig;
				end if;
			end if;
	end process;
-- PC output	
	PC<=PC_Reg;

--PC Stuff
	process(PCSrc, PC_Reg, result)
		begin
			if PCSrc= '1' then
				Pc_Sig<= Result;
			
			else
				PC_Sig<= std_logic_vector(unsigned(PC_Reg)+4);
			end if;
	end process;
			
			
			
-- Read addresses for RegFile
-- RA1
	process(Instr, RegSrc)
	begin
		if (RegSrc(1) = '1') then
			RA1 <= "1111";
		else
			RA1 <= instr(19 downto 16);
		end if;
	end process;
	
-- RA2
	process(Instr, RegSrc)
	begin
		if (RegSrc(0) = '1') then
			RA2 <= instr(15 downto 12);
		else
			RA2 <= instr(3 downto 0);
		end if;
	end process;
	
-- R15
	PC_P8 <= std_logic_vector(unsigned(PC_Reg) + 8);
end Behavioral;

