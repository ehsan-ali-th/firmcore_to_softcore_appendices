

Appendix D
Authors: - Ehsan Ali:		ehssan.aali@gmail.com
	 - Wanchalerm Pora	wanchalerm.p@chula.ac.th
Last modfied: 30-July-2019

-------------------------------------------------------------------------------

Folder content:

- hex2vhd_lattice.cpp : C++ program that converts picoblaze .hex file to .vhd file supported by Lattice Ice40 devices. It is used to synthesize Zipi8 on Lattice devices.
- pBlaze_prog.hex : Sample .hex file
- pBlaze_prog.vhd : Sample .vhd file (output ff program)

Zipi8 is a PicoBlaze compatible soft-core processors developed in Electrical Engineering Department of Chulalongkorn University of Thailand. 

Under linux compile:

$ g++ -o hex2vhd hex2vhd_lattice.cpp

Then run:

$ /hex2vhd pBlaze_prog.hex

The pBlaze_prog.vhd will be outputed. Add this .vhd file to your Zipi8 project which will instantiate Zipi 8 program memory block. 

