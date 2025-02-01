----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/26/2024 04:48:09 PM
-- Design Name: 
-- Module Name: IFetch - Behavioral
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
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IFetch is
   Port ( 
        jump: in std_logic;
        jumpAdress: in std_logic_vector(31 downto 0);
        PCSrc: in std_logic;
        BranchAdress: in std_logic_vector(31 downto 0);
        en: in std_logic;
        rst: in std_logic;
        clk: in std_logic;
        instruction: out std_logic_vector(31 downto 0);
        pc_4: out  std_logic_vector(31 downto 0)
    );
end IFetch;

architecture Behavioral of IFetch is
 type t_mem is array(0 to 31) of std_logic_vector(31 downto 0);
signal mem: t_mem := ( 
   B"100011_00000_01000_0000000000000000",--00 8C080000 lw $8,0($0)  Se încarcã X din memorie în registrul $t0
   B"100011_00000_00001_0000000000000100",--01 8C810004 lw $1,4($0) Se încarcã Y din memorie în registrul $t1
   B"100011_00000_00010_0000000000001000",--02 8C020008 lw $2,8($0) Se încarcã N din memorie în registrul $t2
   B"001000_00000_00011_0000000000000000",--03 20030010 addi $3, 0($0), 0 Se ini?ializeazã $t3 cu adresa începutului ?irului
       B"000000_00000_00000_00100_00000_100000",--04 2020 add $4, $0, 0  Se ini?ializeazã $t4 cu suma par?ialã a elementelor
      B"000000_00000_00010_01010_00000_100000",--5 25020 add $10, $0, $2  numarul maxim de iteratii
    B"001000_00000_01001_0000000000000000",--06 20090001 addi $9, $0, 1  Se ini?ializeazã in 9 contorul 
   B"100011_00011_00101_0000000000010000",--8  8C650010 lw $5, 16($t3)  Se încarcã valoarea din memorie la adresa indicatã de $t3 în $t5
   B"000000_01000_00101_00110_00000_101010",--9 105302A slt $6, $0, $5 Se verificã dacã valoarea este mai mare sau egalã cu X
   B"000100_00110_00000_0000000000000011",--10  10C00003 beq $6, $0, 3  Se ver ificã dacã valoarea este mai micã decât x
    B"000000_00101_00001_00111_00000_101010",--11  A1382A slt $7, $5, $1  Se verificã dacã valoarea este mai micã decât Y
   B"000100_00111_00000_0000000000000000",--12  10E00000 beq $7,$0,0 Dacã valoarea nu este mai micã decât Y, adãugãm la sumã
   B"000000_00100_00101_00100_00000_100000", --13 852020 add $t4, $t4, $t5 Se adaugã valoarea la suma par?ialã
   B"001000_00011_00011_0000000000000100",--14 20630000 addi $3, $3, 4    # Se trece la urmãtorul element din ?ir
   B"001000_01001_01001_0000000000000001",--15 21290001 addi $9, $9, 1    # Se creste contorul
   B"000100_01001_01010_0000000000000001",--7 11220001 beq $9,$10 1   verific daca s au parcurs toate elem
   B"000010_00000000000000000000000111",--16 8000007 j 7--sar la urm element din sir 
   B"101011_00000_00100_0000000000001100", --17 AC04000C sw $4, 12($0) stochez la adresa 12 oe 4 
      B"100011_00000_00001_0000000000001100",--01 8C81000C lw $1,12($0) Se încarcã Y din memorie în registrul $t1

    others => X"00000000"
);
signal Q :std_logic_vector(31 downto 0);
signal D:std_logic_vector(31 downto 0);

signal mux1: std_logic_vector(31 downto 0);
begin
pc:
process(clk,rst)
begin 
  if rst='1' then 
    Q<=X"00000000";
  elsif rising_edge(clk) then
     if en='1' then
     Q<=D;
    end if;
   end if;
end process;
pc_4<= Q + 4;
instruction<=mem(conv_integer(Q(6 downto 2)));

mux_1:
process(PCSrc,BranchAdress)
begin 
case PCSrc is
when '0' => mux1<= Q+4;
when '1' => mux1<=BranchAdress;
when others => mux1<=X"00000000";
end case;
end process;

mux_2: 
process(jump,jumpAdress,mux1)
begin 
case jump is
when '0' => D<=mux1;
when '1' =>D<=jumpAdress;
when others => D<=X"00000000";
end case;
end process;


end Behavioral;
