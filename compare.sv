import lc3b_types::*;
import cache_types::*;

module compare #(parameter width = 3)
(
	input [width - 1:0] a,
	input [width - 1:0] b,
	
	output logic f
);

always_comb
begin
	f = 0;
	if (a == b) begin
		f = 1;
	end
end

endmodule : compare