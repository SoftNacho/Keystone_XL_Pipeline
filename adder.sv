import lc3b_types::*;

module adder
(
	input lc3b_word a, b,
	output lc3b_word f
);

always_comb
begin 
	f = a + b;
end

endmodule : adder