-- VHDL implementation of a  
-- FREQUENCY DIVIDER 

--Date:			10/05/19 
--Version: 		3 
--Target       DE2 board - EP4CE115F29C 
 
  
 --Frequency Divider is designed to provide variable clock input to sine/sawtooth generator and triangle generator based on the magnitude selector  
 --Frequency Divider is clock-triggered to ensure that its outptut is synchronous to changes in magnitude selector. 
  
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
 
entity Frequency_Divider is  
port ( 
    magnitude_selector: in std_logic; 
    desired_frequency: in integer range 0 to 255; 
    clkin: in std_logic; 
    frequency_out1, frequency_out2 : out std_logic);     
end Frequency_Divider; 
 
architecture divider of Frequency_Divider is 
begin 
    process (clkin, magnitude_selector ) 
        variable count : integer:=  0; 
        variable divide_ratio : integer; 
  variable temprorary : std_logic; 
     
    begin     
 
 
        if rising_edge(clkin)then   
 
-- This if statement is used to select if the divider divides the frequency to Hz or KHz 
if magnitude_selector = '0' then     	 --Hz       
divide_ratio := 200000/(desired_frequency+1); 
             
elsif magnitude_selector = '1' then 	--KHz			 
          			 divide_ratio := 200/(desired_frequency+1); 
     		 end if; 
 
            count := count + 1; -- counter  
            if count < divide_ratio/2 then  	–this if statement is used to set the logic low of the clock 
               temprorary := '0'; 
            elsif count < divide_ratio then  	--this if statement is used to set the logic high of the clock            
                temprorary := '1';                
            else count := 0; 
            end if;    
frequency_out1 <= temprorary; 	 
         			frequency_out2 <= temprorary;				 
        end if; 
   
  
end process; 
end divider; 

---------------------------------------------

- VHDL implementation of a  
-- MULTIPLEXER 
 
--Date:                13/05/19 
--Version No:        2 
--Target            DE2 board - EP4CE115F29C7 
 
--This component uses concatenation method to make the multiplexer synchronous with changes in on/off input and  wave selector input 
 
 
library ieee;  -- Libraries 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
 
entity multiplexer is port( 
        sq_in, tri_in, saw_in, sine_in: in integer range 0 to 255; 
        wave_select: in std_logic_vector (1 downto 0); 
        onoff_input, clk_in: in std_logic; 
        output: out integer range 0 to 255); 
end multiplexer; 
 
architecture module of multiplexer is 
    begin 
       process (clk_in, onoff_input, wave_select) 
       variable temp: std_logic_vector (2 downto 0); 
        begin 
            temp:= onoff_input & wave_select; -- concatenates the on/off with wave select function 
            
    if rising_edge (clk_in) then   -- this manages which wave output is sent to the DAC 
            if temp="100" then output<= sq_in; 
            elsif temp="101" then output<=tri_in; 
            elsif temp="110" then output<= saw_in; 
            elsif temp="111" then output<= sine_in; 
            else output<= 0; 
            end if; 
 
    end if;  
 
end process; 
end module; 

---------------------------------------------

-- VHDL implementation of a  
-- SPLITTER 
 
--Date:                08/05/19 
--Version No:        1 
--Target            DE2 board - EP4CE115F29C7 
 
--This component uses concatenation method to make multiple copies of input variables: desired frequency, magnitude selector, wave selector,  on/off input and clock  
--When on/off input is logic '0', it outputs a high-impedance tristate value for desired frequency, magnitude selector and wave selector. 
 
 
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
 
entity splitter is  
port( 
        desired_frequency : in std_logic_vector (7 downto 0); 
        magnitude_selector: in std_logic; 
        wave_select : in std_logic_vector (1 downto 0); 
        onoff_input: in std_logic; 
        clock_in: in std_logic; 
         
        desired_frequency1, desired_frequency2, desired_frequency3 : out integer range 0 to 255; 
        magnitude_selector_out1, magnitude_selector_out2: out std_logic; 
        wave_select_out1,     wave_select_out2: out std_logic_vector (1 downto 0); 
        onoff_out1, onoff_out2, onoff_out3: out std_logic; 
        clock_out1, clock_out2, clock_out3, clock_out4: out std_logic); 
         
end splitter; 
 
 
architecture module of splitter is  
begin  
 
     process (onoff_input, clock_in, wave_select, desired_frequency, magnitude_selector) 
      
        variable temp, temp1 : std_logic_vector (12 downto 0); 
        variable tempa: std_logic_vector (1 downto 0);  
        variable tempb: std_logic_vector (7 downto 0);  
 
        begin  
        temp:= onoff_input & clock_in & wave_select & desired_frequency & magnitude_selector; 
         
        if onoff_input ='1' then temp1:= temp; 
        elsif onoff_input='0' then temp1:= "00ZZZZZZZZZZZ";     
        end if; 
     
    tempa := temp1(10)&temp1(9); 
    tempb := temp1(8)& temp1(7)& temp1(6)& temp1(5)& temp1(4)& temp1(3)& temp1(2)& temp1(1);  
     
    magnitude_selector_out1 <= temp1(0); 
    magnitude_selector_out2 <= temp1(0); 
     
     
    desired_frequency1 <= to_integer(unsigned(tempb)); 
    desired_frequency2 <= to_integer(unsigned(tempb)); 
    desired_frequency3 <= to_integer(unsigned(tempb)); 
     
     
    wave_select_out1 <= tempa; 
    wave_select_out2 <= tempa; 
     
    clock_out1<= temp1(11); 
    clock_out2<= temp1(11); 
    clock_out3<= temp1(11); 
    clock_out4<= temp1(11); 
     
    onoff_out1<= temp1(12); 
    onoff_out2<= temp1(12); 
    onoff_out3<= temp1(12); 
     
    end process;     
     
end module; 

---------------------------------------------

-- VHDL implementation of a  
-- 8-bit 5 x 7-seg Display controller 

--Date:             08/05/19 
--Version No:       3 
--Target            DE2 board - EP4CE115F29C7 
 
 
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
 
entity Display_7seg  is port( 
    freq_input : in integer range 0 to 255; 
    selector_input : in std_logic_vector(1 downto 0); 
    onoff_input: in std_logic; 
    Display1,Display2,Display3,Display4,Display5 : out std_logic_vector (6 downto 0)); 
end Display_7seg ; 
     
architecture module of Display_7seg  is 
        component Divider 
            port (switches : in integer range 0 to 255; 
                    onoff_input : in std_logic; 
                    Display_out1,Display_out2,Display_out3 : out integer range 0 to 10); 
        end component;         
         
        component Encoder 
            Port (input : in integer range 0 to 10; 
                    output: out std_logic_vector (6 downto 0)); 
        end component; 
         
        component wave_selector is Port ( 
        input : in std_logic_vector(1 downto 0); 
        onoff_input:in std_logic; 
        out1,out2 : out std_logic_vector (6 downto 0)); 
        end component; 
 
signal sig1,sig2,sig3: integer range 0 to 127; 
 
begin 
        instance1:Divider port map(switches=>freq_input, onoff_input=> onoff_input, Display_out1=>sig1,Display_out2=>sig2,Display_out3=>sig3); 
        instance2:Encoder port map(input=>sig1, output=>Display1); 
        instance3:Encoder port map(input=>sig2, output=>Display2); 
        instance4:Encoder port map(input=>sig3, output=>Display3); 
        instance5:wave_selector port map(input=>selector_input, onoff_input=> onoff_input, out1=>Display4,out2=>Display5); 
         
end module;

-------------------------------------------------------------- 
 
 
-- VHDL implementation of a  
--Waveform selector  
 
--Date:				29 April 2019 
--Version No:		1 
--Target			DE2 board - EP4CE115F29C7 
 
 
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
 
entity wave_selector is Port ( 
        input : in std_logic_vector(1 downto 0); 
        onoff_input: in std_logic; 
        out1,out2 : out std_logic_vector (6 downto 0)); 
end wave_selector; 
 
 
architecture logic of wave_selector is  
begin 
process(input,onoff_input) 
begin 
 
if   onoff_input = '0' then 
 
out1 <= "1111111";--off 
out2 <= "1111111";--off 
 
else 
 
 
Case input is  
when "00" => out1 <= "0001100"	; --q 
when "01" => out1 <= "1111010"	; --r 
when "11" => out1 <= "1001111"	; --i 
when "10" => out1 <= "0001000"	; --a 
when others => out1 <= "1111111"	;--off 
end case; 
 
Case input is  
when "00" => out2 <= "0100100"	; --s 
when "01" => out2 <= "1110000"	; --t 
when "11" => out2 <= "0100100"	; --s 
when "10" => out2 <= "0100100"	; --s 
when others => out2 <= "1111111"	;--off 
end case; 
 
end if; 
end process; 
end logic; 
                    
 
 
----------------------------------------------------------- 
 
-- VHDL implementation of a  
--Encoder  

--Date:				29 April 2019 
--Version No:		1 
--Target			DE2 board - EP4CE115F29C7 
 
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
 
entity Encoder is Port ( 
        input : in integer range 0 to 10; 
        output: out std_logic_vector (6 downto 0)); 
end Encoder; 
 
architecture logic of Encoder is  
 
begin  
 
Process(input) 
 
begin 
 
        Case input is  
        when 0 => Output <= "0000001"    ; --0 
        when 1 => Output <= "1001111"    ; --1 
        when 2 => Output <= "0010010"    ; --2 
        when 3 => Output <= "0000110"    ; --3 
        when 4 => Output <= "1001100"    ; --4 
        when 5 => Output <= "0100100"    ; --5 
        when 6 => Output <= "0100000"    ; --6 
        when 7 => Output <= "0001111"    ; --7 
        when 8 => Output <= "0000000"    ; --8 
        when 9 => Output <= "0000100"    ; --9 
        when others => Output <= "1111111"    ;--off 
        end case; 
         
end process; 
         
     
end logic; 
 
-------------------------------------------------------------- 
 
-- VHDL implementation of a  
-- Decoder  
 
--Date:				29 April 2019 
--Version No:		1 
--Target			DE2 board - EP4CE115F29C7 
 
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
 
entity Divider is port ( 
 
        switches : in integer range 0 to 255; 
        onoff_input : in std_logic; 
        Display_out1,Display_out2,Display_out3 : out integer range 0 to 10); 
         
end Divider; 
             
architecture logic of Divider is 
 
begin 
    process(switches, onoff_input ) 
     
    variable b1 : integer range 0 to 25; 
 
    begin 
    if onoff_input ='1' then  
                 
        b1 := (switches+1) / 10;			 
        Display_out1 <= (switches+1) rem 10; --this logic provides the most significant number of freq. 
        Display_out3 <= b1/10; -- this formula provides least significant number of the frequency 
        Display_out2 <= b1 rem 10;    --this formula provides the middle number of the frequency 
    else  
--this part of the if statement makes all displays turn off if the onoff input goes low 
        Display_out1 <= 10; 
        Display_out3 <= 10; 
        Display_out2 <= 10; 
    end if; 
    end process; 
     
end logic; 

----------------------------------------

-- VHDL implementation of a  
-- Sine and Sawtooth wave 
 
--Date:             08/05/19 
--Version No:       2 
--Target            DE2 board - EP4CE115F29C7 
 
library ieee;  -- libraries 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use work.sine_package.all;  -- This program utilises packages to keep the code short 
 
entity SineWaveCode_test is 
  port( clkin: in std_logic; -- The clock input at the desired frequency managed by the clock divider 
  saw_out: out integer range 0 to 255; 
  sine_out: out integer range 0 to 255); 
end; 
 
architecture arch1 of SineWaveCode_test is 
  signal table_address: integer range 0 to 249; 
 
 
begin 
  process( clkin, table_address ) 
  	 
  begin 
   
    if rising_edge( clkin ) then  
sine_out <= get_table_number( table_address );  -- looks at the sine_package table 
saw_out <= table_address;  -- utilises the already implemented counter for sawtooth 
table_address <= table_address +1; 
 end if; 
 if table_address = 249 then  -- makes the counter loop 
         table_address <= table_address -249; 
end if; 
  end process; 
 
  end; 
  
  ---------------------------------------
  
  -- VHDL implementation of a  
-- SQUAREWAVE WAVEFORM GENERATOR 
 
--Date:             08/05/19 
--Version No:       2 
--Target            DE2 board - EP4CE115F29C7 
 
--Propagation delay at higher frequency range (exceeding 50kHz) becomes too large for a clean square wave output 
 
 
library ieee;  -- Libraries 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
 
entity SquareGenerator  is  -- Defines inputs and outputs 
    port ( 
    clkin: in std_logic; 
    magnitude_selector: in std_logic; 
    desired_frequency: in integer range 0 to 255; 
    sq_out: out integer range 0 to 255); 
end SquareGenerator ; 
 
architecture module of SquareGenerator  is 
begin 
    process (clkin, magnitude_selector) 
     
        variable divide_ratio : integer range 0 to 50000000; 
        variable count : integer range 0 to 50000000; 
         
    begin   
 
       if rising_edge(clkin)then     
  		   
  if magnitude_selector = '0' then  -- allows Hz / KHz selectivity 
 divide_ratio := 50000000/(desired_frequency+1);  -- the plus 1 allows for a range of 1 to 256 KHz 
  else         
divide_ratio := 50000/(desired_frequency+1); 
  end if; 
   
            count := count + 1; 
 
if count < divide_ratio/2 then 
 sq_out <= 0; 
elsif count < divide_ratio then     
 sq_out <= 255; -- this is 255 so that the DAC outputs the full 3.3V 
else count := 0; 
 
end if;         
      end if; 
end process; 
end; 

------------------------------------

-- VHDL implementation of a  
-- triangle wave 
 
--Date:             08/05/19 
--Version No:       2 
--Target            DE2 board - EP4CE115F29C7 
 
library ieee;  -- libraries 
use ieee.std_logic_1164.all; 
 
entity TriangleWaveCode is 
  port( 
clkin:in std_logic;  -- pre-divided clock input by the divider 
tri_out:out integer range 0 to 250); 
end TriangleWaveCode; 
 
architecture TriangleWaveCode_test_arch of TriangleWaveCode is 
begin 
process(clkin) 
 
      variable count:integer := 0; 
 
  begin 
 
    if rising_edge(clkin)then 
  
count := count + 2;  -- counter that adds 2 to reach 250 cycles for one wave 
 
if count < 251 then 
tri_out <= count;  -- up slant 
else 
tri_out <= (500 - count);  -- down slant 
end if; 
 
if count = 500 then  -- reset loop 
count := 0; 
end if; 
 
 end if; 
  
  end process;   
end; 


--------------------------Top-level Entity ------------------------- 
--VHDL implementation of a  
--Simple function generator  
--Of a sine, square and triangular wave 
--within a frequency range 1kHz to 255 kHz and 1Hz to 255 Hz 

--Date:            13/05/2019 
--Version No:      3 
--Target           DE2 board - EP4CE115F29C 
 
  
--Beyond 50kHz this program is not capable of displaying sine, triangle or sawtooth wave 
--This is because of a large number of sample points and a bigger clock is required 
--The sqaure wave, however, works beyond 50kHZ as it only requires two sample points 
 
 
-------------------Top-level entity-------------------------------- 
 
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;   
  
entity VHDL_Assignment is port( 
        desired_freq: in std_logic_vector(7 downto 0); 
        wave_selector: in std_logic_vector(1 downto 0); 
        on_off, clk_in_50MHz, magnitude_selector: in std_logic; 
        output_7seg1, output_7seg2, output_7seg3, output_7sega, output_7segb :out std_logic_vector(6 downto 0); 
        output_DAC: out integer range 0 to 255); 
end VHDL_Assignment; 
 
architecture gates of VHDL_Assignment is 
 
-----------------Component declaration------------------------------ 
 
--Splitter is required generate multiple versions of clock, desired frequency, on/off input and magnitude selector. This is later important for instantiation. 
    component Splitter  
    port( 
            desired_frequency : in std_logic_vector (7 downto 0); 
            magnitude_selector: in std_logic; 
            wave_select : in std_logic_vector (1 downto 0); 
            onoff_input: in std_logic; 
            clock_in: in std_logic;         
            desired_frequency1, desired_frequency2, desired_frequency3 : out integer range 0 to 255; 
            magnitude_selector_out1, magnitude_selector_out2: out std_logic; 
            wave_select_out1, wave_select_out2: out std_logic_vector (1 downto 0); 
            onoff_out1, onoff_out2: out std_logic; 
            clock_out1, clock_out2, clock_out3: out std_logic); 
    end component; 
  
 --Multiplexer choses between four waves: sine, square, traingle and square. 
    component multiplexer 
     port( 
            sq_in, tri_in, saw_in, sine_in: in integer range 0 to 255; 
            wave_select: in std_logic_vector (1 downto 0); 
            onoff_input, clk_in: in std_logic;  
            output: out integer range 0 to 255); 
    end component; 
 
--Sine and Sawtooth Generator uses the same lookup table, more explanation in the component. 
 
    component Sine_Sawtooth_Generator 
      port(  
             clkin: in std_logic; 
             saw_out: out integer range 0 to 255; 
             sine_out: out integer range 0 to 255); 
    end component ; 
 
--Triangle wave generator  
    component TriangleGenerator   
    port( 
            clkin:in std_logic; 
            tri_out:out integer range 0 to 250); 
    end component; 
 
--Square wave generation for kHz and Hz range based on the magnitude selector. 
    component SquareGenerator   
    port ( 
            clkin: in std_logic; 
            magnitude_selector: in std_logic; 
            desired_frequency: in integer range 0 to 255; 
            sq_out: out integer range 0 to 255); 
    end component; 
 
--Component to display frequency and wave type selected through the switch inputs 
    component Display_7seg  
    port( 
            freq_input : in integer range 0 to 255; 
            selector_input : in std_logic_vector(1 downto 0); 
            onoff_input : in std_logic; 
            Display1,Display2,Display3,Display4,Display5 : out std_logic_vector (6 downto 0)); 
    end component; 
     
--Clock divider  based on the magnitude selector for clock in Hz and kHz range  
 component Frequency_Divider   
    port ( 
        magnitude_selector: in std_logic; 
        desired_frequency: in integer range 0 to 255; 
        clkin: in std_logic; 
        frequency_out1, frequency_out2 : out std_logic);     
    end component; 
 
 
--------Defining signals -------------------------------------------------- 
    signal Magnitude_Selector1, Magnitude_Selector2:std_logic; 
    signal Wave_selector1, Wave_selector2: std_logic_vector (1 downto 0); 
    signal on_off1, on_off2, on_off3: std_logic; 
    Signal desired_freq1, desired_freq2,desired_freq3: integer range 0 to 255; 
    signal clk_in_50Mhz1, clk_in_50Mhz2, clk_in_50Mhz3 : std_logic;  
    signal Clk_in_divided1, Clk_in_divided2: std_logic;  
    signal sine_int, saw_int, tri_int, sq_int: integer range 0 to 255; 
     
 
begin 
 
-------Instantiation of individual components------------------------------ 
 
    instance1: Splitter port map (clock_out3 => clk_in_50Mhz3, desired_frequency => desired_freq ,magnitude_selector => magnitude_selector , wave_select => wave_selector , onoff_input=>on_off, clock_in =>clk_in_50MHz ,desired_frequency1 => desired_freq1, desired_frequency2 => desired_freq2 , desired_frequency3=> desired_freq3,     magnitude_selector_out1 => Magnitude_Selector1 ,magnitude_selector_out2 =>Magnitude_Selector2 , wave_select_out1 => Wave_selector1, wave_select_out2 => Wave_selector2, onoff_out1 => on_off1, onoff_out2 => on_off2,clock_out1=> clk_in_50Mhz1, clock_out2=>clk_in_50Mhz2); 
 
    instance2: Frequency_Divider port map(magnitude_selector => Magnitude_Selector1,  desired_frequency =>desired_freq1, clkin => clk_in_50Mhz1 ,frequency_out1 => Clk_in_divided1 , frequency_out2 => Clk_in_divided2); 
 
    instance3: Sine_Sawtooth_Generator port map (clkin => Clk_in_divided1  , saw_out => saw_int , sine_out=> sine_int); 
 
    instance4: TriangleGenerator port map (clkin => Clk_in_divided2, tri_out => tri_int); 
 
    instance5: SquareGenerator  port map (clkin => clk_in_50Mhz2 , magnitude_selector => Magnitude_Selector2 , desired_frequency => desired_freq2, sq_out => sq_int ); 
 
    instance6: multiplexer port map (clk_in => clk_in_50Mhz3, sq_in => sq_int, tri_in =>tri_int, saw_in=> saw_int, sine_in=> sine_int, wave_select=> Wave_selector1, onoff_input=> on_off1, output=> output_DAC); 
 
    instance7: Display_7seg  port map (freq_input => desired_freq3, selector_input =>  Wave_selector2  , onoff_input=> on_off2, Display1 =>output_7seg1, Display2 => output_7seg2, Display3 =>output_7seg3 ,Display4 => output_7sega, Display5=>output_7segb); 
 
end gates; 

--------------------------------

--This section is simply a package for the main sinewave code above to utilise 

library ieee;  -- Libraries 
use ieee.std_logic_1164.all; 
 
package sine_package is 
 
  function get_table_number (table_address: integer range 0 to 249) return integer; 
--This creates table list a function that when referred to will output the corresponding sine value 
end; 
 
package body sine_package is 
 
  function get_table_number (table_address: integer range 0 to 249) return integer is 
    variable table_number: integer range 0 to 255;  -- table number stores the actual sine value 
  begin 
    case table_address is  -- a case containing all the callable states 
 
 
 	when 0 => 
        table_number := 128; 
      when 1 => 
        table_number := 131; 
      when 2 => 
        table_number := 134; 
      when 3 => 
        table_number := 137; 
      when 4 => 
        table_number := 140; 
      when 5 => 
        table_number := 143; 
      when 6 => 
        table_number := 146; 
      when 7 => 
        table_number := 149; 
      when 8 => 
        table_number := 152; 
      when 9 => 
        table_number := 156; 
      when 10 => 
        table_number := 159; 
      when 11 => 
        table_number := 162; 
      when 12 => 
        table_number := 165; 
      when 13 => 
        table_number := 168; 
      when 14 => 
        table_number := 171; 
      when 15 => 
        table_number := 174; 
      when 16 => 
        table_number := 176; 
      when 17 => 
        table_number := 179; 
      when 18 => 
        table_number := 182; 
      when 19 => 
        table_number := 185; 
      when 20 => 
        table_number := 188; 
      when 21 => 
        table_number := 191; 
      when 22 => 
        table_number := 193; 
      when 23 => 
        table_number := 196; 
      when 24 => 
        table_number := 199; 
      when 25 => 
        table_number := 201; 
      when 26 => 
        table_number := 204; 
      when 27 => 
        table_number := 206; 
      when 28 => 
        table_number := 209; 
      when 29 => 
        table_number := 211; 
      when 30 => 
        table_number := 213; 
      when 31 => 
        table_number := 216; 
      when 32 => 
        table_number := 218; 
      when 33 => 
        table_number := 220; 
      when 34 => 
        table_number := 222; 
      when 35 => 
        table_number := 224; 
      when 36 => 
        table_number := 226; 
      when 37 => 
        table_number := 228; 
      when 38 => 
        table_number := 230; 
      when 39 => 
        table_number := 232; 
      when 40 => 
        table_number := 234; 
      when 41 => 
        table_number := 235; 
      when 42 => 
        table_number := 237; 
      when 43 => 
        table_number := 239; 
      when 44 => 
        table_number := 240; 
      when 45 => 
        table_number := 242; 
      when 46 => 
        table_number := 243; 
      when 47 => 
        table_number := 244; 
      when 48 => 
        table_number := 246; 
      when 49 => 
        table_number := 247; 
      when 50 => 
        table_number := 248; 
      when 51 => 
        table_number := 249; 
      when 52 => 
        table_number := 250; 
      when 53 => 
        table_number := 251; 
      when 54 => 
        table_number := 251; 
      when 55 => 
        table_number := 252; 
      when 56 => 
        table_number := 253; 
      when 57 => 
        table_number := 253; 
      when 58 => 
        table_number := 254; 
      when 59 => 
        table_number := 254; 
      when 60 => 
        table_number := 254; 
      when 61 => 
        table_number := 255; 
      when 62 => 
        table_number := 255; 
      when 63 => 
        table_number := 255; 
      when 64 => 
        table_number := 255; 
      when 65 => 
        table_number := 255; 
      when 66 => 
        table_number := 255; 
      when 67 => 
        table_number := 255; 
      when 68 => 
        table_number := 254; 
      when 69 => 
        table_number := 254; 
      when 70 => 
        table_number := 253; 
      when 71 => 
        table_number := 253; 
      when 72 => 
        table_number := 252; 
      when 73 => 
        table_number := 252; 
      when 74 => 
        table_number := 251; 
      when 75 => 
        table_number := 250; 
      when 76 => 
        table_number := 249; 
      when 77 => 
        table_number := 248; 
      when 78 => 
        table_number := 247; 
      when 79 => 
        table_number := 246; 
      when 80 => 
        table_number := 245; 
      when 81 => 
        table_number := 244; 
      when 82 => 
        table_number := 242; 
      when 83 => 
        table_number := 241; 
      when 84 => 
        table_number := 239; 
      when 85 => 
        table_number := 238; 
      when 86 => 
        table_number := 236; 
      when 87 => 
        table_number := 235; 
      when 88 => 
        table_number := 233; 
      when 89 => 
        table_number := 231; 
      when 90 => 
        table_number := 229; 
      when 91 => 
        table_number := 227; 
      when 92 => 
        table_number := 225; 
      when 93 => 
        table_number := 223; 
      when 94 => 
        table_number := 221; 
      when 95 => 
        table_number := 219; 
      when 96 => 
        table_number := 217; 
      when 97 => 
        table_number := 215; 
      when 98 => 
        table_number := 212; 
      when 99 => 
        table_number := 210; 
      when 100 => 
        table_number := 207; 
      when 101 => 
        table_number := 205; 
      when 102 => 
        table_number := 202; 
      when 103 => 
        table_number := 200; 
      when 104 => 
        table_number := 197; 
      when 105 => 
        table_number := 195; 
      when 106 => 
        table_number := 192; 
      when 107 => 
        table_number := 189; 
      when 108 => 
        table_number := 186; 
      when 109 => 
        table_number := 184; 
      when 110 => 
        table_number := 181; 
      when 111 => 
        table_number := 178; 
      when 112 => 
        table_number := 175; 
      when 113 => 
        table_number := 172; 
      when 114 => 
        table_number := 169; 
      when 115 => 
        table_number := 166; 
      when 116 => 
        table_number := 163; 
      when 117 => 
        table_number := 160; 
      when 118 => 
        table_number := 157; 
      when 119 => 
        table_number := 154; 
      when 120 => 
        table_number := 151; 
      when 121 => 
        table_number := 148; 
      when 122 => 
        table_number := 145; 
      when 123 => 
        table_number := 142; 
      when 124 => 
        table_number := 138; 
      when 125 => 
        table_number := 135; 
      when 126 => 
        table_number := 132; 
      when 127 => 
        table_number := 129; 
      when 128 => 
        table_number := 126; 
      when 129 => 
        table_number := 123; 
      when 130 => 
        table_number := 120; 
      when 131 => 
        table_number := 117; 
      when 132 => 
        table_number := 113; 
      when 133 => 
        table_number := 110; 
      when 134 => 
        table_number := 107; 
      when 135 => 
        table_number := 104; 
      when 136 => 
        table_number := 101; 
      when 137 => 
        table_number := 98; 
      when 138 => 
        table_number := 95; 
      when 139 => 
        table_number := 92; 
      when 140 => 
        table_number := 89; 
      when 141 => 
        table_number := 86; 
      when 142 => 
        table_number := 83; 
      when 143 => 
        table_number := 80; 
      when 144 => 
        table_number := 77; 
      when 145 => 
        table_number := 74; 
      when 146 => 
        table_number := 71; 
      when 147 => 
        table_number := 69; 
      when 148 => 
        table_number := 66; 
      when 149 => 
        table_number := 63; 
      when 150 => 
        table_number := 60; 
      when 151 => 
        table_number := 58; 
      when 152 => 
        table_number := 55; 
      when 153 => 
        table_number := 53; 
      when 154 => 
        table_number := 50; 
      when 155 => 
        table_number := 48; 
      when 156 => 
        table_number := 45; 
      when 157 => 
        table_number := 43; 
      when 158 => 
        table_number := 40; 
      when 159 => 
        table_number := 38; 
      when 160 => 
        table_number := 36; 
      when 161 => 
        table_number := 34; 
      when 162 => 
       table_number := 32; 
      when 163 => 
        table_number := 30; 
      when 164 => 
        table_number := 28; 
      when 165 => 
        table_number := 26; 
      when 166 => 
        table_number := 24; 
      when 167 => 
        table_number := 22; 
      when 168 => 
        table_number := 20; 
      when 169 => 
        table_number := 19; 
      when 170 => 
        table_number := 17; 
      when 171 => 
        table_number := 16; 
      when 172 => 
        table_number := 14; 
      when 173 => 
        table_number := 13; 
      when 174 => 
        table_number := 11; 
      when 175 => 
        table_number := 10; 
      when 176 => 
        table_number := 9; 
      when 177 => 
        table_number := 8; 
      when 178 => 
        table_number := 7; 
      when 179 => 
        table_number := 6; 
      when 180 => 
        table_number := 5; 
      when 181 => 
        table_number := 4; 
      when 182 => 
        table_number := 3; 
      when 183 => 
        table_number := 3; 
      when 184 => 
        table_number := 2; 
      when 185 => 
        table_number := 2; 
      when 186 => 
        table_number := 1; 
      when 187 => 
        table_number := 1; 
      when 188 => 
        table_number := 0; 
      when 189 => 
        table_number := 0; 
      when 190 => 
        table_number := 0; 
      when 191 => 
        table_number := 0; 
      when 192 => 
        table_number := 0; 
      when 193 => 
        table_number := 0; 
      when 194 => 
        table_number := 0; 
      when 195 => 
        table_number := 1; 
      when 196 => 
        table_number := 1; 
      when 197 => 
        table_number := 2; 
      when 198 => 
        table_number := 3; 
      when 199 => 
        table_number := 4; 
      when 200 => 
        table_number := 5; 
      when 201 => 
        table_number := 6; 
      when 202 => 
        table_number := 7; 
      when 203 => 
        table_number := 8; 
      when 204 => 
        table_number := 10; 
      when 205 => 
        table_number := 11; 
      when 206 => 
        table_number := 13; 
      when 207 => 
        table_number := 15; 
      when 208 => 
        table_number := 17; 
      when 209 => 
        table_number := 19; 
      when 210 => 
        table_number := 21; 
      when 211 => 
        table_number := 23; 
      when 212 => 
        table_number := 25; 
      when 213 => 
        table_number := 27; 
      when 214 => 
        table_number := 29; 
      when 215 => 
        table_number := 31; 
      when 216 => 
        table_number := 33; 
      when 217 => 
        table_number := 36; 
      when 218 => 
        table_number := 38; 
      when 219 => 
        table_number := 40; 
      when 220 => 
        table_number := 43; 
      when 221 => 
        table_number := 45; 
      when 222 => 
        table_number := 47; 
      when 223 => 
        table_number := 50; 
      when 224 => 
        table_number := 53; 
      when 225 => 
        table_number := 55; 
      when 226 => 
        table_number := 58; 
      when 227 => 
        table_number := 61; 
      when 228 => 
        table_number := 63; 
      when 229 => 
        table_number := 66; 
      when 230 => 
        table_number := 69; 
      when 231 => 
        table_number := 72; 
      when 232 => 
        table_number := 75; 
      when 233 => 
        table_number := 78; 
      when 234 => 
        table_number := 81; 
      when 235 => 
        table_number := 84; 
      when 236 => 
        table_number := 87; 
      when 237 => 
        table_number := 90; 
      when 238 => 
        table_number := 93; 
      when 239 => 
        table_number := 96; 
      when 240 => 
        table_number := 99; 
      when 241 => 
        table_number := 102; 
      when 242 => 
        table_number := 105; 
      when 243 => 
        table_number := 108; 
      when 244 => 
        table_number := 112; 
      when 245 => 
        table_number := 115; 
      when 246 => 
        table_number := 118; 
      when 247 => 
        table_number := 121; 
      when 248 => 
        table_number := 124; 
      when 249 => 
        table_number := 126; 
    end case; 
    return table_number; 
  end; 
 
end; 
