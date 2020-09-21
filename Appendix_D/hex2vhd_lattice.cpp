// hex2vhd_lattice.cpp : Defines the entry point for the console application.
//
// This program converts picoblaze .hex  file to .vhd file supported by Lattice Ice40 devices

//
// If on Windows: 
//#include "stdafx.h"

#include <iostream>
#include <fstream>
#include <string>
//#include <conio.h>
#include <cassert>

using namespace std;

ofstream file_out;
void write_out_header (void);
void write_out_footer (void);
char print_char (char *p);
char print_row (unsigned int *i);
void print_block_ram (unsigned int inst_no, char init_array[][64]);

int main(int argc, char *argv[])
{
	if (argc < 2) {
		cout << "ops, Specify a filename as the first argument" << endl;
		return -1;
	}

	string input_filename = argv[1];

	cout << "Input File: " << input_filename << endl;

	// Extract the filename by removing the extension
	size_t lastindex = input_filename.find_last_of(".");
	if (lastindex == string::npos) {
		cout << "No extension in filename is specified. " <<
			"Input filename must have .hex extension" << endl;
		return -2;
  	}

	string rawname = input_filename.substr(0, lastindex);
	string output_filename = rawname + ".vhd";

	cout << "Converting " << input_filename << " to " << output_filename << " file" << endl;

	ifstream file_in(input_filename.c_str(), ios::in);
	file_out.open(output_filename.c_str(), ios::out);
	cout << "output file opened." << endl;
	// stringstream tmp_stream(ios_base::in | ios_base::out);


	write_out_header();
	cout << "Header printed." << endl;
	
	unsigned int c = 0; // tracks the line number
	string l;
	string line_0;
	string line_1;

	char ints0_INIT[32][64]; 		//Holds the INIT_A to INIT_F values for RAM block instance 0		16*64*4 = 4096 bit
	char ints1_INIT[32][64]; 		//Holds the INIT_A to INIT_F values for RAM block instance 1
	char ints2_INIT[32][64]; 		//Holds the INIT_A to INIT_F values for RAM block instance 2
	char ints3_INIT[32][64]; 		//Holds the INIT_A to INIT_F values for RAM block instance 3
	char ints4_INIT[32][64]; 		//Holds the INIT_A to INIT_F values for RAM block instance 4
	char ints5_INIT[32][64]; 		//Holds the INIT_A to INIT_F values for RAM block instance 5
	char ints6_INIT[32][64]; 		//Holds the INIT_A to INIT_F values for RAM block instance 6
	char ints7_INIT[32][64]; 		//Holds the INIT_A to INIT_F values for RAM block instance 7
	char ints8_INIT[32][64]; 		//Holds the INIT_A to INIT_F values for RAM block instance 8

	unsigned int m = 0;
	unsigned int n = 0;

	// iterate through the lines
	// each line reads 5 charactcer: ABCDE, A is MSB abd E is LSB, 
	while (getline(file_in, l)) {
		// Read the first line
		if (l.size() && l[l.size() - 1] == '\r') {
			line_0 = l.substr(0, l.size() - 1);
		}
		else {
			line_0 = l;
		}

		// Read the second line
		getline(file_in, l);
		if (l.size() && l[l.size() - 1] == '\r') {
			line_1 = l.substr(0, l.size() - 1);
		}
		else {
			line_1 = l;
		}
		

		char line_0_byte4 = line_0[0];
		char line_0_byte3 = line_0[1];
		char line_0_byte2 = line_0[2];
		char line_0_byte1 = line_0[3];
		char line_0_byte0 = line_0[4];

		char line_1_byte4 = line_1[0];
		char line_1_byte3 = line_1[1];
		char line_1_byte2 = line_1[2];
		char line_1_byte1 = line_1[3];
		char line_1_byte0 = line_1[4];

		char A_line_0 = line_0_byte0 & 0x03;		// select the first two bits
		char B_line_0 = line_1_byte0 & 0x03;		// select the first two bits
		char F0 = A_line_0 | (B_line_0 << 2);		// Combine A and B to form a 4-bit

		char A_line_1 = line_0_byte0 & 0x0C;		// select the second two bits
		char B_line_1 = line_1_byte0 & 0x0C;		// select the second two bits
		A_line_1 = A_line_1 >> 2;
		B_line_1 = B_line_1 >> 2;
		char F1 = A_line_1 | (B_line_1 << 2);		// Combine A and B to form a 4-bit

		char A_line_2 = line_0_byte1 & 0x03;
		char B_line_2 = line_1_byte1 & 0x03;
		char F2 = A_line_2 | (B_line_2 << 2);

		char A_line_3 = line_0_byte1 & 0x0C;
		char B_line_3 = line_1_byte1 & 0x0C;
		A_line_1 = A_line_1 >> 2;
		B_line_1 = B_line_1 >> 2;
		char F3 = A_line_3 | (B_line_3 << 2);

		char A_line_4 = line_0_byte2 & 0x03;
		char B_line_4 = line_1_byte2 & 0x03;
		char F4 = A_line_4 | (B_line_4 << 2);

		char A_line_5 = line_0_byte2 & 0x0C;
		char B_line_5 = line_1_byte2 & 0x0C;
		A_line_1 = A_line_1 >> 2;
		B_line_1 = B_line_1 >> 2;
		char F5 = A_line_5 | (B_line_5 << 2);

		char A_line_6 = line_0_byte3 & 0x03;
		char B_line_6 = line_1_byte3 & 0x03;
		char F6 = A_line_6 | (B_line_6 << 2);

		char A_line_7 = line_0_byte3 & 0x0C;
		char B_line_7 = line_1_byte3 & 0x0C;
		A_line_1 = A_line_1 >> 2;
		B_line_1 = B_line_1 >> 2;
		char F7 = A_line_7 | (B_line_7 << 2);

		char A_line_8 = line_0_byte4 & 0x03;
		char B_line_8 = line_1_byte4 & 0x03;
		char F8 = A_line_8 | (B_line_8 << 2);

		assert(n < 64);
		assert(m < 32);

		ints0_INIT[m][n] = F0;
		ints1_INIT[m][n] = F1;
		ints2_INIT[m][n] = F2;
		ints3_INIT[m][n] = F3;
		ints4_INIT[m][n] = F4;
		ints5_INIT[m][n] = F5;
		ints6_INIT[m][n] = F6;
		ints7_INIT[m][n] = F7;
		ints8_INIT[m][n] = F8;

		n += 1;
		if (n == 64) {
			n = 0;
			m += 1;
		}

		
		
	}

	cout << "Init Values are calculated." << endl;

	
	print_block_ram(0, ints0_INIT);
	print_block_ram(1, ints1_INIT);
	print_block_ram(2, ints2_INIT);
	print_block_ram(3, ints3_INIT);
	print_block_ram(4, ints4_INIT);
	print_block_ram(5, ints5_INIT);
	print_block_ram(6, ints6_INIT);
	print_block_ram(7, ints7_INIT);
	print_block_ram(8, ints8_INIT);

	write_out_footer();

	//_getch();
	cout << "Done." << endl;

	return 0;
}


void write_out_header(void) {
	file_out << "library IEEE;" << endl;
	file_out << "use IEEE.STD_LOGIC_1164.ALL;" << endl;
	file_out << "use IEEE.NUMERIC_STD.ALL;" << endl;

	file_out << "library ice;" << endl;
	file_out << "use ice.all;" << endl;

	file_out << "entity program_memory  is  " << endl << endl;
	file_out << "port (" << endl;
	file_out << "    clka : IN STD_LOGIC;" << endl;
	file_out << "    ena : IN STD_LOGIC;" << endl;
	file_out << "    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);" << endl;
	file_out << "    addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);" << endl;
	file_out << "    dina : IN STD_LOGIC_VECTOR(17 DOWNTO 0);" << endl;
	file_out << "    douta : OUT STD_LOGIC_VECTOR(17 DOWNTO 0)" << endl;
	file_out << "  );" << endl;
	file_out << "end program_memory;  " << endl << endl;

	file_out << "architecture Behavioral of program_memory is" << endl;

	file_out << "component SB_RAM2048x2 is" << endl;
	file_out << "	generic ( " << endl;
	file_out << "       INIT_0 : bit_vector := X\"0000000000000000000000000000000000000000000000000000000000000000\";" << endl;
	file_out << "       INIT_1 : bit_vector := X\"0000000000000000000000000000000000000000000000000000000000000000\";" << endl;
	file_out << "       INIT_2 : bit_vector := X\"0000000000000000000000000000000000000000000000000000000000000000\";" << endl;
	file_out << "       INIT_3 : bit_vector := X\"0000000000000000000000000000000000000000000000000000000000000000\";" << endl;
	file_out << "       INIT_4 : bit_vector := X\"0000000000000000000000000000000000000000000000000000000000000000\";" << endl;
	file_out << "       INIT_5 : bit_vector := X\"0000000000000000000000000000000000000000000000000000000000000000\";" << endl;
	file_out << "       INIT_6 : bit_vector := X\"0000000000000000000000000000000000000000000000000000000000000000\";" << endl;
	file_out << "       INIT_7 : bit_vector := X\"0000000000000000000000000000000000000000000000000000000000000000\";" << endl;
	file_out << "       INIT_8 : bit_vector := X\"0000000000000000000000000000000000000000000000000000000000000000\";" << endl;
	file_out << "       INIT_9 : bit_vector := X\"0000000000000000000000000000000000000000000000000000000000000000\";" << endl;
	file_out << "       INIT_A : bit_vector := X\"0000000000000000000000000000000000000000000000000000000000000000\";" << endl;
	file_out << "       INIT_B : bit_vector := X\"0000000000000000000000000000000000000000000000000000000000000000\";" << endl;
	file_out << "       INIT_C : bit_vector := X\"0000000000000000000000000000000000000000000000000000000000000000\";" << endl;
	file_out << "       INIT_D : bit_vector := X\"0000000000000000000000000000000000000000000000000000000000000000\";" << endl;
	file_out << "       INIT_E : bit_vector := X\"0000000000000000000000000000000000000000000000000000000000000000\";" << endl;
	file_out << "       INIT_F : bit_vector := X\"0000000000000000000000000000000000000000000000000000000000000000\"" << endl;
	file_out << "       ) ;" << endl;
	file_out << "      port( " << endl;
	file_out << "          RDATA : out std_logic_vector( 1  downto 0) ;" << endl;
	file_out << "          RCLK  : in  std_logic ;" << endl;
	file_out << "          RCLKE : in  std_logic := 'H';" << endl;
	file_out << "          RE    : in  std_logic := 'L';" << endl;
	file_out << "          RADDR : in  std_logic_vector( 10  downto 0) ;" << endl;
	file_out << "          WCLK  : in  std_logic ;" << endl;
	file_out << "          WCLKE : in  std_logic := 'H';" << endl;
	file_out << "          WE    : in  std_logic := 'L';" << endl;
	file_out << "          WADDR : in  std_logic_vector( 10  downto 0) ;" << endl;
	file_out << "          WDATA : in  std_logic_vector( 1  downto 0)" << endl;
	file_out << "         );" << endl;
	file_out << "end component;" << endl;

	file_out << "signal WE : std_logic;" << endl;

	file_out << "begin " << endl;

	file_out << "WE <= wea(0);" << endl;
}

void write_out_footer(void) {
	file_out << "end Behavioral;" << endl << endl;
}

char print_char(char *p) {
	char r = '0';
	switch (*p) {
	case 0x00:	r = '0'; break;
	case 0x01:	r = '1'; break;
	case 0x02:	r = '2'; break;
	case 0x03:	r = '3'; break;
	case 0x04:	r = '4'; break;
	case 0x05:	r = '5'; break;
	case 0x06:	r = '6'; break;
	case 0x07:	r = '7'; break;
	case 0x08:	r = '8'; break;
	case 0x09:	r = '9'; break;
	case 0x0A:	r = 'A'; break;
	case 0x0B:	r = 'B'; break;
	case 0x0C:	r = 'C'; break;
	case 0x0D:	r = 'D'; break;
	case 0x0E:	r = 'E'; break;
	case 0x0F:	r = 'F'; break;
	default: r = '0';
	}
	return r;
}

char print_row(unsigned int *i) {
	char r = '0';
	switch (*i) {
	case 0:	r = '0'; break;
	case 1:	r = '1'; break;
	case 2:	r = '2'; break;
	case 3:	r = '3'; break;
	case 4:	r = '4'; break;
	case 5:	r = '5'; break;
	case 6:	r = '6'; break;
	case 7:	r = '7'; break;
	case 8:	r = '8'; break;
	case 9:	r = '9'; break;
	case 10: r = 'A'; break;
	case 11:	r = 'B'; break;
	case 12:	r = 'C'; break;
	case 13:	r = 'D'; break;
	case 14:	r = 'E'; break;
	case 15:	r = 'F'; break;
	default: r = '0';
	}
	return r;
}

void print_block_ram(unsigned int inst_no, char init_array[][64]) {
	
	file_out << "Ram2048x2_inst" << inst_no << " : SB_RAM2048x2" << endl;
	file_out << "generic map (" << endl;

	unsigned int i = 0;
	unsigned int j = 0;
	for (i = 0; i <16; i++) {
		file_out << "INIT_" << print_row(&i) << " => X\"";
		for (j = 0; j < 65; j++) {
			file_out << print_char(&init_array[i][j]);
		}
		if (i != 15)
			file_out << "\"," << endl;
		else

			file_out << "\"" << endl;
	}

	unsigned int top_range = 0;
	unsigned int buttom_range = 0;

	switch (inst_no) {
		case 0: top_range = 1; buttom_range = 0; break;
		case 1: top_range = 3; buttom_range = 2; break;
		case 2: top_range = 5; buttom_range = 4; break;
		case 3: top_range = 7; buttom_range = 6; break;
		case 4: top_range = 9; buttom_range = 8; break;
		case 5: top_range = 11; buttom_range = 10; break;
		case 6: top_range = 13; buttom_range = 12; break;
		case 7: top_range = 15; buttom_range = 14; break;
		case 8: top_range = 17; buttom_range = 16; break;
		default: top_range = 0; buttom_range = 0;
	}

	// inst = 0 ,   0 , 1
	// inst = 1 ,   2 , 3
	// inst = 2,    4 , 5
	// inst - 3,    6 , 7

	file_out << ")" << endl;
	file_out << "port map (" << endl;
	file_out << "RDATA => douta("<< top_range << " downto " << buttom_range << ")," << endl;
	file_out << "RADDR => addra(10 downto 0)," << endl;
	file_out << "RCLK => clka," << endl;
	file_out << "RCLKE => ena," << endl;
	file_out << "RE => '1'," << endl;
	file_out << "WADDR => addra(10 downto 0)," << endl;
	file_out << "WCLK=> clka," << endl;
	file_out << "WCLKE => ena," << endl;
	file_out << "WDATA => dina(" << top_range << " downto " << buttom_range << ")," << endl;
	file_out << "WE => WE" << endl;
	file_out << ");" << endl;

}





