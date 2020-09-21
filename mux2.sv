module mux2 #(parameter width = 16)
(
	input sel,
	input [width-1 : 0] a,
	input [width-1 : 0] b,
	output logic [width-1 : 0] f
);

always_comb
begin
	case (sel)
		1'b0 : f = a;
		1'b1 : f = b;
	endcase
end

endmodule : mux2