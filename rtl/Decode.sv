`timescale 1ns / 1ps
`include "../include/Definitions.vh"

module Decode
(
   input    logic                      clk_i                ,
   input    logic                      rst_i                ,

   // Fetch Stage Interface
   input    logic [31:0]               ftch_instr_i         ,
   input    logic [31:0]               ftch_pc_i            ,
   input    logic [31:0]               ftch_pcplus_i        ,
   output   logic                      ftch_ready_o         ,

   // Execute Stage Interface
   output   logic [31:0]               exec_instr_o         ,
   output   logic [`CONTROL_BIT-1:0]   exec_ctrl_signal_o   ,
   output   logic [31:0]               exec_rs1_o           ,
   output   logic [31:0]               exec_rs2_o           ,
   output   logic [31:0]               exec_immediate_o     ,

   output   logic [ 4:0]               exec_rd_addr_o       ,
   output   logic [31:0]               exec_pc_o            ,
   output   logic [31:0]               exec_pcplus_o        ,

   input    logic                      exec_flush_i         ,
   input    logic                      exec_ready_i         ,

   // Write-Back Stage Interface
   input    wire [ 4:0]                wb_rd_addr_i         ,
   input    wire [31:0]                wb_rd_i              ,
   input    wire                       wb_rd_en_i           
);

reg [31:0]  immediate_r ;
reg [2:0]   instruction_type_r ;

wire [31:0] rs1_w ;
wire [31:0] rs2_w ;

Base_RegFile RegFile_Decode 
(
   .clk_i       (clk_i)                ,
   .rst_i       (rst_i)                ,
   .rs1_addr_i  (ftch_instr_i[19:15])  ,
   .rs2_addr_i  (ftch_instr_i[24:20])  ,
   .rs1_o       (rs1_w)                ,
   .rs2_o       (rs2_w)                ,
   .rd_addr_i   (wb_rd_addr_i)         ,
   .rd_i        (wb_rd_i)              ,
   .wr_i        (wb_rd_en_i)
);

// INSTRUCTION DECODING 

// Bits required for decoding : Inst[30] Inst[14:12] Inst[6:2]
wire [`DECODE_INST_BIT-1 :0] decode_inst_w ; 
assign decode_inst_w = {ftch_instr_i[`CTRL_SIGN], ftch_instr_i[`CTRL_FUNCT3], ftch_instr_i[`CTRL_OPCODE5]};

reg [`CONTROL_BIT-1:0] ctrl_signal_r;

always @(*) begin
   casez(decode_inst_w)
      `DECODE_ADD    : begin ctrl_signal_r = `CONTROL_ADD    ; end 
      `DECODE_SUB    : begin ctrl_signal_r = `CONTROL_SUB    ; end 
      `DECODE_SLL    : begin ctrl_signal_r = `CONTROL_SLL    ; end 
      `DECODE_SLT    : begin ctrl_signal_r = `CONTROL_SLT    ; end 
      `DECODE_SLTU   : begin ctrl_signal_r = `CONTROL_SLTU   ; end 
      `DECODE_XOR    : begin ctrl_signal_r = `CONTROL_XOR    ; end 
      `DECODE_SRL    : begin ctrl_signal_r = `CONTROL_SRL    ; end 
      `DECODE_SRA    : begin ctrl_signal_r = `CONTROL_SRA    ; end 
      `DECODE_OR     : begin ctrl_signal_r = `CONTROL_OR     ; end 
      `DECODE_AND    : begin ctrl_signal_r = `CONTROL_AND    ; end 
      `DECODE_ADDI   : begin ctrl_signal_r = `CONTROL_ADDI   ; end 
      `DECODE_SLTI   : begin ctrl_signal_r = `CONTROL_SLTI   ; end 
      `DECODE_SLTIU  : begin ctrl_signal_r = `CONTROL_SLTIU  ; end 
      `DECODE_XORI   : begin ctrl_signal_r = `CONTROL_XORI   ; end 
      `DECODE_ORI    : begin ctrl_signal_r = `CONTROL_ORI    ; end 
      `DECODE_ANDI   : begin ctrl_signal_r = `CONTROL_ANDI   ; end 
      `DECODE_SLLI   : begin ctrl_signal_r = `CONTROL_SLLI   ; end 
      `DECODE_SRLI   : begin ctrl_signal_r = `CONTROL_SRLI   ; end 
      `DECODE_SRAI   : begin ctrl_signal_r = `CONTROL_SRAI   ; end 
      `DECODE_LB     : begin ctrl_signal_r = `CONTROL_LB     ; end 
      `DECODE_LH     : begin ctrl_signal_r = `CONTROL_LH     ; end 
      `DECODE_LW     : begin ctrl_signal_r = `CONTROL_LW     ; end 
      `DECODE_LBU    : begin ctrl_signal_r = `CONTROL_LBU    ; end 
      `DECODE_LHU    : begin ctrl_signal_r = `CONTROL_LHU    ; end 
      `DECODE_SB     : begin ctrl_signal_r = `CONTROL_SB     ; end 
      `DECODE_SH     : begin ctrl_signal_r = `CONTROL_SH     ; end 
      `DECODE_SW     : begin ctrl_signal_r = `CONTROL_SW     ; end 
      `DECODE_BEQ    : begin ctrl_signal_r = `CONTROL_BEQ    ; end 
      `DECODE_BNE    : begin ctrl_signal_r = `CONTROL_BNE    ; end 
      `DECODE_BLT    : begin ctrl_signal_r = `CONTROL_BLT    ; end 
      `DECODE_BGE    : begin ctrl_signal_r = `CONTROL_BGE    ; end 
      `DECODE_BLTU   : begin ctrl_signal_r = `CONTROL_BLTU   ; end 
      `DECODE_BGEU   : begin ctrl_signal_r = `CONTROL_BGEU   ; end 
      `DECODE_LUI    : begin ctrl_signal_r = `CONTROL_LUI    ; end 
      `DECODE_AUIPC  : begin ctrl_signal_r = `CONTROL_AUIPC  ; end 
      `DECODE_JAL    : begin ctrl_signal_r = `CONTROL_JAL    ; end 
      `DECODE_JALR   : begin ctrl_signal_r = `CONTROL_JALR   ; end 
      default        : begin ctrl_signal_r = `CONTROL_NOP    ; end // Bilinmeyen Instruction - Jump to Exception Handler (Handle)
   endcase
end

// IMMEDIATE GENERATOR

/* Instruciton[6:2]
R Type         = 01100
I Type         = 00100
I (Load) Type  = 00000
S Type         = 01000
B Type         = 11000
U (LUI) Type   = 01101
U (AUIPC) TYPE = 00101
J (JAL) Type   = 00101
J (JALR) Type  = 11001
-- 
*/

always_comb begin
   casez (ftch_instr_i[6:2])
      5'b01100 : begin instruction_type_r = `R_TYPE ; end // R-Type (NO Immediate for these instructions)
      5'b00?00 : begin instruction_type_r = `I_TYPE ; end // I-Type (Also Load Instructions)
      5'b01000 : begin instruction_type_r = `S_TYPE ; end 
      5'b11000 : begin instruction_type_r = `B_TYPE ; end
      5'b0?101 : begin instruction_type_r = `U_TYPE ; end
      5'b00101 : begin instruction_type_r = `J_TYPE ; end 
      5'b11001 : begin instruction_type_r = `I_TYPE ; end // JALR Instruction (Same as I-Type)
      default  : begin instruction_type_r = `R_TYPE ; end // nop instruction için bir handler lazım 
   endcase

   case (instruction_type_r)
      `I_TYPE  : begin immediate_r = { {21{ftch_instr_i[31]}}, ftch_instr_i[30:25], ftch_instr_i[24:21], ftch_instr_i[20]                                    }; end 
      `S_TYPE  : begin immediate_r = { {21{ftch_instr_i[31]}}, ftch_instr_i[30:25], ftch_instr_i[11:8] , ftch_instr_i[7]                                     }; end 
      `B_TYPE  : begin immediate_r = { {20{ftch_instr_i[31]}}, ftch_instr_i[7]    , ftch_instr_i[30:25], ftch_instr_i[11:8], {1{1'b0}}                       }; end 
      `U_TYPE  : begin immediate_r = {     ftch_instr_i[31]  , ftch_instr_i[30:20], ftch_instr_i[19:12], {12{1'b0}}                                         }; end 
      `J_TYPE  : begin immediate_r = { {12{ftch_instr_i[31]}}, ftch_instr_i[19:12], ftch_instr_i[20]   , ftch_instr_i[30:25], ftch_instr_i[24:21], {1{1'b0}}  }; end 
      default  : begin immediate_r = 32'hZZZZZZZZ; end
   endcase
end

// SYNCHRONOUS LOGIC TO PIPELINING PAYLOAD //

always_ff @(posedge clk_i) begin
   if (rst_i) begin
      exec_instr_o         <= `I_NOP                  ;
      exec_ctrl_signal_o   <= `CONTROL_NOP            ;
      exec_pc_o            <= `BOOT_ADDR              ;
      exec_pcplus_o        <= 32'b0                   ;
      exec_rd_addr_o       <= 5'b0                    ;
      exec_rs1_o           <= 32'b0                   ;
      exec_rs2_o           <= 32'b0                   ;
      exec_immediate_o     <= 32'b0                   ;
   end
   else if (exec_flush_i) begin
      exec_instr_o         <= `I_NOP                  ;
      exec_ctrl_signal_o   <= `CONTROL_NOP            ;
      exec_pc_o            <= `BOOT_ADDR              ;
      exec_pcplus_o        <= 32'b0                   ;
      exec_rd_addr_o       <= 5'b0                    ;
      exec_rs1_o           <= 32'b0                   ;
      exec_rs2_o           <= 32'b0                   ;
      exec_immediate_o     <= 32'b0                   ;
   end
   else if(exec_ready_i) begin
      exec_instr_o         <= ftch_instr_i            ;
      exec_ctrl_signal_o   <= ctrl_signal_r           ;
      exec_pc_o            <= ftch_pc_i               ;
      exec_pcplus_o        <= ftch_pcplus_i           ;
      exec_rd_addr_o       <= ftch_instr_i[11:7]      ;
      exec_rs1_o           <= rs1_w                   ;
      exec_rs2_o           <= rs2_w                   ;
      exec_immediate_o     <= immediate_r             ;
   end
end

assign ftch_ready_o = exec_ready_i ;

// DEBUGGING // 
`ifdef DEBUG
   reg[13*8:0] debug_reg ;
   always_comb begin
      casez(decode_inst_w)
         `DECODE_ADD    : begin debug_reg = "`CONTROL_ADD  "  ; end 
         `DECODE_SUB    : begin debug_reg = "`CONTROL_SUB  "  ; end 
         `DECODE_SLL    : begin debug_reg = "`CONTROL_SLL  "  ; end 
         `DECODE_SLT    : begin debug_reg = "`CONTROL_SLT  "  ; end 
         `DECODE_SLTU   : begin debug_reg = "`CONTROL_SLTU "  ; end 
         `DECODE_XOR    : begin debug_reg = "`CONTROL_XOR  "  ; end 
         `DECODE_SRL    : begin debug_reg = "`CONTROL_SRL  "  ; end 
         `DECODE_SRA    : begin debug_reg = "`CONTROL_SRA  "  ; end 
         `DECODE_OR     : begin debug_reg = "`CONTROL_OR   "  ; end 
         `DECODE_AND    : begin debug_reg = "`CONTROL_AND  "  ; end 
         `DECODE_ADDI   : begin debug_reg = "`CONTROL_ADDI "  ; end 
         `DECODE_SLTI   : begin debug_reg = "`CONTROL_SLTI "  ; end 
         `DECODE_SLTIU  : begin debug_reg = "`CONTROL_SLTIU"  ; end 
         `DECODE_XORI   : begin debug_reg = "`CONTROL_XORI "  ; end 
         `DECODE_ORI    : begin debug_reg = "`CONTROL_ORI  "  ; end 
         `DECODE_ANDI   : begin debug_reg = "`CONTROL_ANDI "  ; end 
         `DECODE_SLLI   : begin debug_reg = "`CONTROL_SLLI "  ; end 
         `DECODE_SRLI   : begin debug_reg = "`CONTROL_SRLI "  ; end 
         `DECODE_SRAI   : begin debug_reg = "`CONTROL_SRAI "  ; end 
         `DECODE_LB     : begin debug_reg = "`CONTROL_LB   "  ; end 
         `DECODE_LH     : begin debug_reg = "`CONTROL_LH   "  ; end 
         `DECODE_LW     : begin debug_reg = "`CONTROL_LW   "  ; end 
         `DECODE_LBU    : begin debug_reg = "`CONTROL_LBU  "  ; end 
         `DECODE_LHU    : begin debug_reg = "`CONTROL_LHU  "  ; end 
         `DECODE_SB     : begin debug_reg = "`CONTROL_SB   "  ; end 
         `DECODE_SH     : begin debug_reg = "`CONTROL_SH   "  ; end 
         `DECODE_SW     : begin debug_reg = "`CONTROL_SW   "  ; end 
         `DECODE_BEQ    : begin debug_reg = "`CONTROL_BEQ  "  ; end 
         `DECODE_BNE    : begin debug_reg = "`CONTROL_BNE  "  ; end 
         `DECODE_BLT    : begin debug_reg = "`CONTROL_BLT  "  ; end 
         `DECODE_BGE    : begin debug_reg = "`CONTROL_BGE  "  ; end 
         `DECODE_BLTU   : begin debug_reg = "`CONTROL_BLTU "  ; end 
         `DECODE_BGEU   : begin debug_reg = "`CONTROL_BGEU "  ; end 
         `DECODE_LUI    : begin debug_reg = "`CONTROL_LUI  "  ; end 
         `DECODE_AUIPC  : begin debug_reg = "`CONTROL_AUIPC"  ; end 
         `DECODE_JAL    : begin debug_reg = "`CONTROL_JAL  "  ; end 
         `DECODE_JALR   : begin debug_reg = "`CONTROL_JALR "  ; end 
         default        : begin debug_reg = "`UNDEFINED    "  ; end // Bilinmeyen Instruction - Jump to Exception Handler (Handle)
      endcase
   end
`endif

endmodule
