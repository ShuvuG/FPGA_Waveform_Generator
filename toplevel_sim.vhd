-- Testbench to test the top-level entity of    
--Simple Frequency Generator 

--Designer:        Shuvechchha Ghimire 
--Date:            13/05/19 
--Version No:      4 
 
library ieee; 
use ieee.std_logic_1164.all; 
 
entity testbench is 
end testbench; 
 
architecture test1 of testbench is 
 
            signal desired_freq: std_logic_vector(7 downto 0); 
            signal wave_selector:  std_logic_vector(1 downto 0); 
            signal on_off, clk_in_50MHz, magnitude_selector:  std_logic; 
            signal output_7seg1, output_7seg2, output_7seg3, output_7sega, output_7segb :std_logic_vector(6 downto 0); 
            signal output_DAC: integer range 0 to 255; 
            constant clk_period :time := 20ns; 
     
begin 
        instance1:     entity work.VHDL_Assignment  
                port map ( desired_freq=>desired_freq, wave_selector =>wave_selector, on_off=>on_off, clk_in_50MHz => clk_in_50MHz, magnitude_selector => magnitude_selector, output_7seg1 => output_7seg1, output_7seg2 => output_7seg2, output_7seg3 => output_7seg3, output_7sega => output_7sega, output_7segb => output_7segb, output_DAC=> output_DAC); 
          
clock: process     
    begin 
            clk_in_50MHz<= '1';             
            wait for clk_period/2; 
 
            clk_in_50MHz <= '0';     
            wait for clk_period/2;           
   
end process; 
 
wave_selector1: process     
    begin          
            wave_selector <= "01";				 
wait for clk_period*400000;       
  
            wave_selector<= "10";             
            wait for clk_period*400000;       
       
            wave_selector <= "11";     
             wait for clk_period*400000; 
 
wave_selector<= "00"; 
                wait for clk_period*400000;		 
     
end process; 
            
on_off1: process 
begin 
            on_off<= '0'; 
            wait for clk_period*20; 
            on_off <= '1'; 
            wait for clk_period*7000000; 
end process;     
 
magnitude_selector1: process 
begin 
            magnitude_selector<= '0'; 
desired_freq <= "11110111"; 
            wait for clk_period*1750000; 
 
            magnitude_selector <= '1'; 
desired_freq <= "00000011"; 
            wait for clk_period*1750000; 
 
end process; 
end; 
