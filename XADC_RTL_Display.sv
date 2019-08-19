`timescale 1ns / 1ps

module XADC_RTL_Display(
    input logic RESET,
    input logic CLK100M,
    input logic VAUXP6,   //analogue input
    input logic VAUXN6,
    output logic CA,       //display signals
    output logic CB,
    output logic CC,
    output logic CD,
    output logic CE,
    output logic CF,
    output logic CG,
    output logic DP,
    output logic AN0,
    output logic AN1,
    output logic AN2,
    output logic AN3,
    input logic [7:0] sw,  //input sliding switches
    output logic [7:0] JA,  //output bits to R-2R DAC
    input logic ManConv     //push-button manual convert command (BTND)
    );
    
//XADC input signals
logic DEN, SC;
//XADC output signals
logic DRDY, BUSY, EOC;

//XADC data output
logic [15:0] XADC_DO;
//XADC address input (selects ADC result register)
logic [6:0] DADDR;

//display signals
logic [15:0] DISP_DATA;
logic [3:0] bcdin;
logic [1:0] sel;

logic Clk, Reset, trigger;

logic q0, q1;

assign Clk = CLK100M;
assign Reset = RESET;

//connect switches to DAC
assign JA = sw;

//instantiation of XADC
xadc_wiz_0
   ADC1(.convst_in(SC),
    .daddr_in(DADDR),
    .dclk_in(Clk),
    .den_in(DEN),
    .di_in(),
    .dwe_in(1'b0),
    .reset_in(Reset),
    .vauxp6(VAUXP6),
    .vauxn6(VAUXN6),
    .busy_out(BUSY),
    .channel_out(),
    .do_out(XADC_DO),
    .drdy_out(DRDY),
    .eoc_out(EOC),
    .eos_out(),
    .alarm_out(),
    .vp_in(),
    .vn_in());  

XADC_Controller CON1(.ADC_Busy(BUSY), .ADC_EOC(EOC), .Data_Rdy(DRDY),
						.Data_En(DEN), .ADC_SC(SC),
						.ADC_Data_in(XADC_DO),
						.ADC_Data_out(DISP_DATA),
						.ADC_Address(DADDR), .*);

//for simulation set NUMCLKS to 200 and n to 8	
//for implementation use .NUMCLKS(1000000), .n(20)					
Timer #(.NUMCLKS(200), .n(8)) //100Hz pulse
          TMR1(.Pulse(trigger), .*);					
          
//manual convert start button (use as alternative to above Timer)
//always_ff @(posedge Clk) begin : pushbutton  
//   q0 <= ManConv;
//   q1 <= q0;   
//end : pushbutton  

//assign trigger = q0 & ~q1;
//end of manual start conversion button       		  
	  
//display logic	
assign DP = 1'b1;  //turn off decimal points

bcd2seg BCD2SEG1(.*);

dispmux DMUX1(.datain(DISP_DATA), .bcd_out(bcdin), .*); 

//set N = 2 for simulation and 22 for implementation 	  
dispcntr #(.N(2)) DCNTR1(.*);     
    
endmodule
