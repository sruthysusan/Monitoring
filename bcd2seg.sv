
module bcd2seg #(parameter Active_High = 0)
				(input logic [3:0] bcdin, 
				output logic CA, CB, CC, CD, CE, CF, CG);  	 	

logic [6:0] temp;

always_comb
	case(bcdin) //active-low codes
		4'h0 : temp = 7'b0000001;
		4'h1 : temp = 7'b1001111;
		4'h2 : temp = 7'b0010010;
		4'h3 : temp = 7'b0000110;
		4'h4 : temp = 7'b1001100;
		4'h5 : temp = 7'b0100100;
		4'h6 : temp = 7'b0100000;
		4'h7 : temp = 7'b0001111;
		4'h8 : temp = 7'b0000000;
		4'h9 : temp = 7'b0000100;   
		4'hA : temp = 7'b0001000;	
		4'hB : temp = 7'b1100000;
		4'hC : temp = 7'b0110001;
		4'hD : temp = 7'b1000010;
		4'hE : temp = 7'b0110000;
		4'hF : temp = 7'b0111000;
	endcase

assign {CA, CB, CC, CD, CE, CF, CG} = (Active_High)? ~temp : temp; 		
			 		
endmodule : bcd2seg