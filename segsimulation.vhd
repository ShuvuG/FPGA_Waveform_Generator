-- Test bench to test functionality of a 
--Seven segment display 

--Designer:        Shuvechchha Ghimire 
--Date:           8/05/19 
--Version No:      2 
 
library ieee;  -- libraries 
use ieee.std_logic_1164.all; 
 
entity testbench is 
end testbench; 
 
architecture test1 of testbench is 
 
signal freq_input : integer range 0 to 255; 
signal selector_input : std_logic_vector(1 downto 0); 
signal onoff_input1, onoff_input2  :  std_logic; 
signal Display1,Display2,Display3,Display4,Display5 : std_logic_vector (6 downto 0); 
 
 
constant clk_period:time:=50ns; 
 
begin 
instance1: 	entity work. Display_7seg  
port map (freq_input=>freq_input, selector_input=>selector_input, Display1=>Display1, Display2=>Display2, Display3=>Display3, Display4=>Display4, Display5=>Display5, onoff_input1 => onoff_input1, onoff_input2 => onoff_input2); 
 		 
stimulation: process	 
begin 
selector_input <= "00"; 
wait for clk_period *3; 
selector_input <= "01"; 
wait for clk_period *3; 
selector_input <= "10"; 
wait for clk_period *3; 
selector_input<= "11"; 
wait for clk_period *3; 
end process; 
 
stimulation1: process	 
begin 
onoff_input1 <= '1'; 
onoff_input2 <= '1'; 
wait for clk_period *12; 
onoff_input1 <= '0'; 
onoff_input2 <= '0'; 
wait for clk_period *2; 
end process;	 
 
freq_input <= 245, 204 after 200ns, 140 after 400ns, 125 after 600ns, 20 after 800ns, 1 after 1000ns ; 
end; 
