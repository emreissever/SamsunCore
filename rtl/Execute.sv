`timescale 1ns / 1ps
`include "../include/Definitions.vh"

module Execute
(
   input    logic                      clk_i                   ,
   input    logic                      rst_i                   ,

   output   logic                      ftch_flush_o            ,
   output   logic [31:0]               ftch_target_addr_o      ,

   input    logic [31:0]               decode_instr_i          ,
   input    logic [`CONTROL_BIT-1:0]   decode_control_i        ,
   input    logic [31:0]               decode_rs1_i            ,
   input    logic [31:0]               decode_rs2_i            ,
   input    logic [31:0]               decode_immediate_i      ,

   input    logic [ 4:0]               decode_rd_addr_i        ,
   input    logic [31:0]               decode_pc_i             ,
   input    logic [31:0]               decode_pcplus_i         ,

   output   logic                      decode_ready_o          ,

   // Memory Stage Interface  
   output   logic [`CONTROL_BIT-1:0]   mem_control_o           ,
   output   logic [31:0]               mem_aluResult_o         ,
   output   logic [31:0]               mem_data_o              ,

   output   logic [31:0]               mem_rd_addr_o           ,
   output   logic [31:0]               mem_pcplus_o            ,

   input    logic                      mem_ready_i             
);

wire [31:0] alu_result_w ;

wire [31:0] operand2_w = decode_control_i[15] ? decode_immediate_i : decode_rs2_i ;

ALU ALU_Execute
(
   .ctrl_i     (decode_control_i[`EXECOP]),
   .operand1_i (decode_rs1_i)             ,
   .operand2_i (operand2_w)               ,
   .result_o   (alu_result_w)
);

// BRANCH - JUMP LOGIC

assign ftch_target_addr_o  = decode_pc_i + decode_immediate_i ;

always_comb begin
   case (decode_control_i[`BRANCH])
      `BRANCH_EQ   : begin ftch_flush_o = alu_result_w[0]  ; end
      `BRANCH_NE   : begin ftch_flush_o = ~alu_result_w[0] ; end
      `BRANCH_LT   : begin ftch_flush_o = alu_result_w[0]  ; end
      `BRANCH_GE   : begin ftch_flush_o = ~alu_result_w[0] ; end
      `BRANCH_LTU  : begin ftch_flush_o = alu_result_w[0]  ; end
      `BRANCH_GEU  : begin ftch_flush_o = ~alu_result_w[0] ; end
      `BRANCH_JAL  : begin ftch_flush_o = alu_result_w[0]  ; end
      `BRANCH_JALR : begin ftch_flush_o = alu_result_w[0]  ; end
      default      : begin ftch_flush_o = 1'b0             ; end
   endcase
end

// SYNCHRONOUS LOGIC TO PIPELINING PAYLOAD //

always_ff @(posedge clk_i) begin 
   if (rst_i) begin
      mem_control_o     <= `CONTROL_NOP            ;
      mem_aluResult_o   <= 32'b0                   ;
      mem_data_o        <= 32'b0                   ;
      mem_rd_addr_o     <= 5'b0                    ;
      mem_pcplus_o      <= 32'b0                   ;
   end 
   else if (mem_ready_i) begin
      mem_control_o     <= decode_control_i        ;
      mem_aluResult_o   <= alu_result_w            ;
      mem_data_o        <= decode_rs2_i            ;
      mem_rd_addr_o     <= decode_rd_addr_i        ;
      mem_pcplus_o      <= decode_pcplus_i         ; 
   end
end

assign decode_ready_o = mem_ready_i ; 

endmodule
