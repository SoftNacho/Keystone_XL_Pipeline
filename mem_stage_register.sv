import lc3b_types::*;

module mem_stage_register
(
	input clk,
	input load,
	input reset_sig,
	input lc3b_word branch_address,
	input lc3b_reg dr,
	input lc3b_word alu,
	input lc3b_word mem_data,
	input lc3b_word pc_plus2,
	input lc3b_control_word control_word,
	input byte_sel,

	output lc3b_word branch_address_out,
	output lc3b_reg dr_out,
	output lc3b_word alu_out,
	output lc3b_word mem_data_out,
	output lc3b_word pc_plus2_out,
	output lc3b_control_word control_word_out,
	output logic byte_sel_out
);

lc3b_word data_branch_address;
lc3b_word data_alu;
lc3b_word data_mem_data;
lc3b_word data_pc_plus2;
lc3b_reg data_dr;
lc3b_control_word data_control_word;
logic data_byte_sel;

initial
begin
	data_branch_address = 0;
	data_alu = 0;
	data_mem_data = 0;
	data_pc_plus2 = 0;
	data_dr = 0;
	data_control_word = 0;
	data_byte_sel = 1'b0;
end

always_ff @ (posedge clk)
begin
	if (load)
	begin
		if (reset_sig)
			begin
				data_control_word <= 0;
				data_branch_address <= 0;
				data_alu <= 0;
				data_mem_data <= 0;
				data_pc_plus2 <= 0;
				data_dr <= 0;
				data_byte_sel <= 0;
			end
		else
			begin
				data_control_word <= control_word;
				data_branch_address <= branch_address;
				data_alu <= alu;
				data_mem_data <= mem_data;
				data_pc_plus2 <= pc_plus2;
				data_dr <= dr;
				data_byte_sel <= byte_sel;
			end
	end
end

always_comb
begin
	branch_address_out = data_branch_address;
	alu_out = data_alu;
	mem_data_out = data_mem_data;
	pc_plus2_out = data_pc_plus2;
	dr_out = data_dr;
	control_word_out = data_control_word;
	byte_sel_out = data_byte_sel;
end

endmodule : mem_stage_register