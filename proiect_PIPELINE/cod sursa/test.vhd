library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity test is
  Port ( 
        clk : in STD_LOGIC;
        btn : in STD_LOGIC_VECTOR (4 downto 0);
        sw : in STD_LOGIC_VECTOR (15 downto 0);
        led : out STD_LOGIC_VECTOR (15 downto 0);
        an : out STD_LOGIC_VECTOR (7 downto 0);
        cat : out STD_LOGIC_VECTOR (6 downto 0)
    );

end test;

architecture Behavioral of test is
    signal en: std_logic := '0';
  signal instruction:std_logic_vector(31 downto 0);
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
signal rd1: std_logic_vector(31 downto 0);
signal rd2: std_logic_vector(31 downto 0);
signal funct:std_logic_vector(5 downto 0);
signal ext_imm: std_logic_vector(31 downto 0);
signal sa: std_logic_vector(4 downto 0);
    signal addr: std_logic_vector(4 downto 0);
   
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
signal rt,rd: std_logic_vector(4 downto 0);
signal rwa:std_logic_vector(4 downto 0);
-----------IF_ID---------
signal instruction_IF_ID: std_logic_vector(31 downto 0);
signal pc_4_IF_ID: std_logic_vector(31 downto 0);

------------ID_EX   ------------

signal RegDst_ID_EX: std_logic;
signal AluSrc_ID_EX: std_logic;
signal Branch_ID_EX : std_logic;
signal Branch_NE_ID_EX : std_logic;
signal AluOp_ID_EX: std_logic_vector(1 downto 0);
signal MemToReg_ID_EX: std_logic;
signal MemWrite_ID_EX: std_logic;
signal RegWrite_ID_EX: std_logic;
signal RD1_ID_EX, RD2_ID_EX: std_logic_vector(31 downto 0);
signal ext_imm_ID_EX: std_logic_vector(31 downto 0);
signal func_ID_EX: std_logic_vector(5 downto 0);
signal sa_ID_EX: std_logic_vector(4 downto 0);
signal RD_ID_EX, RT_ID_EX : std_logic_vector(4 downto 0);
signal pc_4_ID_EX: std_logic_vector(31 downto 0);

-------------EX_MEM------------------
signal RegWrite_EX_MEM: std_logic;
signal MemToReg_EX_MEM: std_logic;
signal MemWrite_EX_MEM: std_logic;
signal Branch_EX_MEM: std_logic;
signal Branch_NE_EX_MEM: std_logic;
signal Branch_Address_EX_MEM: std_logic_vector(31 downto 0);
signal zero_EX_MEM: std_logic;
signal AluRes_EX_MEM: std_logic_vector(31 downto 0);
signal RD2_EX_MEM: std_logic_vector(31 downto 0);
signal RD_EX_MEM: std_logic_vector(4 downto 0);

-----------MEM_WB-----------
signal MemToReg_MEM_WB: std_logic;
signal RegWrite_MEM_WB: std_logic;
signal AluRes_MEM_WB: std_logic_vector(31 downto 0);
signal RD_MEM_WB: std_logic_Vector(4 downto 0);
signal MemData_MEM_WB: std_logic_vector(31 downto 0);
signal wa_MEM_WB: std_logic_vector(4 downto 0);

   component mpg_pipeline is
  Port ( clk : in std_logic;
        btn : in std_logic;
        en : out std_logic );
end component;

 component if_pipeline
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
    
component id_pipeline is
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
end component;

component uc_pipeline is
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

component ex_pipeline is
Port (
AluSrc: in std_logic;
rd1: in std_logic_vector(31 downto 0);
rd2: in std_logic_vector(31 downto 0);
ext_imm:in std_logic_vector(31 downto 0);
func: in std_logic_Vector(5 downto 0);
sa: in std_logic_vector(4 downto 0);

alu_op: in std_logic_vector(1 downto 0);
pc_4: in std_logic_vector(31 downto 0);
rt: in std_logic_vector(4 downto 0);
rd: in std_logic_Vector(4 downto 0);
RegDst: in std_logic;
zero: out std_logic;
alu_res: out std_logic_vector(31 downto 0);
branch_address: out std_logic_vector(31 downto 0);
rWA: out std_logic_vector(4 downto 0)


 );

end component;
component ssd_pipeline is
     Port ( clk : in STD_LOGIC;
           digits : in STD_LOGIC_VECTOR(31 downto 0);
           an : out STD_LOGIC_VECTOR(7 downto 0);
           cat : out STD_LOGIC_VECTOR(6 downto 0));
end component;
component mem_pipeline is
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
unitate_control: uc_pipeline port map(instruction_IF_ID(31 downto 26),RegDst,ExtOp,ALUSrc,Branch,Branch_NE,Jump,AluOp,MemWrite,MemToReg,RegWrite);
i_d_basys: id_pipeline port map(clk,instruction_IF_ID(25 downto 0), wd ,en, ExtOp,RegWrite_MEM_WB,rd_MEM_WB, rd1, rd2, funct, ext_imm, sa,rt,rd);
 monopulse: mpg_pipeline port map(clk,btn(0),en);
 Fetch: if_pipeline port map(Jump,jump_address,pc_src,Branch_Address_EX_MEM,en,btn(1),clk,instruction,pc_4_out);
ex_c: ex_pipeline port map(ALUSrc_ID_EX, rd1_ID_EX,rd2_ID_EX,ext_imm_ID_EX,func_ID_EX,sa_ID_EX,AluOp_ID_EX,pc_4_ID_EX,rt_ID_EX,rd_ID_EX,RegDst_ID_EX,zero,alu_res,branch_address,rWA);
mem_c : mem_pipeline  port map(MemWrite_EX_MEM,AluRes_EX_MEM, rd2_EX_MEM, clk, en, mem_data, alu_res_out);

     --write back
     with MemToReg_MEM_WB SELECT 
     wd <=AluRes_MEM_WB when '0', 
          MemData_MEM_WB when '1',
          (others => 'X') when others;
          
          
--basysline registre
process(clk)
begin
  if rising_edge(clk) then
      if en = '1' then  
     --IF_ID
     instruction_IF_ID <= instruction;
     pc_4_IF_ID<=pc_4_out;
     --ID_EX
  RegDst_ID_EX<=RegDst;
 AluSrc_ID_EX<=AluSrc;
 Branch_ID_EX<=Branch;
 Branch_NE_ID_EX<=Branch_NE;
 AluOp_ID_EX<=AluOp;
MemToReg_ID_EX<=MemToReg;
 MemWrite_ID_EX<=MemWrite;
 RegWrite_ID_EX<=RegWrite;
RD1_ID_EX<=rd1;
 RD2_ID_EX<=rd2;
 ext_imm_ID_EX<=ext_imm;
 func_ID_EX<=funct;
 sa_ID_EX<=sa;
RD_ID_EX<=rd;
 RT_ID_EX<=rt;
 pc_4_ID_EX<=pc_4_IF_ID;
   --EX_MEM----
 RegWrite_EX_MEM<=RegWrite_ID_EX;
 MemToReg_EX_MEM<=MemToReg_ID_EX;
 MemWrite_EX_MEM<=MemWrite_ID_EX;
 Branch_EX_MEM<=Branch_ID_EX;
 Branch_NE_EX_MEM<=Branch_NE_ID_EX;
 Branch_Address_EX_MEM<=Branch_Address;
 zero_EX_MEM<=zero;
 AluRes_EX_MEM<=alu_res;
RD2_EX_MEM<=RD2_ID_EX;
RD_EX_MEM<=rwa;
  ------mem_Wb-----
  MemToReg_MEM_WB<=MemToReg_EX_MEM;
 RegWrite_MEM_WB<=RegWrite_EX_MEM;
 AluRes_MEM_WB<=alu_res_out;
 RD_MEM_WB<=RD_EX_MEM;
 MemData_MEM_WB<=mem_data;
    end if;
  end if;
end process;


si1<= Branch_EX_MEM and zero_EX_MEM;
si2<=Branch_NE_EX_MEM and not(zero_EX_MEM);
pc_src<=si1 or si2;

jump_address<= pc_4_IF_ID(31 downto 28) & instruction_IF_ID(25 downto 0) &  "00";


mux: process(sw(7 downto 5),instruction,pc_4_out,rd1_ID_EX,rd2_ID_EX,ext_imm_ID_EX,alu_res,wd,mem_data)
begin
case sw(7 downto 5) is
when "000" => rez_mux<=instruction;
when "001" => rez_mux<=pc_4_out;
when "010" => rez_mux<=rd1_ID_EX;
when "011" => rez_mux<=rd2_ID_EX;
when "100" => rez_mux<=ext_imm_ID_EX;
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
    dispay: ssd_pipeline port map(clk, rez_mux, an, cat);


end Behavioral;