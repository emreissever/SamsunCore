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

   // Execute Stage Interface 
   input    logic          br_taken_i              ,
   input    logic [31:0]   br_tgt_addr_i           ,

   //
   output   logic [12:0]   exec_ctrl_signal_o      ,
   output   logic [31:0]   exec_operand1_o         ,
   output   logic [31:0]   exec_operand2_o         ,
   output   logic [31:0]   exec_rs2_o              ,
   output   logic [ 4:0]   exec_rd_addr_o          ,
   output   logic [31:0]   exec_pc_o               ,
   input    logic          exec_flush_i            ,
   input    logic          exec_ready_i            ,

   input    wire [ 4:0]    wb_rd_addr_i            ,
   input    wire [31:0]    wb_rd_i                 ,
   input    wire           wb_rd_en_i              
);


// Fetch - Decode Stage Interface
logic [31:0]   decode_instr ;
logic [31:0]   decode_pc    ;
logic          fetch_ready  ;

Fetch Fetch_Core 
(
   .clk_i                  (clk_i                  ),
   .rst_i                  (rst_i                  ),
   .imem_request_pc_o      (imem_request_pc_o      ),
   .imem_response_pc_i     (imem_response_pc_i     ),
   .imem_response_instr_i  (imem_response_instr_i  ),
   .decode_instr_o         (decode_instr           ),
   .decode_pc_o            (decode_pc              ),
   .decode_ready_i         (fetch_ready            ),
   .br_taken_i             (br_taken_i             ),
   .br_tgt_addr_i          (br_tgt_addr_i          )
);

Decode Decode_Core
(
   .clk_i                  (clk_i                  ),
   .rst_i                  (rst_i                  ),
   .ftch_instr_i           (decode_instr           ),
   .ftch_pc_i              (decode_pc              ),
   .ftch_ready_o           (fetch_ready            ),
   .exec_ctrl_signal_o     (exec_ctrl_signal_o     ),
   .exec_operand1_o        (exec_operand1_o        ),
   .exec_operand2_o        (exec_operand2_o        ),
   .exec_rs2_o             (exec_rs2_o             ),
   .exec_rd_addr_o         (exec_rd_addr_o         ),
   .exec_pc_o              (exec_pc_o              ),
   .exec_flush_i           (exec_flush_i           ),
   .exec_ready_i           (exec_ready_i           ),
   .wb_rd_addr_i           (wb_rd_addr_i           ),
   .wb_rd_i                (wb_rd_i                ),
   .wb_rd_en_i             (wb_rd_en_i             )
);



endmodule
