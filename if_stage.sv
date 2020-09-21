import lc3b_types::*;

module if_stage
(
	input clk,
	input imem_resp,
	input lc3b_opcode id_opcode,
	input hazard_stall,
	input global_stall,
	input ctrl_hazard,
	input lc3b_word jsr_address,
	input branch_enable,
	input lc3b_word alu_out,
	input lc3b_word imem_rdata,
	input lc3b_word trap_data,
	input [2:0] pcmux_sel,
	input lc3b_opcode wb_opcode,
	input lc3b_reg dr_in_prog,
	input lc3b_word wb_pc_plus2,
	
	output logic imem_read,
	output logic reset_sig,
	output logic ctrl_hazard_stall,
	output lc3b_word instruction_out,
	output lc3b_word pc_inc_out,
	output lc3b_word imem_address,
	output lc3b_control_word if_control_word_out
);


/*IF*/
logic imem_stall;
logic load_pc;
reg waiting;
reg hol_up;
lc3b_word trapzext_out;
lc3b_word pcmux_out;
lc3b_word pc_inc;
lc3b_word pc_out;
lc3b_word bp_unit_out;
lc3b_control_word if_control_word;
lc3b_opcode rom_opcode;
logic im_bit;
logic jsr_bit;
logic ctrl_reset;
logic branch_reset;
logic [1:0] shf_bits;
lc3b_trapvect new_trapvect;
logic [2:0] pcmux_sel_new;

assign imem_stall = ~imem_resp;
assign imem_read = ~global_stall;
assign imem_address = pc_out;
assign reset_sig = branch_reset | ctrl_reset;
assign rom_opcode = lc3b_opcode'(imem_rdata[15:12]);
assign jsr_bit = imem_rdata[11];
assign shf_bits = imem_rdata[5:4];
assign new_trapvect = imem_rdata[7:0];
assign ctrl_hazard_stall = ctrl_hazard & imem_stall;

always_comb
begin
	load_pc = 1'b1;
	pcmux_sel_new = 3'b000;
	instruction_out = imem_rdata;
	pc_inc_out = pc_inc;
	if_control_word_out = if_control_word;
	ctrl_reset = 1'b0;
	branch_reset = 1'b0;
	if (global_stall || hazard_stall)
		begin
			load_pc = 1'b0;
		end
	else if (imem_stall)
		begin
			load_pc = 1'b0;
			instruction_out = 16'b0;
			pc_inc_out = 16'b0;
			if_control_word_out = 0;
		end
	else
		begin
			case (wb_opcode)
				op_br: begin
					if (branch_enable)
					begin
						pcmux_sel_new =3'b001;
						branch_reset = 1'b1;
					end
				end
				
				op_jmp : begin
					pcmux_sel_new = pcmux_sel;
					ctrl_reset = 1'b1;
				end
				
				op_jsr : begin
					pcmux_sel_new = pcmux_sel;
					ctrl_reset = 1'b1;
				end
			
				op_trap : begin
					pcmux_sel_new = pcmux_sel;
					ctrl_reset = 1'b1;
				end
						
				default : pcmux_sel_new = 3'b000;
			endcase
		end
end

//IF Stage
control_rom control_rom
(
	.opcode(rom_opcode), .jsr_bit, .shf_bits, .dr_in_prog, .trapvect8(new_trapvect), .ctrl(if_control_word)
);

mux6 pcmux
(
	.sel(pcmux_sel_new), .a(pc_inc), .b(jsr_address), .c(alu_out), .d(trap_data), .e(pc_out), .f(jsr_address), .out(pcmux_out)
);

register pc
(
	.clk, .load(load_pc), .din(pcmux_out), .dout(pc_out)
);

plus2 pc_plus2
(
	.in(pc_out), .out(pc_inc)
);


endmodule : if_stage