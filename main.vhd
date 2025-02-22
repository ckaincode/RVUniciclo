library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use std.textio.all;

entity main is
    port(
        clock: in std_logic
    );
end main;

architecture Uniciclo of main is

    component ALUCtrl is
        port(
            ALUOp: in std_logic_vector(1 downto 0);
            funct3: in std_logic_vector(2 downto 0);
            bit_30: in std_logic;
            ALUCode: out std_logic_vector(3 downto 0)
        );
    end component;
    
    component control is
        port(
            op: in std_logic_vector(6 downto 0);
            Branch,MemtoReg,MemWR,RegWR: out std_logic;
            ALUSrc1: out std_logic; --XREGS1 ou PC/ XREGS2 ou Imm
            ALUSrc2 : out std_logic_vector(1 downto 0); -- XREGS2 ou Imm ou Imm << 1
            JALs,JALRs : out std_logic;
            ALUOp: out std_logic_vector(1 downto 0);
            RegSrc: out std_logic_vector (1 downto 0) -- WB ou Imm ou PC+4
        );
    end component;

    component genImm32 is
        port (
            instr : in std_logic_vector(31 downto 0);
            imm32 : out signed(31 downto 0)
        );
    end component;

    component mux2x1 is
        port(
            d0,d1 : in std_logic_vector (31 downto 0);
            s: in std_logic;
            outputv : out std_logic_vector (31 downto 0)
        );
    end component;

    component mux4x1 is
        port(
            d0,d1,d2,d3 : in std_logic_vector (31 downto 0);
            s: in std_logic_vector(1 downto 0);
            outputv : out std_logic_vector (31 downto 0)
        );
    end component;

    component PC is
        port(
            clk : in std_logic;
            next_pc : in std_logic_vector (31 downto 0);
            current : out std_logic_vector (31 downto 0)
        );
    end component;
    
    component RAM_RV is
        port (
            clck      : in std_logic;               
            we        : in std_logic;               
            byte_en   : in std_logic;               
            sgn_en    : in std_logic;               
            address   : in std_logic_vector(13 downto 0); 
            datain    : in std_logic_vector(31 downto 0); 
            dataout   : out std_logic_vector(31 downto 0) 
        );
    end component;
    
    component XREGS is
        generic (WSIZE : natural := 32);
        port (
          clk, wren : in std_logic;
          rs1, rs2, rd : in std_logic_vector(4 downto 0);
          data : in std_logic_vector(WSIZE-1 downto 0);
          ro1, ro2 : out std_logic_vector(WSIZE-1 downto 0)
        );
      end component;

    component ROM_RV is
        port(
            address: in std_logic_vector(9 downto 0);
            dataout: out std_logic_vector(31 downto 0)
            );
        end component;

    component ulaRV is
	port (
		opcode : in std_logic_vector(3 downto 0);
		A, B : in std_logic_vector(31 downto 0);
		Z : out std_logic_vector(31 downto 0);
		cond : out std_logic);
        end component;

    component adder is
        port(
            arg1,arg2: in std_logic_vector(31 downto 0);
            sout : out std_logic_vector(31 downto 0)
        );
    end component;

    signal s_instruction : std_logic_vector (31 downto 0);
    signal s_PC : std_logic_vector (31 downto 0);
    signal s_PC4_ALU : std_logic_vector (31 downto 0);
    signal s_PCBranch_ALU : std_logic_vector (31 downto 0);
    signal s_PC4orBranch : std_logic_vector (31 downto 0);
    signal s_NextPC: std_logic_vector (31 downto 0);
    signal s_JALR_PC: std_logic_vector (31 downto 0);
    signal s_ALU: std_logic_vector (31 downto 0);
    signal s_Mem: std_logic_vector (31 downto 0);
    signal s_WrBack,s_WrData: std_logic_vector (31 downto 0);
    signal s_Imm: signed (31 downto 0);
    signal s_Immv: std_logic_vector(31 downto 0);
    signal s_ImmShifted:std_logic_vector (31 downto 0);
    signal s_rd1,s_rd2: std_logic_vector (31 downto 0);
    signal s_ALUArg1,s_ALUArg2: std_logic_vector (31 downto 0);

    signal s_ramaddr: std_logic_vector(13 downto 0);
    signal s_romaddr: std_logic_vector(9 downto 0);
    signal s_Opcode: std_logic_vector (6 downto 0);
    signal s_rs1,s_rs2,s_rd: std_logic_vector(4 downto 0);
    signal s_ALUOp: std_logic_vector (1 downto 0);
    signal s_ALUOpCode: std_logic_vector(3 downto 0);
    signal s_func3: std_logic_vector (2 downto 0);
    signal s_AluSrc2: std_logic_vector(1 downto 0);
    signal s_RegSrc: std_logic_vector(1 downto 0);

    signal s_AluSrc1: std_logic;
    signal s_ALUZero: std_logic;
    signal s_bit30: std_logic;
    signal s_byteen,s_sgnen : std_logic;
    signal s_branch,s_jal,s_jalr : std_logic;
    signal s_condbranch: std_logic;
    signal s_memwr,s_regwr : std_logic;
    signal s_mem2reg: std_logic;
    signal clk: std_logic;   

begin

    muxpc : mux2x1 port map(s_PC4orBranch,s_JALR_PC,s_jalr,s_NextPC);
    pcinst: PC port map(clk,s_NextPC,s_PC);
    pc4adder: adder port map(s_PC,x"00000004",s_PC4_ALU);
    pcbranchadder: adder port map(s_PC,s_ImmShifted,s_PCBranch_ALU);
    muxbranch: mux2x1 port map(s_PC4_ALU,s_PCBranch_ALU,s_condbranch,s_PC4orBranch);
    registers: XREGS port map(clk,s_regwr,s_rs1,s_rs2,s_rd,s_WrData,s_rd1,s_rd2);
    muxregsrc: mux4x1 port map(s_WrBack,s_Immv,s_PC4_ALU,x"00000000",s_RegSrc,s_WrData);
    immg: genImm32 port map(s_instruction,s_Imm);
    muxmemout: mux2x1 port map(s_ALU,s_Mem,s_mem2reg,s_WrBack);
    muxula1: mux2x1 port map(s_rd1,s_PC,s_ALUSrc1,s_ALUArg1);
    muxula2: mux4x1 port map(s_rd2,s_Immv,s_ImmShifted,x"00000000",s_ALUSrc2,s_ALUArg2);
    aluctr: AluCtrl port map(s_ALUOp,s_func3,s_bit30,s_ALUOpCode);
    mainALU: ulaRV port map(s_ALUOpCode,s_ALUArg1,s_ALUArg2,s_ALU,s_ALUZero);
    mainCtrl: control port map(s_Opcode,s_branch,s_mem2reg,s_memwr,s_regwr,s_ALUSrc1,s_ALUSrc2,s_jal,
    s_jalr,s_ALUOp,s_RegSrc);
    ROM: ROM_RV port map(s_romaddr,s_instruction);
    RAM: RAM_RV port map(clk,s_memwr,s_byteen,s_sgnen,s_ramaddr,s_rd2,s_Mem);

    clk <= clock;
    s_Immv <= std_logic_vector(s_Imm);
    s_ImmShifted <= std_logic_vector(shift_left(s_Imm,1));
    s_JALR_PC <= s_ALU(31 downto 1)&'0';
    s_condbranch <= (s_branch and s_ALUZero) or s_jal;
    s_byteen <= (not s_instruction(13));
    s_sgnen <= (not s_instruction(14));
    s_rs1 <= s_instruction(19 downto 15);
    s_rs2 <= s_instruction(24 downto 20);
    s_rd <= s_instruction(11 downto 7);
    s_Opcode <= s_instruction(6 downto 0);
    s_bit30 <= s_instruction(30);
    s_func3 <= s_instruction(14 downto 12);
    s_romaddr <= s_PC(11 downto 2);
    s_ramaddr <= s_ALU(13 downto 0);

end Uniciclo;

        