module mux3 #(parameter width = 16)
(
	input [1: 0] sel,
	input [width-1 : 0] a,
	input [width-1 : 0] b,
	input [width-1 : 0] c,
	output logic [width-1 : 0] f
);

always_comb
begin
	case (sel)
		2'b00 : f = a;
		2'b01 : f = b;
		2'b10 : f = c;
		2'b11 : f = a;
	endcase
end

endmodule : mux3