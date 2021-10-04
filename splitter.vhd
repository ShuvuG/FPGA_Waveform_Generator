-- Test bench to simulate 
--Splitter 
 
--Designer:        Shuvechchha Ghimire 
--Date:           8/05/19 
--Version No:      2 
 
library ieee; 
use ieee.std_logic_1164.all; 
 
entity testbench is 
end testbench; 
 
architecture test1 of testbench is 
 
signal desired_frequency : std_logic_vector (7 downto 0); 
signal magnitude_selector:  std_logic; 
signal wave_select : std_logic_vector (1 downto 0); 
signal onoff_input:  std_logic; 
signal clock_in: std_logic; 
 
signal desired_frequency1, desired_frequency2, desired_frequency3 :  integer range 0 to 255; 
signal magnitude_selector_out1, magnitude_selector_out2:std_logic; 
signal wave_select_out1: std_logic_vector (1 downto 0); 
signal wave_select_out2:  integer range 0 to 3; 
signal onoff_out1, onoff_out2, onoff_out3:  std_logic; 
signal clock_out1, clock_out2:  std_logic; 
 
 
 
constant clk_period :time := 20ns; 
 
begin 
instance1: 	entity work.splitter  
port map (desired_frequency=>desired_frequency,  magnitude_selector=> magnitude_selector, wave_select=>wave_select, onoff_input=> onoff_input,  clock_in=> clock_in, desired_frequency1=>desired_frequency1, desired_frequency2=>desired_frequency2, desired_frequency3=>desired_frequency3, magnitude_selector_out1=>magnitude_selector_out1, magnitude_selector_out2=>magnitude_selector_out2, wave_select_out1=>wave_select_out1, wave_select_out2=>wave_select_out2, onoff_out1=>onoff_out1, onoff_out2=>onoff_out2, onoff_out3=>onoff_out3, clock_out1=>clock_out1, clock_out2=>clock_out2); 
 
desired_frequency <= "00000000", "00000001" after 100ns, "00000010" after 150ns, "00000100" after 200ns, "00001000" after 250ns,  "00010000" after 300ns, "00100000" after 400ns, "01000000" after 450ns, "10000000" after 500ns; 
wave_select <= "00", "01" after 150ns, "10" after 300ns, "11" after 600ns, "00" after 800ns;			 
 
stimulation: process	 
begin 
onoff_input <= '1'; 
wait for clk_period *12; 
onoff_input<='0';  
wait for clk_period *2; 
end process; 
 
magnitude: process	 
begin 
magnitude_selector <= '1'; 
wait for clk_period *6; 
magnitude_selector<='0';  
wait for clk_period *6; 
end process; 
 
clock: process 
begin  
clock_in <= '0'; 
wait for clk_period; 
clock_in <='1'; 
wait for clk_period; 
end process; 
end; 
