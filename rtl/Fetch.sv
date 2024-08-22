`timescale 1ns / 1ps

`include "../include/Definitions.vh"

module Fetch
# (parameter BOOT_ADDR = 32'h00_00_00_00)
(
   input    logic          clk_i                   ,
   input    logic          rst_i                   ,

   // Instruction Memory Interface Signals
   output   logic [31:0]   imem_request_pc_o       ,

   input    logic [31:0]   imem_response_pc_i      ,
   input    logic [31:0]   imem_response_instr_i   ,

   // Decode Stage Interface
   output   logic [31:0]   decode_instr_o          ,
   output   logic [31:0]   decode_pc_o             ,
   output   logic [31:0]   decode_pcplus_o         ,
   input    logic          decode_ready_i          ,

   // Execute Stage Interface 
   input    logic          br_taken_i              ,
   input    logic [31:0]   br_tgt_addr_i           
);

logic          rst_flag       ;

logic [31:0]   pc_reg         ;
logic [31:0]   pc_plus        ;

// PROGRAM COUNTER GENERATION LOGIC //

assign pc_plus = rst_flag ? BOOT_ADDR : pc_reg + 4 ;

always_ff @(posedge clk_i) begin : PC_GenerationLogic
   if (rst_i) begin
      pc_reg         <= BOOT_ADDR      ;
      rst_flag       <= 1'b1           ;
   end else if (br_taken_i) begin 
      pc_reg         <= br_tgt_addr_i  ;
   end else if (decode_ready_i) begin 
      pc_reg         <= pc_plus        ;
      rst_flag       <= 1'b0           ;
   end
end

// SYNCHRONOUS LOGIC TO PIPELINING PAYLOAD // 

always_ff @(posedge clk_i) begin : Pipelining_Payload
   if (rst_i) begin
      decode_instr_o    <= `I_NOP                  ;
      decode_pc_o       <= `BOOT_ADDR              ;
      decode_pcplus_o   <= 32'b0                   ;
   end else if (br_taken_i && ~rst_flag) begin
      decode_instr_o    <= `I_NOP                  ;
      decode_pc_o       <= br_tgt_addr_i           ;
      decode_pcplus_o   <= 32'b0                   ;
   end else if (decode_ready_i && ~rst_flag) begin
      decode_instr_o    <= imem_response_instr_i   ;
      decode_pc_o       <= imem_response_pc_i      ;
      decode_pcplus_o   <= pc_plus                 ;
   end
end

assign imem_request_pc_o = pc_reg                  ;

endmodule