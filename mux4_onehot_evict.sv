import lc3b_types::*;
import cache_types::*;

module mux4_onehot_evict #(parameter width = 128)
(
	input [2:0] sel,
	input [width-1:0] a, b, c, d,
	output logic [width-1:0] f
);

always_comb
begin
	case (sel)
		3'b000: f = d;
		3'b001: f = b;
		3'b010: f = d;
		3'b011: f = a;
		3'b100: f = c;
		3'b101: f = b;
		3'b110: f = c;
		3'b111: f = a;
		default: f = a;
	endcase
end

endmodule : mux4_onehot_evict