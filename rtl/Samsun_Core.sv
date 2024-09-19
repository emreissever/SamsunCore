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

   // Data Memory Interface Signals
   output   logic                      dmem_wen_o              ,
   output   logic [31:0]               dmem_addr_o             ,
   output   logic [31:0]               dmem_wdata_o            ,
   input    logic [31:0]               dmem_rdata_i            
);

// Fetch - Decode Stage Interface
logic [31:0]               decode_instr      ;
logic [31:0]               decode_pc         ;
logic [31:0]               decode_pcplus     ;
logic                      fetch_ready       ;

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
logic                      exec_ready        ;

//

logic [31:0]               mem_instr         ;
logic [`CONTROL_BIT-1:0]   mem_control       ;
logic [31:0]               mem_aluResult     ;
logic [31:0]               mem_data          ;
logic [31:0]               mem_rd_addr       ;
logic [31:0]               mem_pcplus        ;
logic                      mem_ready         ;

wire  [ 4:0]               decode_rd_addr    ;
wire  [31:0]               decode_rd         ;
wire                       decode_rd_en      ;


logic [31:0]               wb_instr          ;
logic [`CONTROL_BIT-1:0]   wb_control        ;
logic [31:0]               wb_aluResult      ;
logic [31:0]               wb_readData       ;
logic [31:0]               wb_rd_addr        ;
logic [31:0]               wb_pcplus         ;

logic stall       ;
logic fetch_flush ; 

logic exec_flush ;

logic monitor_load_o ;

// // 

logic [4:0]                decode_rs1_addr   ;
logic [4:0]                decode_rs2_addr   ;

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

   .br_taken_i             (br_taken               ),
   .br_tgt_addr_i          (br_tgt_addr            ),
   .stall_i                (stall                  ),
   .flush_i                (fetch_flush            )
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

   .stall_i                (1'b0                   ),
   .flush_i                (exec_flush             ),
   .exec_br_taken_i        (br_taken               ),

   .wb_rd_addr_i           (decode_rd_addr         ),
   .wb_rd_i                (decode_rd              ),
   .wb_rd_en_i             (decode_rd_en           ),

   .monitor_rs1_addr_o     (decode_rs1_addr        ),
   .monitor_rs2_addr_o     (decode_rs2_addr        )
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

   .mem_instr_o            (mem_instr              ),
   .mem_control_o          (mem_control            ),
   .mem_aluResult_o        (mem_aluResult          ),
   .mem_data_o             (mem_data               ),

   .mem_rd_addr_o          (mem_rd_addr            ),
   .mem_pcplus_o           (mem_pcplus             ),

   .mem_ready_i            (exec_ready             ),
   .monitor_load_o         (monitor_load_o         )
);

Memory Memory_Core
(
   .clk_i                  (clk_i                 ),
   .rst_i                  (rst_i                 ),

   .exec_instr_i           (mem_instr             ),
   .exec_control_i         (mem_control           ),
   .exec_aluResult_i       (mem_aluResult         ),
   .exec_data_i            (mem_data              ),

   .exec_rd_addr_i         (mem_rd_addr           ),
   .exec_pcplus_i          (mem_pcplus            ),

   .exec_ready_o           (exec_ready            ),

   .wb_instr_o             (wb_instr              ),
   .wb_control_o           (wb_control            ),
   .wb_aluResult_o         (wb_aluResult          ),
   .wb_readData_o          (wb_readData           ),
   .wb_rd_addr_o           (wb_rd_addr            ),
   .wb_pcplus_o            (wb_pcplus             ),

   .wb_ready_i             (mem_ready             ),

   .dmem_wen_o             (dmem_wen_o            ),
   .dmem_addr_o            (dmem_addr_o           ),
   .dmem_wdata_o           (dmem_wdata_o          ),
   .dmem_rdata_i           (dmem_rdata_i          )
);

WriteBack WriteBack_Core
(
   .mem_instr_i            (wb_instr               ),
   .mem_control_i          (wb_control             ),
   .mem_aluResult_i        (wb_aluResult           ),
   .mem_readData_i         (wb_readData            ),
   .mem_rd_addr_i          (wb_rd_addr             ),
   .mem_pcplus_i           (wb_pcplus              ),

   .mem_ready_o            (mem_ready              ),

   .decode_ctrl_regen_o    (decode_rd_en           ),
   .decode_rd_o            (decode_rd              ),
   .decode_rd_addr_o       (decode_rd_addr         )
);

HazardUnit HazardUnit_Core
(
   .decode_rs1_addr_i      (decode_rs1_addr           ),
   .decode_rs2_addr_i      (decode_rs2_addr           ),

   .exec_rd_addr_i         (exec_rd_addr              ),
   .exec_ctrl_regwen_i     (exec_ctrl_signal[`REGEN]  ),

   .mem_rd_addr_i          (mem_rd_addr               ),
   .mem_ctrl_regwen_i      (mem_control[`REGEN]       ),

   .wb_rd_addr_i           (wb_rd_addr                ),
   .wb_ctrl_regwen_i       (wb_control[`REGEN]        ),

   .stall                  (stall                     ),
   .flushE                 (exec_flush                )
);

endmodule