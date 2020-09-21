module mux5 #(parameter width = 16)
(
	input [2:0] sel,
	input [width-1 : 0] a,
	input [width-1 : 0] b,
	input [width-1 : 0] c,
	input [width-1 : 0] d,
	input [width-1 : 0] e,
	output logic [width-1 : 0] f
);

always_comb
begin
	case (sel)
		3'b000 : f = a;
		3'b001 : f = b;
		3'b010 : f = c;
		3'b011 : f = d;
		3'b100 : f = e;
		default : f = a;
	endcase
end

endmodule : mux5