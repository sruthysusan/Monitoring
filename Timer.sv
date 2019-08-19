//SV module to generate trigger pulses to initiate XADC conversions
//clock frequency is 100MHz
//default parameter is 10000, outputs a trigger pulse every 100us

module Timer #(parameter NUMCLKS = 10000, n = 14) // 'n' needs to accomodate NUMCLKS
				(input logic Clk, Reset, output logic Pulse);

logic [n-1:0] count; 

always_ff @(posedge Clk, posedge Reset)
	if (Reset)
		count <= NUMCLKS - 1;
	else if (count != 0)
		count <= count - 1;
	else
		count <= NUMCLKS - 1;

assign Pulse = (count == 0); //single clk length pulse

endmodule : Timer
