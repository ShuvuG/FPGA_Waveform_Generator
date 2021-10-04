-- Test bench to simulate and check functionality of a 
-- Frequency Divider 
 
--Designer:        Shuvechchha Ghimire 
--Date:           8/05/19 
--Version No:      2 
 
library ieee; 
use ieee.std_logic_1164.all; 
 
entity testbench is 
end testbench; 
 
architecture test1 of testbench is 
 
signal selector: std_logic; 
signal frequency_select:  integer range 0 to 255; 
signal clkin: std_logic; 
signal frequency_out1,frequency_out2: std_logic; 
constant clk_period :time := 20ns; 
 
begin 
instance1: 	entity work. Frequency_Divider 
port map (magnitude_selector=>selector, desired_frequency =>frequency_select, clkin=>clkin, frequency_out1 => frequency_out1 , frequency_out2 => frequency_out2); 
 		 
stimulation: process	 
begin 
clkin <= '0'; 
wait for clk_period/2; 
clkin<= '1'; 
wait for clk_period/2; 
 
end process; 
 
simualte : process 
begin  
selector <= '0'; 
wait for clk_period*1000000;	 
selector<= '1'; 
wait for clk_period*5000000; 
 
end process; 
 
frequency_select <= 99; 
 
end; 
