----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/16/2024 01:18:54 PM
-- Design Name: 
-- Module Name: mem - Behavioral
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

entity mem is
Port (
  mem_write: in std_logic;
  alu_res_in: in std_logic_vector(31 downto 0);
  rd2: in std_logic_vector(31 downto 0);
  clk: in std_logic;
  en : in std_logic;
  mem_data : out std_logic_vector(31 downto 0);
  alu_res_out: out std_logic_vector(31 downto 0)

 );
end mem;

architecture Behavioral of mem is
type mem_type is array(0 to 63) of std_logic_vector(31 downto 0);
signal mem: mem_type := (
     X"0000000F",  -- Adresa 0: 15 (0x0F)
    X"00000028",  -- Adresa 4: 40 (0x28)
    X"00000007",  -- Adresa 8: 7 (0x0A)
   X"00000000", -- adresa 12 
    X"00000014",  -- Adresa 16: 20 (0x14)
    X"0000000A",  -- Adresa 20: 10 (0x0A)
    X"00000007",  -- Adresa 24: 7 (0x07)
   X"00000013",  -- Adresa 28: 19 (0x13)
     X"00000020",  -- Adresa 32: 32 (0x20)
    X"00000005",  -- Adresa 36: 5 (0x05)
     X"00000027",  -- Adresa 40: 39 (0x27)
     
    others => X"00000000"  -- Toate celelalte adrese ini?ializate cu 0
);


begin
mem_data<= mem(conv_integer(alu_res_in(7 downto 2)));
 

process(clk) 
begin
  if rising_edge(clk) then
     if en = '1' and mem_write = '1' then
     mem(conv_integer(alu_res_in(7 downto 2))) <= rd2;
     end if;
  end if;
end process;

alu_res_out<= alu_res_in;


end Behavioral;
