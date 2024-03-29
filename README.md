# FPGA_Waveform_Generator

Code to generate a Sine wave, Triangle wave, Square wave and Sinusoidal wave with Cyclone IV E DE2-115 board. I use the Digital to Analogue (DAC) component of the FAB board. Waves were generated at frequency between 1 kHz and 256 kHz.

Further scope of the project are described below:  
All waves are generated in the DC voltage range of 0 to 3.2V. 
Instead of switches to provide desired frequency input, keypads present in the FAB were used. 
One of the reasons why propagation delay was significant at high frequency was because of the use of FAB. A better quality, high precision FAB can be used to obtain cleaner waves. Usage of faster clock can decrease propagation delay. 
Other variables that can be incorporated in this design are:  
1. DC offset 
2. Converting DC output of FAB to AC signal  
3. Duty cycle 

Shoutout to Ben Style, Bruno Sousa and Natalie Kerr for their contributions in the project!
