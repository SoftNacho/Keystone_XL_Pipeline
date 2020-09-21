module mux8 #(parameter width = 16)
(
	input [2:0] sel,
	input [width-1:0] a, b, c, d, e, g, h, i,
	output logic [width-1:0] f
);

always_comb
begin
	case (sel)
		0: f = a;
		1: f = b;
		2: f = c;
		3: f = d;
		4: f = e;
		5: f = g;
		6: f = h;
		7: f = i;
		default: f = a;
	endcase
end

endmodule : mux8