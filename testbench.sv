`timescale 1ns / 1ps

module testbench();

logic RESET, CLK100M;

logic VAUXP6, VAUXN6;

logic CA, CB, CC, CD, CE, CF, CG, DP, AN0, AN1, AN2, AN3;

logic [7:0] sw;  //input sliding switches
logic [7:0] JA;  //output bits to R-2R DAC
logic ManConv;  

initial begin
   CLK100M = 1'b0;
   forever
      #5 CLK100M = ~CLK100M;
end

initial begin
   RESET = 1'b1;
   repeat (10) @(negedge CLK100M);
   RESET = 1'b0;
   repeat (1500) @(negedge CLK100M);
   $stop;
end

XADC_RTL_Display UUT(.*);
    
endmodule
