--VHDL code for Register File 
--(1 of 3)
--27
--
--Port Register File with Asynchronous Read
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Register_File is
	generic (data_size: natural := 32; addr_size: natural := 4 );
	port (
		clk: in std_logic;
		WE3  : in std_logic;
		A1   : in std_logic_vector(addr_size-1 downto 0);
		A2   : in std_logic_vector(addr_size-1 downto 0);
		A3   : in std_logic_vector(addr_size-1 downto 0);
		WD3  : in std_logic_vector(data_size-1 downto 0);
		R15  : in std_logic_vector(data_size-1 downto 0);
		RD1  : out std_logic_vector(data_size- 1 downto 0); 
		RD2  : out std_logic_vector(data_size-1 downto 0));
end Register_File;

architecture Behavioral of Register_File is

	type RegFile_type is array(0 to 2**addr_size -1) of 
										std_logic_vector(data_size-1 downto 0);
	Signal RegFile: RegFile_type;
	
	begin
	--Write in Regfile
		process(clk, WE3, A3, WD3)
		begin
			if rising_edge(clk) then
				if WE3='1' then
					RegFile(to_integer(unsigned(A3))) <= WD3;
				end if;
			end if;
		end process;
			
		-- Read Address
		process(A1,A2,R15)
			begin
			-- Read 1 from Address 1
			if to_integer(unsigned(A1)) = 15 then
				RD1 <= R15;
			else
				RD1 <=RegFile(to_integer(unsigned(A1)));
			end if;
			
			-- Read 2 from address 2
			if to_integer(unsigned(A2)) = 15 then
				RD2 <=R15;
			else
				RD2 <=RegFile(to_integer(unsigned(A2)));
			end if;
			
		end process;
		
	end Behavioral;