`define DEBUG

`define BOOT_ADDR  32'h00_00_00_00

// RV32I Instructions = 37 Instructions 

`define I_NOP        32'b0000000_00000_00000_000_00000_0000000

`define I_ADD        32'b0000000_?????_?????_000_?????_0110011
`define I_SUB        32'b0100000_?????_?????_000_?????_0110011
`define I_SLL        32'b0000000_?????_?????_001_?????_0110011
`define I_SLT        32'b0000000_?????_?????_010_?????_0110011
`define I_SLTU       32'b0000000_?????_?????_011_?????_0110011
`define I_XOR        32'b0000000_?????_?????_100_?????_0110011
`define I_SRL        32'b0000000_?????_?????_101_?????_0110011
`define I_SRA        32'b0100000_?????_?????_101_?????_0110011
`define I_OR         32'b0000000_?????_?????_110_?????_0110011
`define I_AND        32'b0000000_?????_?????_111_?????_0110011

`define I_ADDI       32'b???????_?????_?????_000_?????_0010011
`define I_SLTI       32'b???????_?????_?????_010_?????_0010011
`define I_SLTIU      32'b???????_?????_?????_011_?????_0010011
`define I_XORI       32'b???????_?????_?????_100_?????_0010011
`define I_ORI        32'b???????_?????_?????_110_?????_0010011
`define I_ANDI       32'b???????_?????_?????_111_?????_0010011
`define I_SLLI       32'b0000000_?????_?????_001_?????_0010011
`define I_SRLI       32'b0000000_?????_?????_101_?????_0010011
`define I_SRAI       32'b0100000_?????_?????_101_?????_0010011

`define I_LB         32'b???????_?????_?????_000_?????_0000011
`define I_LH         32'b???????_?????_?????_001_?????_0000011
`define I_LW         32'b???????_?????_?????_010_?????_0000011
`define I_LBU        32'b???????_?????_?????_100_?????_0000011
`define I_LHU        32'b???????_?????_?????_101_?????_0000011

`define I_SB         32'b???????_?????_?????_000_?????_0100011
`define I_SH         32'b???????_?????_?????_001_?????_0100011
`define I_SW         32'b???????_?????_?????_010_?????_0100011

`define I_BEQ        32'b???????_?????_?????_000_?????_1100011
`define I_BNE        32'b???????_?????_?????_000_?????_1100011
`define I_BLT        32'b???????_?????_?????_000_?????_1100011
`define I_BGE        32'b???????_?????_?????_000_?????_1100011
`define I_BLTU       32'b???????_?????_?????_000_?????_1100011
`define I_BGEU       32'b???????_?????_?????_000_?????_1100011
`define I_LUI        32'b???????_?????_?????_???_?????_0110111
`define I_AUIPC      32'b???????_?????_?????_???_?????_0010111
`define I_JAL        32'b???????_?????_?????_???_?????_1101111
`define I_JALR       32'b???????_?????_?????_000_?????_1100111

// Decoding Instruction

// Inst[30] Inst[14:12] Inst[6:2] = 9 Bits

`define DECODE_INST_BIT 9 

`define CTRL_SIGN       30
`define CTRL_FUNCT3     14:12
`define CTRL_OPCODE5    6:2

`define R_TYPE 3'b000
`define I_TYPE 3'b001
`define S_TYPE 3'b010
`define B_TYPE 3'b011
`define U_TYPE 3'b100
`define J_TYPE 3'b101

`define DECODE_ADD      9'b000001100
`define DECODE_SUB      9'b100001100
`define DECODE_SLL      9'b000101100
`define DECODE_SLT      9'b001001100
`define DECODE_SLTU     9'b001101100
`define DECODE_XOR      9'b010001100
`define DECODE_SRL      9'b010101100
`define DECODE_SRA      9'b110101100
`define DECODE_OR       9'b011001100
`define DECODE_AND      9'b011101100

`define DECODE_ADDI     9'b?00000100
`define DECODE_SLTI     9'b?01000100
`define DECODE_SLTIU    9'b?01100100
`define DECODE_XORI     9'b?10000100
`define DECODE_ORI      9'b?11000100
`define DECODE_ANDI     9'b?11100100
`define DECODE_SLLI     9'b000100100
`define DECODE_SRLI     9'b010100100
`define DECODE_SRAI     9'b010100100

`define DECODE_LB       9'b?00000000
`define DECODE_LH       9'b?00100000
`define DECODE_LW       9'b?01000000
`define DECODE_LBU      9'b?10000000
`define DECODE_LHU      9'b?10100000

`define DECODE_SB       9'b?00001000
`define DECODE_SH       9'b?00101000
`define DECODE_SW       9'b?01001000

`define DECODE_BEQ      9'b?00011000
`define DECODE_BNE      9'b?00011000
`define DECODE_BLT      9'b?00011000
`define DECODE_BGE      9'b?00011000
`define DECODE_BLTU     9'b?00011000
`define DECODE_BGEU     9'b?00011000

`define DECODE_LUI      9'b????01101
`define DECODE_AUIPC    9'b????00101
`define DECODE_JAL      9'b????11011
`define DECODE_JALR     9'b?00011001


// Control Signal Definitions // 

`define CONTROL_BIT 15

`define WB        1:0   // 2 Bit
`define REGEN     2:2   // 1 Bit 

`define EXECOP    6:3   // 4 Bit 
`define BRANCH    9:7   // 3 Bit 
`define MEMACC    12:10 // 3 Bit 

`define OPERAND   14:13 // 2 Bit 

`define OPERAND_REG   2'b00
`define OPERAND_IMM   2'b01
`define OPERAND_PC    2'b10
`define OPERAND_PCIMM 2'b11

`define MEMACC_NONE     3'h0
`define MEMACC_LW       3'h0
`define MEMACC_LH       3'h1
`define MEMACC_LHU      3'h2
`define MEMACC_LB       3'h3
`define MEMACC_LBU      3'h4
`define MEMACC_SW       3'h5
`define MEMACC_SH       3'h6
`define MEMACC_SB       3'h7

`define BRANCH_NONE  3'b000
`define BRANCH_EQ    3'b001
`define BRANCH_NE    3'b011
`define BRANCH_LT    3'b100
`define BRANCH_GE    3'b101
`define BRANCH_LTU   3'b110
`define BRANCH_GEU   3'b111
`define BRANCH_JAL   3'b010 // AYNI
`define BRANCH_JALR  3'b010 // AYNI

`define EXECOP_NONE   4'ha
`define EXECOP_ADD    4'h0
`define EXECOP_SUB    4'h1
`define EXECOP_SLL    4'h2
`define EXECOP_SLT    4'h3
`define EXECOP_SLTU   4'h4
`define EXECOP_XOR    4'h5
`define EXECOP_SRL    4'h6
`define EXECOP_SRA    4'h7
`define EXECOP_OR     4'h8
`define EXECOP_AND    4'h9
// GEÇİR? -> LUI İÇİN 

`define REGEN_NOTWRITE 1'b0
`define REGEN_WRITE    1'b1

`define WB_NONE      2'b00
`define WB_ALURESULT 2'b01
`define WB_PCPLUS    2'b10

// // // 
`define CONTROL_NOP           {`OPERAND_REG, `MEMACC_NONE, `BRANCH_NONE, `EXECOP_NONE , `REGEN_NOTWRITE, `WB_NONE}
`define CONTORL_NOP_TOEXECUTE {`MEMACC_NONE, `BRANCH_NONE, `EXECOP_NONE , `REGEN_NOTWRITE, `WB_NONE}

`define CONTROL_ADD     {`OPERAND_REG, `MEMACC_NONE, `BRANCH_NONE, `EXECOP_ADD , `REGEN_WRITE, `WB_ALURESULT}
`define CONTROL_SUB     {`OPERAND_REG, `MEMACC_NONE, `BRANCH_NONE, `EXECOP_SUB , `REGEN_WRITE, `WB_ALURESULT}
`define CONTROL_SLL     {`OPERAND_REG, `MEMACC_NONE, `BRANCH_NONE, `EXECOP_SLL , `REGEN_WRITE, `WB_ALURESULT}
`define CONTROL_SLT     {`OPERAND_REG, `MEMACC_NONE, `BRANCH_NONE, `EXECOP_SLT , `REGEN_WRITE, `WB_ALURESULT}
`define CONTROL_SLTU    {`OPERAND_REG, `MEMACC_NONE, `BRANCH_NONE, `EXECOP_SLTU, `REGEN_WRITE, `WB_ALURESULT}
`define CONTROL_XOR     {`OPERAND_REG, `MEMACC_NONE, `BRANCH_NONE, `EXECOP_XOR , `REGEN_WRITE, `WB_ALURESULT}
`define CONTROL_SRL     {`OPERAND_REG, `MEMACC_NONE, `BRANCH_NONE, `EXECOP_SRL , `REGEN_WRITE, `WB_ALURESULT}
`define CONTROL_SRA     {`OPERAND_REG, `MEMACC_NONE, `BRANCH_NONE, `EXECOP_SRA , `REGEN_WRITE, `WB_ALURESULT}
`define CONTROL_OR      {`OPERAND_REG, `MEMACC_NONE, `BRANCH_NONE, `EXECOP_OR  , `REGEN_WRITE, `WB_ALURESULT}
`define CONTROL_AND     {`OPERAND_REG, `MEMACC_NONE, `BRANCH_NONE, `EXECOP_AND , `REGEN_WRITE, `WB_ALURESULT}
//
`define CONTROL_LUI     {`OPERAND_IMM  , `MEMACC_NONE, `BRANCH_NONE, `EXECOP_NONE, `REGEN_WRITE, `WB_ALURESULT}
`define CONTROL_AUIPC   {`OPERAND_PCIMM, `MEMACC_NONE, `BRANCH_NONE, `EXECOP_ADD , `REGEN_WRITE, `WB_ALURESULT}

`define CONTROL_ADDI    {`OPERAND_IMM, `MEMACC_NONE, `BRANCH_NONE, `EXECOP_ADD , `REGEN_WRITE, `WB_ALURESULT}
`define CONTROL_SLLI    {`OPERAND_IMM, `MEMACC_NONE, `BRANCH_NONE, `EXECOP_SLL , `REGEN_WRITE, `WB_ALURESULT}
`define CONTROL_SLTI    {`OPERAND_IMM, `MEMACC_NONE, `BRANCH_NONE, `EXECOP_SLT , `REGEN_WRITE, `WB_ALURESULT}
`define CONTROL_SLTIU   {`OPERAND_IMM, `MEMACC_NONE, `BRANCH_NONE, `EXECOP_SLTU, `REGEN_WRITE, `WB_ALURESULT}
`define CONTROL_XORI    {`OPERAND_IMM, `MEMACC_NONE, `BRANCH_NONE, `EXECOP_XOR , `REGEN_WRITE, `WB_ALURESULT}
`define CONTROL_SRLI    {`OPERAND_IMM, `MEMACC_NONE, `BRANCH_NONE, `EXECOP_SRL , `REGEN_WRITE, `WB_ALURESULT}
`define CONTROL_SRAI    {`OPERAND_IMM, `MEMACC_NONE, `BRANCH_NONE, `EXECOP_SRA , `REGEN_WRITE, `WB_ALURESULT}
`define CONTROL_ORI     {`OPERAND_IMM, `MEMACC_NONE, `BRANCH_NONE, `EXECOP_OR  , `REGEN_WRITE, `WB_ALURESULT}
`define CONTROL_ANDI    {`OPERAND_IMM, `MEMACC_NONE, `BRANCH_NONE, `EXECOP_AND , `REGEN_WRITE, `WB_ALURESULT}

// HATALI ATAMA OLABİLİR 
`define CONTROL_LB      {`OPERAND_IMM, `MEMACC_LB , `BRANCH_NONE, `EXECOP_NONE, `REGEN_WRITE   , `WB_ALURESULT}
`define CONTROL_LH      {`OPERAND_IMM, `MEMACC_LH , `BRANCH_NONE, `EXECOP_NONE, `REGEN_WRITE   , `WB_ALURESULT}
`define CONTROL_LW      {`OPERAND_IMM, `MEMACC_LW , `BRANCH_NONE, `EXECOP_NONE, `REGEN_WRITE   , `WB_ALURESULT}
`define CONTROL_LBU     {`OPERAND_IMM, `MEMACC_LBU, `BRANCH_NONE, `EXECOP_NONE, `REGEN_WRITE   , `WB_ALURESULT}
`define CONTROL_LHU     {`OPERAND_IMM, `MEMACC_LHU, `BRANCH_NONE, `EXECOP_NONE, `REGEN_WRITE   , `WB_ALURESULT}
`define CONTROL_SB      {`OPERAND_IMM, `MEMACC_SB , `BRANCH_NONE, `EXECOP_NONE, `REGEN_NOTWRITE, `WB_ALURESULT}
`define CONTROL_SH      {`OPERAND_IMM, `MEMACC_SH , `BRANCH_NONE, `EXECOP_NONE, `REGEN_NOTWRITE, `WB_ALURESULT}
`define CONTROL_SW      {`OPERAND_IMM, `MEMACC_SW , `BRANCH_NONE, `EXECOP_NONE, `REGEN_NOTWRITE, `WB_ALURESULT}

`define CONTROL_BEQ     {`OPERAND_PCIMM, `MEMACC_NONE, `BRANCH_EQ , `EXECOP_ADD, `REGEN_NOTWRITE, `WB_ALURESULT}
`define CONTROL_BNE     {`OPERAND_PCIMM, `MEMACC_NONE, `BRANCH_NE , `EXECOP_ADD, `REGEN_NOTWRITE, `WB_ALURESULT}
`define CONTROL_BLT     {`OPERAND_PCIMM, `MEMACC_NONE, `BRANCH_LT , `EXECOP_ADD, `REGEN_NOTWRITE, `WB_ALURESULT}
`define CONTROL_BGE     {`OPERAND_PCIMM, `MEMACC_NONE, `BRANCH_GE , `EXECOP_ADD, `REGEN_NOTWRITE, `WB_ALURESULT}
`define CONTROL_BLTU    {`OPERAND_PCIMM, `MEMACC_NONE, `BRANCH_LTU, `EXECOP_ADD, `REGEN_NOTWRITE, `WB_ALURESULT}
`define CONTROL_BGEU    {`OPERAND_PCIMM, `MEMACC_NONE, `BRANCH_GEU, `EXECOP_ADD, `REGEN_NOTWRITE, `WB_ALURESULT}
//PC PLUS YERİNE DEĞİŞKEN ADI PC OLMALI SANIYORUM Kİ ! 
`define CONTROL_JAL     {`OPERAND_PCIMM, `MEMACC_NONE, `BRANCH_JAL , `EXECOP_ADD, `REGEN_WRITE, `WB_PCPLUS}
`define CONTROL_JALR    {`OPERAND_IMM  , `MEMACC_NONE, `BRANCH_JALR, `EXECOP_ADD, `REGEN_WRITE, `WB_PCPLUS}


// Forwarding Constants !! 
`define FORWARD_WB   2'b00
`define FORWARD_EXEC 2'b01
`define FORWARD_NONE 2'b10


// Instruction Types
`define R_TYPE 3'b000
`define I_TYPE 3'b001
`define S_TYPE 3'b010
`define B_TYPE 3'b011
`define U_TYPE 3'b100
`define J_TYPE 3'b101