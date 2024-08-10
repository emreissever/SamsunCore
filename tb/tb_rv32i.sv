`timescale 1ns / 1ps

module tb_rv32i();

logic          clk_i = 1               ;
logic          rst_i                   ;

logic          br_taken_i     = 1'b0   ;
logic [31:0]   br_tgt_addr_i  = 1'b0   ;

logic [31:0]   decode_instr_o          ;
logic [31:0]   decode_pc_o             ;
logic          decode_ready_i = 1'b1   ;

logic [31:0]   imem_request_pc_o       ;


logic [31:0]   imem_response_pc_i      ;
logic [31:0]   imem_response_instr_i   ;

// // 

// Emulating 2048 Bytes (2 KBs) Instruction Memory
reg [31:0] IMem [63:0] ;

initial $readmemh("TestInstructions.mem", IMem);
// // TEST IMEM
// initial begin
//    $display("Memory content:");
//    for (int i = 0; i < 256; i++) begin
//    $display("%h: %h", i, IMem[i]);
//    end
// end

assign imem_response_instr_i  = IMem[imem_request_pc_o[31:2]] ;
assign imem_response_pc_i     = imem_request_pc_o ;

Samsun_Core Test_RV32I_Fetch (.*);

always #5 clk_i = ~clk_i ; 
initial begin
   rst_i = 1 ; 
   #17
   rst_i = 0 ; 

   #50

   br_taken_i     = 1'b1 ;
   br_tgt_addr_i  = 32'h00_00_00_04 ;
   #10

   br_taken_i     = 1'b0   ;
   br_tgt_addr_i  = 1'b0   ;

   #30

   decode_ready_i = 1'b0  ;
   #30

   decode_ready_i = 1'b1  ;

   #150
   $stop;
end 

endmodule
