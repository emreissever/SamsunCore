`timescale 1ns / 1ps

module HazardUnit
(
   input    logic [4:0] decode_rs1_addr_i    ,
   input    logic [4:0] decode_rs2_addr_i    ,

   input    logic [4:0] exec_rd_addr_i       ,
   input    logic       exec_ctrl_regwen_i   ,

   input    logic [4:0] mem_rd_addr_i        ,
   input    logic       mem_ctrl_regwen_i    ,

   input    logic [4:0] wb_rd_addr_i         ,
   input    logic       wb_ctrl_regwen_i     ,

   output   logic       stall                ,
   output   logic       flushE                
);

wire dependency_exec_rs1   = (((decode_rs1_addr_i == exec_rd_addr_i) && exec_ctrl_regwen_i) && (decode_rs1_addr_i != 0))  ;
wire dependency_mem_rs1    = (((decode_rs1_addr_i == mem_rd_addr_i)  && mem_ctrl_regwen_i)  && (decode_rs1_addr_i != 0))  ;
wire dependency_wb_rs1     = (((decode_rs1_addr_i == wb_rd_addr_i)   && wb_ctrl_regwen_i)   && (decode_rs1_addr_i != 0))  ;

wire dependency_exec_rs2   = (((decode_rs2_addr_i == exec_rd_addr_i) && exec_ctrl_regwen_i) && (decode_rs2_addr_i != 0))  ;
wire dependency_mem_rs2    = (((decode_rs2_addr_i == mem_rd_addr_i)  && mem_ctrl_regwen_i)  && (decode_rs2_addr_i != 0))  ;
wire dependency_wb_rs2     = (((decode_rs2_addr_i == wb_rd_addr_i)   && wb_ctrl_regwen_i)   && (decode_rs2_addr_i != 0))  ;

assign stall  = dependency_exec_rs1 || dependency_mem_rs1 || dependency_wb_rs1 || dependency_exec_rs2 || dependency_mem_rs2 || dependency_wb_rs2 ;
assign flushE = stall ; // Flush toExecute Pipeline Registers

endmodule
