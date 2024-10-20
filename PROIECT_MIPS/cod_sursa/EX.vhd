----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/09/2024 05:11:49 PM
-- Design Name: 
-- Module Name: EX - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.std_logic_arith.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EX is
Port (
AluSrc: in std_logic;
rd1: in std_logic_vector(31 downto 0);
rd2: in std_logic_vector(31 downto 0);
ext_imm:in std_logic_vector(31 downto 0);
func: in std_logic_Vector(5 downto 0);
sa: in std_logic_vector(4 downto 0);

alu_op: in std_logic_vector(1 downto 0);
pc_4: in std_logic_vector(31 downto 0);
zero: out std_logic;
alu_res: out std_logic_vector(31 downto 0);
branch_address: out std_logic_vector(31 downto 0)



 );
end EX;

architecture Behavioral of EX is
signal alu_control: std_logic_vector(2 downto 0);
signal A,B: std_logic_vector(31 downto 0);
signal C: std_logic_vector(31 downto 0);
signal rez_branch: std_logic_vector(31 downto 0);
begin
ALUControl:
process(alu_op, func)
begin
  case alu_op is
  when "10" => 
      case func is
         when "100000"=>alu_control<="000";
         when "100010"=>alu_control<="100";
         when "000000"=>alu_control<="001";
         when "000010"=>alu_control<="011";
         when "100100"=>alu_control<="110";
         when "100101"=>alu_control<="010";
         when "000011"=>alu_control<="101";
         when "101010"=> alu_control<="111";
         when others =>alu_control<=(others=>'X');
         end case;
  when "00" =>
         alu_control<="000";
 when "01" => alu_control<="100";
 when "11" => alu_control<="010";
 when others =>alu_control<=(others=>'X');
 end case;
 end process;
 
 
 mux:
 process(AluSrc, rd2,ext_imm)
 begin
 case AluSrc is
   when '0' => B<=rd2;
   when '1' => B<=ext_imm;
   when others => B<=X"00000000";
   end case;
   end process;
   
 A<=rd1;
 
process(alu_control,A,B)
begin
case alu_control is
   when "000" => C<= A + B;
   when "100" => C<=A - B;
   when "001" => C<=to_stdlogicvector(to_bitvector(B) sll conv_integer(sa));
   when "011" => C<=to_stdlogicvector(to_bitvector(B) srl conv_integer(sa));
   when "101" => C<=to_stdlogicvector(to_bitvector(B) sra conv_integer(sa));
   when "110" => C<=A and B;
   when "010" => C<=A or B;
   when "111" => if A < B then
                                C <= X"00000001";
                           else
                                C <= X"00000000";
                           end if;
   when others => C<=(others =>'X');
   
   end case;
end process;

rez_branch<=ext_imm(29 downto 0) & "00";
branch_address<= rez_branch + pc_4;
zero <='1' when C=X"00000000" else '0';
alu_res<=C;


end Behavioral;
