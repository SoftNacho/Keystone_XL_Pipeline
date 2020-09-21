import lc3b_types::*;
import cache_types::*;

module hit_detector
(
	input cache_tag tag0,
	input cache_tag tag1,
	input cache_tag tag2,
	input cache_tag tag3,
	input cache_tag tag_orig,
	input logic valid0,
	input logic valid1,
	input logic valid2,
	input logic valid3,
	
	output logic hit,
	output logic [3:0] hit_direction
);

logic compare0, compare1, compare2, compare3, out0, out1, out2, out3;

always_comb
begin
	out0 = compare0 && valid0;
	out1 = compare1 && valid1;
	out2 = compare2 && valid2;
	out3 = compare3 && valid3;
	hit = out0 || out1 || out2 || out3;
	// One hot encoding to decide where the hit occured
	hit_direction = {out3, out2, out1, out0};
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

compare #(.width(9)) compare_tag2
(
	.a(tag2),
	.b(tag_orig),
	.f(compare2)
);

compare #(.width(9)) compare_tag3
(
	.a(tag3),
	.b(tag_orig),
	.f(compare3)
);

endmodule : hit_detector