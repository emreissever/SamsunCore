`timescale 1ns / 1ps
`include "../include/Definitions.vh"

module Memory
(
   input    logic                      clk_i             ,
   input    logic                      rst_i             ,

   input    logic [31:0]               exec_instr_i      ,
   input    logic [`CONTROL_BIT-1:0]   exec_control_i    ,
   input    logic [31:0]               exec_aluResult_i  ,
   input    logic [31:0]               exec_data_i       ,

   input    logic [31:0]               exec_rd_addr_i    ,
   input    logic [31:0]               exec_pcplus_i     ,

   output   logic                      exec_ready_o      ,

   output   logic [31:0]               wb_instr_o        ,
   output   logic [`CONTROL_BIT-1:0]   wb_control_o      ,
   output   logic [31:0]               wb_aluResult_o    ,
   output   logic [31:0]               wb_readData_o     ,
   output   logic [31:0]               wb_rd_addr_o      ,
   output   logic [31:0]               wb_pcplus_o       ,

   input    logic                      wb_ready_i        ,

   output   logic                      dmem_wen_o        ,
   output   logic [31:0]               dmem_addr_o       ,
   output   logic [31:0]               dmem_wdata_o      ,
   input    logic [31:0]               dmem_rdata_i            
);

assign dmem_wen   = exec_control_i[7] ? exec_control_i[6] : 1'b0  ;
assign dmem_addr  = exec_aluResult_i                              ;
assign dmem_wdata = exec_data_i                                   ; 

// SYNCHRONOUS LOGIC TO PIPELINING PAYLOAD //

always_ff @(posedge clk_i) begin
   if (rst_i) begin
      wb_instr_o     <= `I_NOP            ;
      wb_control_o   <= `CONTROL_NOP      ;
      wb_aluResult_o <= 32'b0             ;
      wb_readData_o  <= 32'b0             ;
      wb_rd_addr_o   <= 5'b0              ;
      wb_pcplus_o    <= 32'b0             ;
   end 
   else if (wb_ready_i) begin
      wb_instr_o     <= exec_instr_i      ;
      wb_control_o   <= exec_control_i    ;
      wb_aluResult_o <= exec_aluResult_i  ;
      wb_readData_o  <= dmem_rdata_i      ;
      wb_rd_addr_o   <= exec_rd_addr_i    ;
      wb_pcplus_o    <= exec_pcplus_i     ;
   end
end

assign exec_ready_o = wb_ready_i          ; 

endmodule
