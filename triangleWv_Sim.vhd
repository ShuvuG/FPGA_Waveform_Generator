-- Triangle wave generator 
 
--Date:           8/05/19 
--Version No:      2 
 
library ieee;  -- Libraries 
use ieee.std_logic_1164.all; 
 
entity test_bench is 
end test_bench; 
 
architecture test1 of test_bench is 
signal clkin: std_logic; 
signal tri_out: integer range 0 to 255; 
constant clk_period :time := 10ns;  -- base clock constant 
 
begin 
instance1: 	entity work.TriangleWaveCode  
port map (clkin=>clkin,tri_out=>tri_out); 
 
process_clkin : process   -- makes a looping clock 
begin 
clkin <= '0'; 
wait for clk_period*1; 
clkin <= '1'; 
wait for clk_period*1; 
 
end process; 
end test1; 
