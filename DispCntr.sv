//modified for BASYS3 Board with 100MHz input clock

module dispcntr #(parameter N = 2)
				(input logic Clk, Reset, 
				output logic AN0, AN1, AN2, AN3,   //active-low anodes
				output logic [1:0] sel); 

//divides clock input by 2**N
//used by multiplexed displays
//set N = 2 for simulation and
//N = 22 for implementation (100e6/2**20 = 95Hz) 				
					
reg [N-1:0] count;

always_ff @(posedge Clk or posedge Reset)
begin
	if (Reset == 1'b1)
		count <= 0;
	else
		count <= count + 1;
end
  
assign sel = count[N-1:N-2];  //top 2 bits of count 

//active low common anodes
assign AN0 = ~(sel == 0);
assign AN1 = ~(sel == 1);
assign AN2 = ~(sel == 2);
assign AN3 = ~(sel == 3);
  
endmodule : dispcntr