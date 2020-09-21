import lc3b_types::*;
import cache_types::*;

module mux4_onehot #(parameter width = 128)
(
	input [3:0] sel,
	input [width-1:0] a, b, c, d,
	output logic [width-1:0] f
);

always_comb
begin
	case (sel)
		4'b0001: f = a;
		4'b0010: f = b;
		4'b0100: f = c;
		4'b1000: f = d;
		default: f = a;
	endcase
end

endmodule : mux4_onehot