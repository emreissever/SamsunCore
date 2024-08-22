`timescale 1ns / 1ps
`include "../include/Definitions.vh"

module WriteBack
(
   input    logic [31:0]                mem_instr_i             ,
   input    logic [`CONTROL_BIT-1:0]    mem_control_i           ,
   input    logic [31:0]                mem_aluResult_i         ,
   input    logic [31:0]                mem_readData_i          ,
   input    logic [31:0]                mem_rd_addr_i           ,
   input    logic [31:0]                mem_pcplus_i            ,

   output   logic                       mem_ready_o             ,

   output   logic                       decode_ctrl_regen_o     ,
   output   logic [31:0]                decode_rd_o             ,
   output   logic [ 4:0]                decode_rd_addr_o        
);

assign decode_rd_o = 
(mem_control_i[`WB] == `WB_READDATA)   ?  mem_readData_i    : 
(mem_control_i[`WB] == `WB_ALURESULT)  ?  mem_aluResult_i   :
(mem_control_i[`WB] == `WB_PCPLUS)     ?  mem_pcplus_i      :
                                          32'bX             ;

assign decode_rd_addr_o    = mem_rd_addr_i ; 
assign decode_ctrl_regen_o = mem_control_i[`REGEN] ; 

assign mem_ready_o = 1'b1 ; 

endmodule