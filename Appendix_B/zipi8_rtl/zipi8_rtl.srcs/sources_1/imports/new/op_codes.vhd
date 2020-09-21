----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/23/2019 08:13:47 PM
-- Design Name: 
-- Module Name: opcodes - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package op_codes is

constant OP_LOAD_SX_SY : STD_LOGIC_VECTOR (5 downto 0) :=  "000000";
constant OP_LOAD_SX_KK : STD_LOGIC_VECTOR (5 downto 0) :=  "000001";
constant OP_STAR_SX_SY : STD_LOGIC_VECTOR (5 downto 0) :=  "010110";

constant OP_AND_SX_SY : STD_LOGIC_VECTOR (5 downto 0) :=  "000010";
constant OP_AND_SX_KK : STD_LOGIC_VECTOR (5 downto 0) :=  "000011";
constant OP_OR_SX_SY : STD_LOGIC_VECTOR (5 downto 0) :=  "000100";
constant OP_OR_SX_KK : STD_LOGIC_VECTOR (5 downto 0) :=  "000101";
constant OP_XOR_SX_SY : STD_LOGIC_VECTOR (5 downto 0) :=  "000110";
constant OP_XOR_SX_KK : STD_LOGIC_VECTOR (5 downto 0) :=  "000111";

constant OP_ADD_SX_SY : STD_LOGIC_VECTOR (5 downto 0) :=  "010000";
constant OP_ADD_SX_KK : STD_LOGIC_VECTOR (5 downto 0) :=  "010001";
constant OP_ADDCY_SX_SY : STD_LOGIC_VECTOR (5 downto 0) :=  "010010";
constant OP_ADDCY_SX_KK : STD_LOGIC_VECTOR (5 downto 0) :=  "010011";
constant OP_SUB_SX_SY : STD_LOGIC_VECTOR (5 downto 0) :=  "011000";
constant OP_SUB_SX_KK : STD_LOGIC_VECTOR (5 downto 0) :=  "011001";
constant OP_SUBCY_SX_SY : STD_LOGIC_VECTOR (5 downto 0) :=  "011010";
constant OP_SUBCY_SX_KK : STD_LOGIC_VECTOR (5 downto 0) :=  "011011";

constant OP_TEST_SX_SY : STD_LOGIC_VECTOR (5 downto 0) :=  "001100";
constant OP_TEST_SX_KK : STD_LOGIC_VECTOR (5 downto 0) :=  "001101";
constant OP_TESTCY_SX_SY : STD_LOGIC_VECTOR (5 downto 0) :=  "001110";
constant OP_TESTCY_SX_KK : STD_LOGIC_VECTOR (5 downto 0) :=  "001111";
constant OP_COMPARE_SX_SY : STD_LOGIC_VECTOR (5 downto 0) :=  "011100";
constant OP_COMPARE_SX_KK : STD_LOGIC_VECTOR (5 downto 0) :=  "011101";
constant OP_COMPARECY_SX_SY : STD_LOGIC_VECTOR (5 downto 0) :=  "011110";
constant OP_COMPARECY_SX_KK : STD_LOGIC_VECTOR (5 downto 0) :=  "011111";

constant OP_SL0_SX : STD_LOGIC_VECTOR (5 downto 0) :=  "010100";
constant OP_SL1_SX : STD_LOGIC_VECTOR (5 downto 0) :=  "010100";
constant OP_SLX_SX : STD_LOGIC_VECTOR (5 downto 0) :=  "010100";
constant OP_SLA_SX : STD_LOGIC_VECTOR (5 downto 0) :=  "010100";
constant OP_RL_SX : STD_LOGIC_VECTOR (5 downto 0) :=  "010100";
constant OP_SR0_SX : STD_LOGIC_VECTOR (5 downto 0) :=  "010100";
constant OP_SR1_SX : STD_LOGIC_VECTOR (5 downto 0) :=  "010100";
constant OP_SRX_SX : STD_LOGIC_VECTOR (5 downto 0) :=  "010100";
constant OP_SRA_SX : STD_LOGIC_VECTOR (5 downto 0) :=  "010100";
constant OP_RR_SX : STD_LOGIC_VECTOR (5 downto 0) :=  "010100";

constant OP_REGBANK_A : STD_LOGIC_VECTOR (5 downto 0) :=  "110111";
constant OP_REGBANK_B : STD_LOGIC_VECTOR (5 downto 0) :=  "110111";

constant OP_INPUT_SX_SY : STD_LOGIC_VECTOR (5 downto 0) :=  "001000";
constant OP_INPUT_SX_PP : STD_LOGIC_VECTOR (5 downto 0) :=  "001001";
constant OP_OUTPUT_SX_SY : STD_LOGIC_VECTOR (5 downto 0) :=  "101100";
constant OP_OUTPUT_SX_PP : STD_LOGIC_VECTOR (5 downto 0) :=  "101101";
constant OP_OUTPUTK_KK_P : STD_LOGIC_VECTOR (5 downto 0) :=  "101011";


constant OP_STORE_SX_SY : STD_LOGIC_VECTOR (5 downto 0) :=  "101110";
constant OP_STORE_SX_SS : STD_LOGIC_VECTOR (5 downto 0) :=  "101111";
constant OP_FETCH_SX_SY : STD_LOGIC_VECTOR (5 downto 0) :=  "001010";
constant OP_FETCH_SX_SS : STD_LOGIC_VECTOR (5 downto 0) :=  "001011";

constant OP_DISABLE_INTERRUPT : STD_LOGIC_VECTOR (5 downto 0) :=  "101000";
constant OP_ENABLE_INTERRUPT : STD_LOGIC_VECTOR (5 downto 0) :=  "101000";
constant OP_RETURNI_DISABLE : STD_LOGIC_VECTOR (5 downto 0) :=  "101001";
constant OP_RETURNI_ENABLE : STD_LOGIC_VECTOR (5 downto 0) :=  "101001";

constant OP_JUMP_AAA : STD_LOGIC_VECTOR (5 downto 0) :=  "100010";
constant OP_JUMP_Z_AAA : STD_LOGIC_VECTOR (5 downto 0) :=  "110010";
constant OP_JUMP_NZ_AAA : STD_LOGIC_VECTOR (5 downto 0) :=  "110110";
constant OP_JUMP_C_AAA : STD_LOGIC_VECTOR (5 downto 0) :=  "111010";
constant OP_JUMP_NC_AAA : STD_LOGIC_VECTOR (5 downto 0) :=  "111110";
constant OP_JUMP_SX_SY : STD_LOGIC_VECTOR (5 downto 0) :=  "100110";

constant OP_CALL_AAA : STD_LOGIC_VECTOR (5 downto 0) :=  "100000";
constant OP_CALL_Z_AAA : STD_LOGIC_VECTOR (5 downto 0) :=  "110000";
constant OP_CALL_NZ_AAA : STD_LOGIC_VECTOR (5 downto 0) :=  "110100";
constant OP_CALL_C_AAA : STD_LOGIC_VECTOR (5 downto 0) :=  "111000";
constant OP_CALL_NC_AAA : STD_LOGIC_VECTOR (5 downto 0) :=  "111100";
constant OP_CALL_SX_SY : STD_LOGIC_VECTOR (5 downto 0) :=  "100100";
constant OP_RETURN : STD_LOGIC_VECTOR (5 downto 0) :=  "100101";
constant OP_RETURN_Z : STD_LOGIC_VECTOR (5 downto 0) :=  "110001";
constant OP_RETURN_NZ : STD_LOGIC_VECTOR (5 downto 0) :=  "110101";
constant OP_RETURN_C : STD_LOGIC_VECTOR (5 downto 0) :=  "111001";
constant OP_RETURN_NC : STD_LOGIC_VECTOR (5 downto 0) :=  "111101";
constant OP_LOADRETURN_SX_KK : STD_LOGIC_VECTOR (5 downto 0) :=  "100001";

constant OP_HWBUILD_SX : STD_LOGIC_VECTOR (5 downto 0) :=  "010100";

end op_codes;

package body op_codes is

  
end op_codes;
