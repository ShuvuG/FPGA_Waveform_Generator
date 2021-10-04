-- Sine and saw wave 
 
--Date:           8/05/19 
--Version No:      2 
 
library ieee;  -- Libraries 
use ieee.std_logic_1164.all; 
 
entity test_bench is 
end test_bench; 
 
architecture test1 of test_bench is 
signal clkin: std_logic; 
signal saw_out: integer range 0 to 255; 
signal sine_out: integer range 0 to 255; 
constant clk_period :time := 10ns; 
 
begin 
instance1: 	entity work.SineWaveCode_test  
port map (clkin=>clkin,saw_out=>saw_out,sine_out=>sine_out); 
 
process_clkin : process   -- this just creates a clock, so two clear waves are produced 
begin 
clkin <= '0'; 
wait for clk_period*1; 
clkin <= '1'; 
wait for clk_period*1; 
 
end process; 
end test1; 
