import lc3b_types::*;

module id_stage
(
	// Input
	input clk,
	input lc3b_word ir,
	input lc3b_word regfile_in,
	input lc3b_reg  dest_in,
	input idex_mem_read,
	input lc3b_reg idex_rd,

	// Input from control word
	input logic load_regfile,
	input logic storemux_sel,
	input check_rs,
	input check_rt,
	input lc3b_control_word id_control_word,

	// Output
	output lc3b_reg rs,
	output lc3b_reg rt,
	output lc3b_reg  dr,
	output lc3b_word  sr1,
	output lc3b_word  sr2,
	output lc3b_nzp  nzp,
	output lc3b_word imm4_out,
	output lc3b_word sext5_out,
	output lc3b_word sext6_out,
	output lc3b_word adj6_out, 
	output lc3b_word adj9_out,
	output lc3b_word adj11_out,
	output logic hazard_stall,
	output lc3b_control_word id_control_word_out,
	output logic id_reset
);

// Internal signals
lc3b_reg storemux_out;
lc3b_reg src_a;
lc3b_reg src_b;
lc3b_reg dest;
assign src_a = ir[8:6];
assign src_b = ir[2:0];
assign dest  = ir[11:9];

lc3b_offset6  offset6;
lc3b_offset9  offset9;
lc3b_offset11 offset11;
assign offset6  = ir[5:0];
assign offset9 = ir[8:0];
assign offset11 = ir[10:0];

lc3b_imm4 imm4;
lc3b_imm5 imm5;
lc3b_imm6 imm6;
assign imm4 = ir[3:0];
assign imm5 = ir[4:0];
assign imm6 = ir[5:0];

// Assign outputs
assign nzp = dest;
assign dr  = dest;
assign rs = src_a;
assign rt = src_b;
assign imm4_out = 16'({12'b0, imm4});
assign id_control_word_out = id_control_word;

always_comb
begin
	id_reset = 1'b0;
	if (hazard_stall)
		id_reset = 1'b1;
end

hdu hazmat (.idex_mem_read, .idex_rd, .ifid_rs(rs), .check_rs, .check_rt, .ifid_rt(rt), .hazard_stall);

mux2 #(.width(3)) storemux ( .sel(storemux_sel), .a(src_b), .b(dest), .f(storemux_out) );

regfile registers ( .clk(clk), .load(load_regfile), .in(regfile_in), .src_a(src_a), .src_b(storemux_out), .dest(dest_in), .reg_a(sr1), .reg_b(sr2) );

sext #(.width(5)) sext5 ( .in(imm5), .out(sext5_out) );

sext #(.width(6)) sext6 (. in(imm6), .out(sext6_out) );

adj #(.width(6)) adj6 ( .in(offset6), .out(adj6_out) );

adj #(.width(9)) adj9 ( .in(offset9), .out(adj9_out) );

adj #(.width(11)) adj11 ( .in(offset11), .out(adj11_out) );
 
endmodule : id_stage
 