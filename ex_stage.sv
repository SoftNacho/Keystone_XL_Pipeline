import lc3b_types::*;

module ex_stage
(
	input lc3b_word pc_plus2,
	input lc3b_word sr1,
	input lc3b_word sr2,
	input lc3b_reg rs,
	input lc3b_reg rt,
	input lc3b_reg dr,
	input lc3b_word imm4, 
	input lc3b_word sext5, 
	input lc3b_word sext6, 
	input lc3b_word adj6,
	input lc3b_word adj9, 
	input lc3b_word adj11,
	input [2:0] alumux_sel, 
	input destmux_sel,
	input addermux_sel,
	input lc3b_aluop aluop,
	input lc3b_word exmem_alu,
	input lc3b_word wb_reg,
	input lc3b_reg memwb_rd,
	input lc3b_reg exmem_rd,
	input mem_regwrite,
	input wb_regwrite,
	input check_rs,
	input check_rt,
	input check_rd,
	input lc3b_word exmem_branch_address,
	input lc3b_opcode exmem_opcode,
	
	output lc3b_word branch_address,
	output lc3b_word alu_out,
	output lc3b_word sr2_forward,
	output lc3b_reg destmux_out
);

//internal signal
lc3b_word addermux_out;
lc3b_word alumux_out;
lc3b_word sr1_forward;
lc3b_word sr2_forwardb;
lc3b_word forward_calc;
logic [1:0] forwardA;
logic [1:0] forwardB;
logic [1:0] forwardC;
logic shitty_select;

always_comb
begin
	shitty_select = 1'b0;
	if (exmem_opcode == op_lea)
		shitty_select = 1'b1;
end

forwardunit hillarys_email_forwards
(
	.idex_rt(rt), .idex_rs(rs), .idex_rd(dr), .exmem_rd, .memwb_rd, .mem_regwrite, .wb_regwrite, .check_rs, .check_rt, .check_rd, .forwardA, .forwardB, .forwardC
);

adder ex_adder
(
	.a(addermux_out), .b(pc_plus2), .f(branch_address)
);

mux2 addermux
(
	.sel(addermux_sel), .a(adj11), .b(adj9), .f(addermux_out)
);

mux2 shitty_preforwardfix
(
	.sel(shitty_select), .a(exmem_alu), .b(exmem_branch_address), .f(forward_calc)
);

mux3 forwards_from_grandma
(
	.sel(forwardA), .a(sr1), .b(forward_calc), .c(wb_reg), .f(sr1_forward)
);

mux3 forwards_from_grandpa
(
	.sel(forwardB), .a(sr2), .b(exmem_alu), .c(wb_reg), .f(sr2_forwardb)
);

mux3 forwards_from_crazy_uncle
(
	.sel(forwardC), .a(sr2), .b(exmem_alu), .c(wb_reg), .f(sr2_forward)
);

mux5 alumux
(
	.sel(alumux_sel), .a(sr2_forwardb), .b(sext5), .c(sext6), .d(adj6), .e(imm4), .f(alumux_out)
);

alu ex_alu
(
	.aluop(aluop), .a(sr1_forward), .b(alumux_out), .f(alu_out)
);

mux2 #(.width(3)) destmux
(
	.sel(destmux_sel), .a(dr), .b(3'b111), .f(destmux_out)
);

endmodule : ex_stage