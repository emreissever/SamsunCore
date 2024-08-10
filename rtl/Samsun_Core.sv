`timescale 1ns / 1ps

`include "../include/Definitions.vh"

module Samsun_Core
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
   input    logic          decode_ready_i          ,

   // Execute Stage Interface 
   input    logic          br_taken_i              ,
   input    logic [31:0]   br_tgt_addr_i  
);


Fetch Fetch_Core (.*);


endmodule
