import lc3b_types::*;

module id_stage_register
(
	input  clk,
	input  load,
	input reset_sig,
	input id_reset,
	input  lc3b_word     pc_plus2,
	input lc3b_reg 		rs,
	input lc3b_reg 		rt,
	input  lc3b_reg      dr,
	input  lc3b_word      sr1,
	input  lc3b_word      sr2,
	input  lc3b_word     imm4,
	input  lc3b_word     sext5,
	input  lc3b_word     sext6,
	input  lc3b_word     adj6,
	input  lc3b_word     adj9,
	input  lc3b_word     adj11,
	input  lc3b_nzp       nzp,
	
	output  lc3b_word     pc_plus2_out,
	output lc3b_reg			rs_out,
	output lc3b_reg			rt_out,
	output  lc3b_reg      dr_out,
	output  lc3b_word      sr1_out,
	output  lc3b_word      sr2_out,
	output  lc3b_word     imm4_out,
	output  lc3b_word     sext5_out,
	output  lc3b_word     sext6_out,
	output  lc3b_word     adj6_out,
	output  lc3b_word     adj9_out,
	output  lc3b_word     adj11_out,
	output  lc3b_nzp       nzp_out,
	
	input  lc3b_control_word control_word,
	output  lc3b_control_word control_word_out
);

lc3b_word data_pc_plus2;
lc3b_reg data_rs;
lc3b_reg data_rt;
lc3b_reg data_dr;
lc3b_word data_sr1, data_sr2;
lc3b_word data_imm4;
lc3b_word data_sext5;
lc3b_word data_sext6;
lc3b_word data_adj6;
lc3b_word data_adj9;
lc3b_word data_adj11;
lc3b_control_word data_control_word;
lc3b_nzp data_nzp;

initial
begin
	data_pc_plus2 = 16'b0;
	data_rs = 3'b000;
	data_rt = 3'b000;
	data_dr = 3'b000;
	data_sr1 = 16'b0;
	data_sr2 = 16'b0;
	data_imm4 = 4'b0000;
	data_sext5 = 5'b00000;
	data_sext6 = 6'b000000;
	data_adj6 = 6'b000000;
	data_adj9 = 9'b000000000;
	data_adj11 = 11'b00000000000;
	data_control_word  = 0;
	data_nzp = 3'b000;
end

always_ff @ (posedge clk)
begin
	if (load)
	begin
		if (reset_sig || id_reset)
			begin
				data_control_word <= 0;
				data_pc_plus2 <= 0;
				data_rs <= 0;
				data_rt <= 0;
				data_dr <= 0;
				data_sr1 <= 0;
				data_sr2 <= 0;
				data_imm4 <= 0;
				data_sext5 <= 0;
				data_sext6 <= 0;
				data_adj6 <= 0;
				data_adj9 <= 0;
				data_adj11 <= 0;
				data_nzp <= 0;
			end
		else
			begin
				data_control_word <= control_word;
				data_pc_plus2 <= pc_plus2;
				data_rs <= rs;
				data_rt <= rt;
				data_dr <= dr;
				data_sr1 <= sr1;
				data_sr2 <= sr2;
				data_imm4 <= imm4;
				data_sext5 <= sext5;
				data_sext6 <= sext6;
				data_adj6 <= adj6;
				data_adj9 <= adj9;
				data_adj11 <= adj11;
				data_nzp <= nzp;
			end
	end
end

always_comb
begin
	pc_plus2_out = data_pc_plus2;
	rs_out = data_rs;
	rt_out = data_rt;
	dr_out = data_dr;
	sr1_out = data_sr1;
	sr2_out = data_sr2;
	imm4_out = data_imm4;
	sext5_out = data_sext5;
	sext6_out = data_sext6;
	adj6_out = data_adj6;
	adj9_out = data_adj9;
	adj11_out = data_adj11;
	control_word_out = data_control_word;
	nzp_out = data_nzp;
end

endmodule : id_stage_register