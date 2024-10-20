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

entity if_pipeline is
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
end if_pipeline;

architecture Behavioral of if_pipeline is
 type t_mem is array(0 to 63) of std_logic_vector(31 downto 0);
signal mem: t_mem := ( 
   B"100011_00000_01000_0000000000000000",--00 8C080000 lw $8,0($0)  Se încarcã X din memorie în registrul $t0
   B"100011_00000_00001_0000000000000100",--01 8C810004 lw $1,4($0) Se încarcã Y din memorie în registrul $t1
   B"100011_00000_00010_0000000000001000",--02 8C020008 lw $2,8($0) Se încarcã N din memorie în registrul $t2
   B"001000_00000_00011_0000000000000000",--03 20030000 addi $3, 0($0), 0 Se ini?ializeazã $t3 cu adresa începutului ?irului
       B"000000_00000_00000_00100_00000_100000",--04 00002020 add $4, $0, 0  Se ini?ializeazã $t4 cu suma par?ialã a elementelor
      B"000000_00000_00010_01010_00000_100000",--05 00025020 add $10, $0, $2  numarul maxim de iteratii
     B"000000_00000_00000_01100_00000_100000",  -- 06 00006020   add $12, $0, $0
    B"001000_00000_01001_0000000000000000",--07 20090000 addi $9, $0, 0  Se ini?ializeazã in 9 contorul 
   B"100011_00011_00101_0000000000010000",--08  8C650010 lw $5, 16($t3)  Se încarcã valoarea din memorie la adresa indicatã de $t3 în $t5
   B"000000_00000_00000_00000_00000_100000" , --09   00000020 add $0, $0, 0  NOOP
   B"000000_00000_00000_00000_00000_100000",  --10   00000020 add $0, $0, 0  NOOP
   B"000000_01000_00101_00110_00000_101010",--11 105302A slt $6, $8, $5 Se verificã dacã valoarea este mai mare sau egalã cu X
   B"000000_00000_00000_00000_00000_100000", -- 12 00000020 add $0, $0, 0  NOOP
    B"000000_00000_00000_00000_00000_100000", --13 00000020 add $0, $0, 0  NOOP
   B"000100_00110_01100_0000000000001011",--14 10CC000b beq $6, $12, 11  Se ver ificã dacã valoarea este mai micã decât x
   B"000000_00000_00000_00000_00000_100000", -- 15 00000020 add $0, $0, 0  NOOP
    B"000000_00000_00000_00000_00000_100000",--16 00000020 add $0, $0, 0  NOOP
    B"000000_00000_00000_00000_00000_100000", --17 00000020 add $0, $0, 0  NOOP
    B"000000_00101_00001_00111_00000_101010",--18  A1382A slt $7, $5, $1  Se verificã dacã valoarea este mai micã decât Y
       B"000000_00000_00000_00000_00000_100000", -- 19 00000020 add $0, $0, 0  NOOP
        B"000000_00000_00000_00000_00000_100000", -- 20 00000020 add $0, $0, 0  NOOP
   B"000100_00111_01100_0000000000000011",--21 10EC0003 beq $7,$12,3 Dacã valoarea nu este mai micã decât Y, adãugãm la sumã
      B"000000_00000_00000_00000_00000_100000", --22 00000020 add $0, $0, 0  NOOP
       B"000000_00000_00000_00000_00000_100000",--23 00000020 add $0, $0, 0  NOOP
       B"000000_00000_00000_00000_00000_100000",--24 00000020 add $0, $0, 0  NOOP
  B"000000_00100_00101_00100_00000_100000", --25 852020 add $t4, $t4, $t5 Se adaugã valoarea la suma par?ialã
   B"001000_00011_00011_0000000000000100",--26 20630000 addi $3, $3, 4    # Se trece la urmãtorul element din ?ir
   B"001000_01001_01001_0000000000000001",--27 21290001 addi $9, $9, 1    # Se creste contorul
       B"000000_00000_00000_00000_00000_100000", --28 00000020 add $0, $0, 0  NOOP
         B"000000_00000_00000_00000_00000_100000", --29 00000020 add $0, $0, 0  NOOP
   B"000100_01001_01010_0000000000000101",--30 112A0005 beq $9,$10 5   verific daca s au parcurs toate elem
       B"000000_00000_00000_00000_00000_100000",--31 00000020 add $0, $0, 0  NOOP
       B"000000_00000_00000_00000_00000_100000",--32 00000020 add $0, $0, 0  NOOP
       B"000000_00000_00000_00000_00000_100000",--33 00000020 add $0, $0, 0  NOOP
   B"000010_00000000000000000000001000",--34 8000008 j 8--sar la urm element din sir 
      B"000000_00000_00000_00000_00000_100000", --35 00000020 add $0, $0, 0  NOOP
   B"101011_00000_00100_0000000000001100", --36 AC04000C sw $4, 12($0) stochez la adresa 12 oe 4 
      B"100011_00000_00001_0000000000001100",--37 8C81000C lw $1,12($0) Se încarcã Y din memorie în registrul $t1

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
    Q <=( others=>'0');
  elsif rising_edge(clk) then
     if en='1' then
     Q<=D;
    end if;
   end if;
end process;
pc_4<= Q + 4;
instruction<=mem(conv_integer(Q(7 downto 2)));

mux_1:
process(PCSrc,BranchAdress,Q)
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
