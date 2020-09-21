import lc3b_types::*;

/*
 * ZEXT[offset-n << 1]
 */
module trapzext #(parameter width = 8)
(
    input [width-1:0] in,
    output lc3b_word out
);

assign out = {8'h00, in} << 1;

endmodule : trapzext
