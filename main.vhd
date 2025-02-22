library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use std.textio.all;

entity main is end;

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
            address: in std_logic_vector(11 downto 0);
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

    begin


    end Uniciclo;

        