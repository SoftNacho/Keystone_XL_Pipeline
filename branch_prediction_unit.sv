import lc3b_types::*;

module branch_prediction_unit
(
	input clk,
	input lc3b_opcode rom_opcode,
	input lc3b_opcode wb_opcode,
	input branch_enable,
	input imem_stall,
	input lc3b_nzp nzp,
	input lc3b_nzp wb_nzp,
	input lc3b_word pc_inc,
	input lc3b_word adj9_out,
	input lc3b_word wb_pc_plus2,
	output lc3b_word address_out,
	output logic reset_sig
);

lc3b_word branch_address;
lc3b_word address_taken;
logic branch_instr;
logic taken_sel;
logic reached;
logic wb_is_branch;

always_comb
begin
	branch_address = adj9_out + pc_inc;
	if (branch_instr && nzp != 3'b000)
		taken_sel = 1'b1;
	else
		taken_sel = 1'b0;
	if (wb_is_branch && wb_nzp != 3'b000)
		reached = 1'b1;
	else
		reached = 1'b0;
		
	reset_sig = reached & ~branch_enable;
end

compare #(.width(4)) wb_branch_and_op
(
	.a(wb_opcode), .b(4'b0000), .f(wb_is_branch)
);

compare #(.width(4)) branch_and_op
(
	.a(rom_opcode), .b(4'b0000), .f(branch_instr)
);

mux2 taken_mux
(
	.sel(taken_sel), .a(pc_inc), .b(branch_address), .f(address_taken)
);

mux2 tobornottob
(
	.sel(reset_sig), .a(address_taken), .b(wb_pc_plus2), .f(address_out)
);


endmodule : branch_prediction_unit