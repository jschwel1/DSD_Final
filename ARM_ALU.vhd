----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Jacob Schwell, Dominic Schroeder
-- 
-- Create Date:    13:47:50 11/14/2016 
-- Design Name: 
-- Module Name:    ARM_ALU - Behavioral 
-- Project Name: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ARM_ALU is
    Port ( A, B : in  STD_LOGIC_VECTOR (31 downto 0);
           ALU_Ctrl : in  STD_LOGIC_VECTOR (1 downto 0);
           Result : out  STD_LOGIC_VECTOR (31 downto 0);
           ALU_Flags : out  STD_LOGIC_VECTOR (3 downto 0));
end ARM_ALU;

architecture Behavioral of ARM_ALU is
	-- ALU Flag signals
	signal V, C, N, Z : std_logic := '0';
	
	-- Misc Signals
	signal sum : std_logic_vector(32 downto 0); -- 1 bit larger than allotted for the output to hold onto the carry-out bit
	signal Mux2_1 : std_logic_vector(31 downto 0); -- output from mux to determine decide ADD vs SUB
	signal r_sig : std_logic_vector (31 downto 0); -- Result from the 4-to-1 Mux
	
	
begin
	-- 2 to 1 mux output to change B for + or -
	process(ALU_ctrl, B)
	begin
		if (ALU_ctrl(0) = '1') then
			Mux2_1 <= (not B);
		else
			Mux2_1 <= B;
		end if;
	end process;


	-- get the sum
	process(ALU_ctrl, A, B, Mux2_1)
	begin
		-- the B input has already been inverted. The Carry-in input adds 1 or 0 to the sum, so it can
		-- work easily as addition or subtraction (with the Mux above to invert B).
		if (ALU_ctrl(0) = '1') then
			sum <= std_logic_vector(resize(signed(Mux2_1), 33) + resize(signed(A), 33) +1);
		else
			sum <= std_logic_vector(resize(signed(Mux2_1), 33) + resize(signed(A), 33));
		end if;
	end process;

	-- 4 to 1 mux (AND, OR, SUB, ADD)
	process(ALU_ctrl, A, B, sum)
	begin
		case ALU_ctrl is
			when "11" =>
				r_sig <= A or B;
			when "10" =>
				r_sig <= A and B;
			when others =>
				r_sig <= sum(31 downto 0); -- The Adder output goes to both 00 & 01
		end case;
	end process;
	
	-- Output the result to result port
	result <= r_sig;

	-- Zero flag process
	process (r_sig)
	begin
		-- Z goes high if the result is 0
		if (signed(r_sig) = 0) then 
			Z <= '1';
		else
			Z <= '0';
		end if;
	end process;
	
	-- Negative Flag
	-- Goes high if the MSB of the result is high
	N <= r_sig(31);

	-- Overflow Flag
	-- Three inputs ANDed together
	--			1) ALU_ctrl(0) xor A(31) xor B(31)
	--			2) A(31) xor sum(31)
	--			3) not ALU_ctrl(1)
	V <= (not ( ALU_ctrl(0) xor A(31) xor B(31))) 
			and (A(31) xor sum(31)) 
			and (not ALU_ctrl(1));

	-- Carry Flag
	-- If the operation was an ADD/SUB and the MSB of sub was high
	C <= (not ALU_Ctrl(1)) and sum(32);

	-- Concatenate Flags
	ALU_Flags <= N&Z&C&V;

end Behavioral;

