import lc3b_types::*;
import cache_types::*;

module form_address
(
	input cache_tag tag,
	input [3:0] offset,
	input cache_index index,
	output lc3b_word address
);

assign address = {tag, index, 4'b0000};

endmodule : form_address