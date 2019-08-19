

module XADC_Controller(input logic Clk, Reset, trigger,    //'trigger' starts conversion
						input logic ADC_Busy, ADC_EOC, Data_Rdy,
						output logic Data_En, ADC_SC,
						input logic [15:0] ADC_Data_in,
						output logic [15:0] ADC_Data_out,
						output logic [6:0] ADC_Address);    

typedef enum logic [3:0] {RES = 0, DADDR, WT_TRIG, SC_HI, SC_LO, 
								WT_EOC, DEN_HI, DEN_LO, WT_DRDY, GET_DATA} state_t;

var state_t pstate, nstate;  

//state register
always_ff @(posedge Clk or posedge Reset)
	if (Reset == 1'b1) 
		pstate <= RES; 
	else 
		pstate <= nstate;

//next state		
always_comb
	unique case (pstate)
		RES : nstate = DADDR;
		DADDR : nstate = WT_TRIG;
		WT_TRIG : nstate = (trigger == 1'b1)? SC_HI : WT_TRIG;
		SC_HI : nstate = SC_LO;
		SC_LO : nstate = WT_EOC;
		WT_EOC : nstate = (ADC_EOC == 1'b1)? DEN_HI : WT_EOC;
		DEN_HI : nstate = DEN_LO;
		DEN_LO : nstate = WT_DRDY;
		WT_DRDY : nstate = (Data_Rdy == 1'b1)? GET_DATA : WT_DRDY;
		GET_DATA : nstate = WT_TRIG;
		default : nstate = RES;
	endcase

//Register Transfer Operations
always_ff @(posedge Clk) begin : RTL
	unique case (pstate)
		RES : begin
			Data_En <= 0;
			ADC_SC <= 0;
			ADC_Data_out <= '0;
			ADC_Address <= '0;
		end
		DADDR : ADC_Address <= 7'h16;
		SC_HI : ADC_SC <= 1;
		WT_EOC : ADC_SC <= 0;
		DEN_HI : Data_En <= 1;
		DEN_LO : Data_En <= 0;
		GET_DATA : ADC_Data_out <= ADC_Data_in;
		default : ; //do nothing 2/9/16		
	endcase
end : RTL

endmodule : XADC_Controller