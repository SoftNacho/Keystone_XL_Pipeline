import lc3b_types::*;

module wb_stage
(
	input lc3b_word alu_out,
	input lc3b_word branch_address,
	input lc3b_word pc_plus2, 
   input [2:0] regfilemux_sel,
	input lc3b_word mem_wdata,
	input byte_sel,
	
	output lc3b_word regfilemux_out,
	output lc3b_word mem_data
);

assign 	mem_data =  mem_wdata;
lc3b_word zext_out;

mux5 regfilemux
(
	.sel(regfilemux_sel), .a(alu_out), .b(mem_wdata), .c(branch_address), .d(pc_plus2), .e(zext_out), .f(regfilemux_out)
);

zext zext1 
(
	.zext_in(mem_wdata), .byte_sel, .zext_out(zext_out)
);

endmodule : wb_stage