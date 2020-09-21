import lc3b_types::*;
import cache_types::*;

module hit_detector
(
	input cache_tag tag0,
	input cache_tag tag1,
	input cache_tag tag_orig,
	input logic valid0,
	input logic valid1,
	
	output logic hit,
	output logic compare0_out,
	output logic compare1_out
);

logic compare0, compare1, out0, out1;

always_comb
begin
	out0 = compare0 && valid0;
	out1 = compare1 && valid1;
	hit = out0 || out1;
   compare0_out = out0;
   compare1_out = out1;
end

compare #(.width(9)) compare_tag0
(
	.a(tag0),
	.b(tag_orig),
	.f(compare0)
);

compare #(.width(9)) compare_tag1
(
	.a(tag1),
	.b(tag_orig),
	.f(compare1)
);


endmodule : hit_detector