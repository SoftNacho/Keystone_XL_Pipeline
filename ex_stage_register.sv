import lc3b_types::*;

module ex_stage_register
(
	input clk,
	input load,
	input reset_sig,
	input lc3b_word pc_plus2,
	input lc3b_word branch_address,
	input lc3b_word alu,
	input lc3b_reg  dr,
	input lc3b_nzp nzp,
	input lc3b_word sr2_data,
	
	output lc3b_word pc_plus2_out,
	output lc3b_word branch_address_out,
	output lc3b_word alu_out,
	output lc3b_reg  dr_out,
	output lc3b_nzp nzp_out,
	output lc3b_word sr2_data_out,
	
	input lc3b_control_word control_word,
	output lc3b_control_word control_word_out
);

lc3b_word data_pc_plus2;
lc3b_word data_branch_address;
lc3b_word data_alu;
lc3b_reg  data_dr;
lc3b_control_word data_control_word;
lc3b_nzp data_nzp;
lc3b_word data_sr2_data;

initial
begin
	data_pc_plus2 = 16'b0;
	data_branch_address = 16'b0;
	data_alu = 16'b0;
	data_dr = 3'b000;
	data_control_word = 1'b0;
	data_nzp = 3'b000;
	data_sr2_data = 16'b0;
end

always_ff @ (posedge clk)
begin
	if (load)
	begin
		if (reset_sig)
			begin
				data_control_word <= 0;
				data_pc_plus2 <= 0;
				data_branch_address <= 0;
				data_alu <= 0;
				data_dr <= 0;
				data_nzp <= 0;
				data_sr2_data <= 0;
			end
		else
			begin
				data_control_word <= control_word;
				data_pc_plus2 <= pc_plus2;
				data_branch_address <= branch_address;
				data_alu <= alu;
				data_dr <= dr;
				data_nzp <= nzp;
				data_sr2_data <= sr2_data;
			end
	end
end

always_comb
begin
	pc_plus2_out = data_pc_plus2;
	branch_address_out = data_branch_address;
	alu_out = data_alu;
	dr_out = data_dr;
	control_word_out = data_control_word;
	nzp_out = data_nzp;
	sr2_data_out = data_sr2_data;
end

endmodule : ex_stage_register