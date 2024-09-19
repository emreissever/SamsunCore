`timescale 1ns / 1ps

`include "../include/Definitions.vh"

module ALU (
   input    wire [3 :0] ctrl_i      , 
   input    wire [31:0] operand1_i  ,
   input    wire [31:0] operand2_i  ,
   output   wire [31:0] result_o    
);

wire [31:0] result_xor_w   ;
wire [31:0] result_or_w    ;
wire [31:0] result_and_w   ;
wire [31:0] result_sll_w   ;
wire [31:0] result_srl_w   ;
wire [31:0] result_sra_w   ;
wire [31:0] result_slt_w   ;
wire [31:0] result_sltu_w  ;
wire [31:0] result_seq_w   ;

assign result_xor_w  = operand1_i   ^    operand2_i ;
assign result_or_w   = operand1_i   |    operand2_i ;
assign result_and_w  = operand1_i   &    operand2_i ;
assign result_sll_w  = operand1_i   <<   operand2_i[4:0] ;
assign result_srl_w  = operand1_i   >>   operand2_i[4:0] ;
assign result_sra_w  = $signed(operand1_i) >>> $signed(operand2_i[4:0])                ;
assign result_slt_w  = ($signed(operand1_i) < $signed(operand2_i))   ? 32'b1 : 32'b0   ;
assign result_sltu_w = (operand1_i < operand2_i)                     ? 32'b1 : 32'b0   ;

assign result_seq_w  = (operand1_i === operand2_i)                   ? 32'b1 : 32'b0   ; //

// Substraction - 2's Complement Logic
wire firstCarry = (ctrl_i == `EXECOP_SUB) ; 
wire [32:0] addition_operand1_w = (firstCarry) ? { operand1_i,firstCarry} : {operand1_i,firstCarry}  ; 
wire [32:0] addition_operand2_w = (firstCarry) ? {~operand2_i,firstCarry} : {operand2_i,firstCarry}  ; 
wire [32:0] addition_result_w ; 

assign addition_result_w = addition_operand1_w + addition_operand2_w ;

assign result_o =
(ctrl_i == `EXECOP_ADD ) | (ctrl_i == `EXECOP_SUB )   ? addition_result_w [32:1] : 
(ctrl_i == `EXECOP_SLL )                              ? result_sll_w             :
(ctrl_i == `EXECOP_SLT )                              ? result_slt_w             :
(ctrl_i == `EXECOP_SLTU)                              ? result_sltu_w            :
(ctrl_i == `EXECOP_XOR )                              ? result_xor_w             :
(ctrl_i == `EXECOP_SRL )                              ? result_srl_w             :
(ctrl_i == `EXECOP_SRA )                              ? result_sra_w             :
(ctrl_i == `EXECOP_OR  )                              ? result_or_w              :
(ctrl_i == `EXECOP_AND )                              ? result_and_w             :
(ctrl_i == `EXECOP_SEQ )                              ? result_seq_w             :
32'bZ ;

endmodule