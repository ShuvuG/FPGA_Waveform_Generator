--Magnitude 0 
-- Test bench to test functionality of a 
--Square Wave Generator 

--Date:           11/05/19 
--Version No:      2 
 
library ieee; 
use ieee.std_logic_1164.all; 
 
entity testbench is 
end testbench; 
 
architecture test1 of testbench is 
 
signal clkin: std_logic; 
signal slowclk: integer range 0 to 255; 
signal desired_frequency: integer range 0 to 255; 
signal magnitude_selector: std_logic; 
constant clk_period :time := 20ns; 
 
begin 
instance1: 	entity work. SquareGenerator   
port map (clkin=>clkin, sq_out=>slowclk, desired_frequency=>desired_frequency, magnitude_selector => magnitude_selector); 
 		 
stimulation: process	 
begin 
clkin<= '1'; 
wait for clk_period/2; 
clkin <= '0'; 
wait for clk_period/2; 
end process; 
 
magnitude_selector<= '1'; 
 
desired_frequency <= 245, 32 after 50000000ns,105 after 100000000ns , 1 after 150000000ns ; 
 
end; 
Magnitude 0 
library ieee; 
use ieee.std_logic_1164.all; 
 
entity testbench is 
end testbench; 
 
architecture test1 of testbench is 
 
signal clkin: std_logic; 
signal slowclk: integer range 0 to 255; 
signal desired_frequency: integer range 0 to 255; 
signal magnitude_selector: std_logic; 
constant clk_period :time := 20ns; 
 
begin 
instance1: 	entity work.checker   
port map (clkin=>clkin, sq_out=>slowclk, desired_frequency=>desired_frequency, magnitude_selector => magnitude_selector); 
 		 
stimulation: process	 
begin 
clkin<= '1'; 
wait for clk_period/2; 
clkin <= '0'; 
wait for clk_period/2; 
end process; 
magnitude_selector<= '0'; 
desired_frequency <= 245, 32 after 50000000ns,105 after 100000000ns , 1 after 150000000ns ; 
 
end; 
------------------------------
--Magnitude 1 

--Date:           11/05/19 
--Version No:      2 

library ieee; 
use ieee.std_logic_1164.all; 
 
entity testbench is 
end testbench; 
 
architecture test1 of testbench is 
 
signal clkin: std_logic; 
signal slowclk: integer range 0 to 255; 
signal desired_frequency: integer range 0 to 255; 
signal magnitude_selector: std_logic; 
constant clk_period :time := 20ns; 
 
begin 
instance1: 	entity work.checker   
port map (clkin=>clkin, sq_out=>slowclk, desired_frequency=>desired_frequency, magnitude_selector => magnitude_selector); 
 		 
stimulation: process	 
begin 
clkin<= '1'; 
wait for clk_period/2; 
clkin <= '0'; 
wait for clk_period/2; 
end process; 
magnitude_selector<= '0'; 
desired_frequency <= 245, 32 after 50000000ns,105 after 100000000ns , 1 after 150000000ns ; 
 
end; 
