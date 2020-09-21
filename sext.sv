import lc3b_types::*; 

module sext #(parameter width = 5)
(
	input [width-1:0] in,
	output lc3b_word out
);

always_comb
begin
	out = 16'(signed'(in));
end

endmodule : sext
