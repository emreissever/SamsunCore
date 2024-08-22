`timescale 1ns / 1ps

`include "../include/Definitions.vh"

module Samsun_Core
(
   input    logic                      clk_i                   ,
   input    logic                      rst_i                   ,

   // Instruction Memory Interface Signals
   output   logic [31:0]               imem_request_pc_o       ,
   input    logic [31:0]               imem_response_pc_i      ,
   input    logic [31:0]               imem_response_instr_i   ,

   input    wire  [ 4:0]               wb_rd_addr_i            ,
   input    wire  [31:0]               wb_rd_i                 ,
   input    wire                       wb_rd_en_i              ,

   output   logic [`CONTROL_BIT-1:0]   mem_control_o           ,
   output   logic [31:0]               mem_aluResult_o         ,
   output   logic [31:0]               mem_data_o              ,
   output   logic [31:0]               mem_rd_addr_o           ,
   output   logic [31:0]               mem_pcplus_o            ,
   input    logic                      mem_ready_i             
);

// Fetch - Decode Stage Interface
logic [31:0]   decode_instr         ;
logic [31:0]   decode_pc            ;
logic [31:0]   decode_pcplus        ;
logic          fetch_ready          ;

//

logic                      br_taken          ;
logic [31:0]               br_tgt_addr       ;
logic [31:0]               exec_instr        ;
logic [`CONTROL_BIT-1:0]   exec_ctrl_signal  ;
logic [31:0]               exec_rs1          ;
logic [31:0]               exec_rs2          ;
logic [31:0]               exec_immediate    ;
logic [ 4:0]               exec_rd_addr      ;
logic [31:0]               exec_pc           ;
logic [31:0]               exec_pcplus       ;
logic                      exec_flush        ;
logic                      exec_ready        ;

Fetch Fetch_Core 
(
   .clk_i                  (clk_i                  ),
   .rst_i                  (rst_i                  ),

   .imem_request_pc_o      (imem_request_pc_o      ),
   .imem_response_pc_i     (imem_response_pc_i     ),
   .imem_response_instr_i  (imem_response_instr_i  ),

   .decode_instr_o         (decode_instr           ),
   .decode_pc_o            (decode_pc              ),
   .decode_pcplus_o        (decode_pcplus          ),
   .decode_ready_i         (fetch_ready            ),

   .br_taken_i             (br_taken               ),
   .br_tgt_addr_i          (br_tgt_addr            )
);

Decode Decode_Core
(
   .clk_i                  (clk_i                  ),
   .rst_i                  (rst_i                  ),

   .ftch_instr_i           (decode_instr           ),
   .ftch_pc_i              (decode_pc              ),
   .ftch_pcplus_i          (decode_pcplus          ),
   .ftch_ready_o           (fetch_ready            ),

   .exec_instr_o           (exec_instr             ),
   .exec_ctrl_signal_o     (exec_ctrl_signal       ),
   .exec_rs1_o             (exec_rs1               ),
   .exec_rs2_o             (exec_rs2               ),
   .exec_immediate_o       (exec_immediate         ),

   .exec_rd_addr_o         (exec_rd_addr           ),
   .exec_pc_o              (exec_pc                ),
   .exec_pcplus_o          (exec_pcplus            ),

   .exec_flush_i           (br_taken               ),
   .exec_ready_i           (decode_ready           ),

   .wb_rd_addr_i           (wb_rd_addr_i           ),
   .wb_rd_i                (wb_rd_i                ),
   .wb_rd_en_i             (wb_rd_en_i             )
);

Execute Execute_Core
(
   .clk_i                  (clk_i                  ),
   .rst_i                  (rst_i                  ),

   .ftch_flush_o           (br_taken               ),
   .ftch_target_addr_o     (br_tgt_addr            ),

   .decode_instr_i         (exec_instr             ),
   .decode_control_i       (exec_ctrl_signal       ),
   .decode_rs1_i           (exec_rs1               ),
   .decode_rs2_i           (exec_rs2               ),
   .decode_immediate_i     (exec_immediate         ),

   .decode_rd_addr_i       (exec_rd_addr           ),
   .decode_pc_i            (exec_pc                ),
   .decode_pcplus_i        (exec_pcplus            ),

   .decode_ready_o         (decode_ready           ),

   .mem_control_o          (mem_control_o          ),
   .mem_aluResult_o        (mem_aluResult_o        ),
   .mem_data_o             (mem_data_o             ),

   .mem_rd_addr_o          (mem_rd_addr_o          ),
   .mem_pcplus_o           (mem_pcplus_o           ),

   .mem_ready_i            (mem_ready_i            )
);

endmodule
