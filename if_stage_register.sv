import lc3b_types::*;

module if_stage_register
(
	input clk,
	input load,
	input reset_sig,
	input lc3b_word pc_plus2,
	input lc3b_word instruction,
	input lc3b_control_word control_word,
	output lc3b_word pc_plus2_out,
	output lc3b_word instruction_out,
	output lc3b_control_word control_word_out
);

lc3b_word data_pc_plus2, data_instruction;
lc3b_control_word data_control_word;

initial
begin
	data_pc_plus2 = 16'b0;
	data_instruction = 16'b0;
	data_control_word = 1'b0;
end

always_ff @ (posedge clk)
begin
	if (load)
	begin
		if (reset_sig)
			begin
				data_pc_plus2 <= 0;
				data_instruction <= 0;
				data_control_word <= 0;
			end		
		else
			begin
				data_pc_plus2 <= pc_plus2;
				data_instruction <= instruction;
				data_control_word <= control_word;
			end
	end
end

always_comb
begin
	pc_plus2_out = data_pc_plus2;
	instruction_out = data_instruction;
	control_word_out = data_control_word;
end

endmodule : if_stage_register
