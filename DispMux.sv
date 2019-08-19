module dispmux (input logic [15:0] datain, 
				output logic [3:0] bcd_out, 
				input logic [1:0] sel); 									

//16-to-4 mux for display    
always_comb
	case (sel)
		0 : bcd_out = datain[3:0];
		1 : bcd_out = datain[7:4];
		2 : bcd_out = datain[11:8];
		3 : bcd_out = datain[15:12];
	endcase
		
endmodule : dispmux
