----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/02/2024 04:40:28 PM
-- Design Name: 
-- Module Name: ID - Behavioral
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

entity id_pipeline is
Port ( clk : in std_logic;
 instruction: in std_logic_vector(25 downto 0);
wd : in std_logic_vector(31 downto 0);
en : in std_logic;
ext_op:in std_logic;
regwr : in std_logic;

wa : in std_logic_vector(4 downto 0);
rd1 : out std_logic_vector(31 downto 0);
rd2 : out std_logic_vector(31 downto 0);
funct : out std_logic_vector(5 downto 0);
ext_imm: out std_logic_vector(31 downto 0);
sa: out std_logic_vector(4 downto 0);
rt: out std_logic_vector(4 downto 0);
rd: out std_logic_vector(4 downto 0)
 );
end id_pipeline;

architecture Behavioral of id_pipeline is

type reg_array is array(0 to 31) of std_logic_vector(31 downto 0);
signal reg_file : reg_array:= (
others => X"00000000");
signal rs: std_logic_vector(4 downto 0);
signal ext_unit: std_logic_vector(15 downto 0);
begin
rs<=instruction(25 downto 21);
rt<=instruction(20 downto 16);
rd<=instruction(15 downto 11);

process(ext_op,instruction)
begin
case ext_op is
when '0' => ext_imm<=X"0000"& instruction(15 downto 0);
when '1' =>
ext_imm<= instruction(15)&
           instruction(15)&
               instruction(15)&
                  instruction(15)&
                      instruction(15)&
                          instruction(15)&
                              instruction(15)&
                                  instruction(15)&
                                       instruction(15)&
                                            instruction(15)&
                                               instruction(15)&
                                                  instruction(15)&
                                                       instruction(15)&
                                                          instruction(15)&
                                                              instruction(15)&
                                                                   instruction(15)&
         instruction(15 downto 0);
when others => ext_imm<=X"00000000";
end case;
end process;
process(clk)
begin
if falling_edge(clk) then
if regwr = '1' and en='1' then
reg_file(conv_integer(wa)) <= wd;
end if;
end if;
end process;
rd1 <= reg_file(conv_integer(rs));
rd2 <= reg_file(conv_integer(instruction(20 downto 16)));
funct<=instruction(5 downto 0);
sa<=instruction(10 downto 6);
end Behavioral;