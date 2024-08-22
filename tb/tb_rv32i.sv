`timescale 1ns / 1ps

module tb_rv32i(); 

logic                      clk_i = 1'b1            ;
logic                      rst_i                   ;

logic [31:0]               imem_request_pc_o       ;
logic [31:0]               imem_response_pc_i      ;
logic [31:0]               imem_response_instr_i   ;

logic                      dmem_wen_o              ;
logic [31:0]               dmem_addr_o             ;
logic [31:0]               dmem_wdata_o            ;
logic [31:0]               dmem_rdata_i            ;


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


// Emulating 2048 Bytes (2 KBs) Data Memory
reg [31:0] DMem[63:0] ;

always_comb begin
   if (dmem_wen_o) begin
      DMem[dmem_addr_o[31:2]] = dmem_wdata_o ;
   end 
   else begin
      dmem_rdata_i = DMem[dmem_addr_o[31:2]] ;
   end 
end 


Samsun_Core Test_RV32I_Fetch (.*);

always #5 clk_i = ~clk_i ;
initial begin
   rst_i = 1 ;
   #17
   rst_i = 0 ;

   #350
   $stop;
end

endmodule
