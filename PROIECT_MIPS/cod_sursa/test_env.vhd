library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity test_env is
    Port ( 
        clk : in STD_LOGIC;
        btn : in STD_LOGIC_VECTOR (4 downto 0);
        sw : in STD_LOGIC_VECTOR (15 downto 0);
        led : out STD_LOGIC_VECTOR (15 downto 0);
        an : out STD_LOGIC_VECTOR (7 downto 0);
        cat : out STD_LOGIC_VECTOR (6 downto 0)
    );

end test_env;

architecture Behavioral of test_env is
    signal en: std_logic := '0';
  signal instruction:std_logic_vector(5 downto 0);
signal RegDst: std_logic;
signal ExtOp:  std_logic;
signal ALUSrc: std_logic;
signal Branch:  std_logic;
signal Branch_NE:  std_logic;
signal Jump:  std_logic;
signal AluOp:  std_logic_vector(1 downto 0);
signal MemWrite:  std_logic;
signal MemToReg:  std_logic;
signal RegWrite: std_logic;
signal wd :  std_logic_vector(31 downto 0);
signal ext_op: std_logic;
signal regwr :  std_logic;
signal reg_dest:  std_logic;
signal rd1 : std_logic_vector(31 downto 0);
signal rd2 : std_logic_vector(31 downto 0);
signal funct : std_logic_vector(5 downto 0);
signal ext_imm: std_logic_vector(31 downto 0);
signal sa:  std_logic_vector(4 downto 0);
    signal addr: std_logic_vector(4 downto 0);
    signal instruction_out: std_logic_vector(31 downto 0);
    signal pc_4_out: std_logic_vector(31 downto 0);
    signal mux_out: std_logic_vector(31 downto 0);
    
signal func_ext: std_logic_vector(31 downto 0);
signal sa_ext : std_logic_vector(31 downto 0);
signal sum: std_logic_vector(31 downto 0);
signal rez_mux: std_logic_Vector(31 downto 0);
signal zero : std_logic;
signal branch_address: std_logic_vector(31 downto 0);
signal alu_res : std_logic_vector(31 downto 0);
signal alu_res_in : std_logic_vector(31 downto 0);
signal alu_res_out : std_logic_vector(31 downto 0);
signal mem_data: std_logic_vector(31 downto 0);
signal jump_address: std_logic_vector(31 downto 0);
signal pc_src: std_logic;
signal si1: std_logic;
signal si2: std_logic;
    component MPG is
    Port ( enable : out STD_LOGIC;
           btn : in STD_LOGIC;
           clk : in STD_LOGIC);
end component;

component SSD is
    Port ( clk : in STD_LOGIC;
           digits : in STD_LOGIC_VECTOR(31 downto 0);
           an : out STD_LOGIC_VECTOR(7 downto 0);
           cat : out STD_LOGIC_VECTOR(6 downto 0));
end component;
 component IFetch 
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
    end component;
    
component ID is
Port ( clk : in std_logic;
 instruction: in std_logic_vector(25 downto 0);
wd : in std_logic_vector(31 downto 0);
en : in std_logic;
ext_op:in std_logic;
regwr : in std_logic;
reg_dest: in std_logic;
rd1 : out std_logic_vector(31 downto 0);
rd2 : out std_logic_vector(31 downto 0);
funct : out std_logic_vector(5 downto 0);
ext_imm: out std_logic_vector(31 downto 0);
sa: out std_logic_vector(4 downto 0)
 );
end component;

component UC is
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
end component;

component EX is
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
end component;

component mem is
Port (
  mem_write: in std_logic;
  alu_res_in: in std_logic_vector(31 downto 0);
  rd2: in std_logic_vector(31 downto 0);
  clk: in std_logic;
  en : in std_logic;
  mem_data : out std_logic_vector(31 downto 0);
  alu_res_out: out std_logic_vector(31 downto 0)

 );
end component;

begin
unitate_control: UC port map(instruction_out(31 downto 26),RegDst,ExtOp,ALUSrc,Branch,Branch_NE,Jump,AluOp,MemWrite,MemToReg,RegWrite);
i_d: ID port map(clk,instruction_out(25 downto 0), wd ,en, ExtOp,RegWrite, RegDst, rd1, rd2, funct, ext_imm, sa);
 monopulse: MPG port map(en, btn(0), clk);
 Fetch: IFetch port map(Jump,jump_address,pc_src,branch_address,en,btn(1),clk,instruction_out,pc_4_out);
ex_c: EX port map(ALUSrc, rd1,rd2,ext_imm,funct,sa,AluOp,pc_4_out,zero,alu_res,branch_address);
mem_c : mem port map(MemWrite,alu_res, rd2, clk, en, mem_data, alu_res);



process(MemToReg, alu_res_out, mem_data)
begin
case MemToReg is 
  when '0' => wd<=alu_res;
  when '1' => wd<=mem_Data;
  when others => wd<=X"00000000";
  end case;
end process;

si1<= Branch and zero;
si2<=Branch_NE and not(zero);
pc_src<=si1 or si2;

jump_address<= pc_4_out(31 downto 28) & instruction_out(25 downto 0) &  "00";


mux: process(sw(7 downto 5),instruction_out,pc_4_out,rd1,rd2,sum,ext_imm,alu_res,wd,mem_data)
begin
case sw(7 downto 5) is
when "000" => rez_mux<=instruction_out;
when "001" => rez_mux<=pc_4_out;
when "010" => rez_mux<=rd1;
when "011" => rez_mux<=rd2;
when "100" => rez_mux<=ext_imm;
when "101" => rez_mux<=alu_res;
when "110" => rez_mux<=mem_data;
when "111" => rez_mux<=wd;
when others=> rez_mux<=X"00000000";
end case;
end process;
led(10 downto 9) <= AluOp;
led(8)<=RegDst;
led(7)<=ExtOp;
led(6)<=ALUSrc;
led(5)<=Branch;
led(4)<=Branch_NE;
led(3)<=Jump;
led(2)<=MemWrite;
led(1)<=MemToReg;
led(0)<=RegWrite;
--led(10 downto 0)<=AluOp & RegDst& ExtOp & ALUSrc & Branch &Branch_NE& Jump &MemWrite &MemToReg &RegWrite;
    dispay: SSD port map(clk, rez_mux, an, cat);

end Behavioral;