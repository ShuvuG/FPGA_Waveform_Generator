-- Test bench to test functionality of a 
--Multiplexer 
 
-- Title:          VHDLProject.vhd 
--Designer:        Shuvechchha Ghimire 
--Date:           8/05/19 
--Version No:      2 
 
library ieee; - libraries 
use ieee.std_logic_1164.all; 
 
entity testbench is 
end testbench; 
 
architecture test1 of testbench is 
 
signal sq_in, tri_in, saw_in, sine_in:  integer range 0 to 255; 
signal wave_select:  std_logic_vector (1 downto 0); 
signal onoff_input:  std_logic;  
signal output:  integer range 0 to 255; 
constant clk_period :time := 20ns; 
 
begin 
instance1: 	entity work. multiplexer   
port map (sq_in=>sq_in, tri_in =>tri_in, saw_in=>saw_in, sine_in =>sine_in, wave_select => wave_select, onoff_input=> onoff_input, output => output); 
 
process_onoff: process 
begin  
onoff_input <= '0'; 
wait for clk_period *5; 
onoff_input <= '1'; 
wait for clk_period *25; 
end process;  
  
stimulation: process	 
begin 
wave_select <= "00"; 
wait for clk_period *6; 
wave_select <= "01"; 
wait for clk_period *6; 
wave_select <= "10"; 
wait for clk_period *6; 
wave_select <= "11"; 
wait for clk_period *6; 
end process; 
 
sq_in <= 245, 204 after 500ns , 0 after 1000ns; 
tri_in<= 164 , 24 after 500ns , 10 after 1000ns; 
saw_in<= 12 , 4 after 500ns , 214 after 1000ns; 
sine_in <= 98 , 85 after 500ns, 200 after 1000ns; 
end;
