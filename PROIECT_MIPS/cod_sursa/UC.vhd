----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/02/2024 05:19:50 PM
-- Design Name: 
-- Module Name: UC - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UC is
Port(
instruction:in std_logic_vector(5 downto 0);
RegDst:out std_logic;
ExtOp: out std_logic;
ALUSrc: out std_logic;
Branch: out std_logic;
Branch_NE: out std_logic;
Jump: out std_logic;
AluOp: out std_logic_vector(1 downto 0);
MemWrite: out std_logic;
MemToReg: out std_logic;
RegWrite:out std_logic
);

end UC;

architecture Behavioral of UC is

begin

process(instruction)
begin
RegDst<='0';
ExtOp<='0';
ALUSrc<='0';
Branch<='0';
Branch_NE<='0';
Jump<='0';
MemWrite<='0';
MemToReg<='0';
RegWrite<='0';
AluOp<="00";
case Instruction is
   when "000000" => RegDst<='1'; 
                    RegWrite<='1';
                    AluOp<="10";
   --addi
   when "001000" => ExtOp<='1';
                    ALUSrc<='1';
                    RegWrite<='1';
                    AluOp<="00";
   --lw
   when "100011" => ExtOp<='1';
                    ALUSrc<='1';
                    MemToReg<='1';
                    RegWrite<='1';
                    AluOp<="00";
   --sw
   when "101011"=> ExtOp<='1';
                    ALUSrc<='1';
                    MemToReg<='1';
                    MemWrite<='1';
                    RegWrite<='1';
                    AluOp<="00";
   --beq
   when "000100"=>ExtOp<='1';
                 Branch<='1';
                 AluOp<="01";
   --bne
   when "000101"=>ExtOp<='1';
                 Branch_NE<='1';
                 AluOp<="01";
    --ori
   when "001101"=>ALUSrc<='1';
                  RegWrite<='1';
                  AluOp<="11";
   --jump
   when "000010"=>Jump<='1';
                  AluOp<="10";
   when others  => RegDst<='0';
ExtOp<='X';
ALUSrc<='X';
Branch<='X';
Branch_NE<='X';
Jump<='X';
MemWrite<='X';
MemToReg<='X';
RegWrite<='X';
AluOp<="XX";
   end case;
   end process;          
      
end Behavioral;
