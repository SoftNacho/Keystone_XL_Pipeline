import lc3b_types::*;

module zext
(
	input lc3b_word zext_in,
	input byte_sel,
	output lc3b_word zext_out
);

always_comb
begin
	case(byte_sel)
		1'b1 : zext_out = {8'h00, zext_in[15:8]};
		1'b0 : zext_out = {8'h00, zext_in[7:0]};
	endcase
	
end

endmodule : zext 