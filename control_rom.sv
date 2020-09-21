import lc3b_types::*;

module control_rom
(
	input lc3b_opcode opcode,
	input jsr_bit,
	input [1:0] shf_bits,
	input lc3b_reg dr_in_prog,
	input lc3b_trapvect trapvect8,
	output lc3b_control_word ctrl
);

logic im_bit;
assign im_bit = shf_bits[1];

always_comb
begin
	/*Default Assignments*/
	ctrl.opcode = opcode;
	ctrl.aluop = alu_add;
	ctrl.trapvect = trapvect8;
	ctrl.pcmux_sel = 3'b000;
	ctrl.storemux_sel = 1'b0;
	ctrl.load_regfile = 1'b0;
	ctrl.alumux_sel = 3'b000;
	ctrl.addermux_sel = 1'b0;
	ctrl.marmux_sel = 2'b00;
	ctrl.mdrmux_sel = 1'b0;
	ctrl.destmux_sel = 1'b0;
	ctrl.regfilemux_sel = 3'b000;
	ctrl.load_pc = 1'b0;
	ctrl.load_cc = 1'b0;
	ctrl.mem_read = 1'b0;
	ctrl.mem_write = 1'b0;
	ctrl.check_rs = 1'b0;
	ctrl.check_rt = 1'b0;
	ctrl.check_rd = 1'b0;
	
	case(opcode)
		op_add : begin
			ctrl.aluop = alu_add;
			if (im_bit)
				ctrl.alumux_sel = 3'b001;
			else
				begin
					ctrl.alumux_sel = 3'b000;
					ctrl.check_rt = 1'b1;
				end
			ctrl.check_rs = 1'b1;
			ctrl.check_rd = 1'b1;
			ctrl.load_cc = 1'b1;
			ctrl.load_regfile = 1'b1;
		end
		
		op_and : begin
			ctrl.aluop = alu_and;
			if (im_bit)
				ctrl.alumux_sel = 3'b001;
			else
				begin
					ctrl.alumux_sel = 3'b000;
					ctrl.check_rt = 1'b1;
				end
			ctrl.check_rs = 1'b1;
			ctrl.check_rd = 1'b1;
			ctrl.load_cc = 1'b1;		
			ctrl.load_regfile = 1'b1;
		end
		
		op_not : begin
			ctrl.aluop = alu_not;
			ctrl.load_regfile = 1'b1;
			ctrl.load_cc = 1'b1;
			ctrl.check_rs = 1'b1;
			ctrl.check_rd = 1'b1;
		end
		
		op_shf : begin
			ctrl.alumux_sel = 3'b100;
			case (shf_bits)
				2'b00 : ctrl.aluop = alu_sll;
				2'b10 : ctrl.aluop = alu_sll;
				2'b01 : ctrl.aluop = alu_srl;
				2'b11 : ctrl.aluop = alu_sra;
			endcase
			ctrl.load_regfile = 1'b1;
			ctrl.load_cc = 1'b1;
			ctrl.check_rs = 1'b1;
			ctrl.check_rd = 1'b1;
		end
		
		op_ldr : begin
			ctrl.aluop = alu_add;
			ctrl.alumux_sel = 3'b011;
			ctrl.mdrmux_sel = 1'b1;
			ctrl.regfilemux_sel = 3'b001;
			ctrl.load_regfile = 1'b1;
			ctrl.load_cc = 1'b1;
			ctrl.mem_read = 1'b1;
			ctrl.check_rd = 1'b1;
			ctrl.check_rs = 1'b1;
		end
		
		op_ldi : begin
			ctrl.aluop = alu_add;
			ctrl.alumux_sel = 3'b011;
			ctrl.mdrmux_sel = 1'b1;
			ctrl.regfilemux_sel = 3'b001;
			ctrl.load_regfile = 1'b1;
			ctrl.load_cc = 1'b1;
			ctrl.mem_read = 1'b1;
			ctrl.check_rd = 1'b1;
			ctrl.check_rs = 1'b1;
		end
		
		op_lea : begin
			ctrl.addermux_sel = 1'b1;
			ctrl.load_cc = 1'b1;
			ctrl.regfilemux_sel = 3'b010;
			ctrl.load_regfile = 1'b1;
			ctrl.check_rd = 1'b1;
		end
		
		op_ldb : begin
			ctrl.alumux_sel = 3'b010;
			ctrl.aluop = alu_add;
			ctrl.mdrmux_sel = 1'b1;
			ctrl.mem_read = 1'b1;
			ctrl.regfilemux_sel = 3'b100;
			ctrl.load_regfile = 1'b1;
			ctrl.load_cc = 1'b1;
			ctrl.check_rd = 1'b1;
			ctrl.check_rs = 1'b1;
		end
		
		op_str : begin
			ctrl.aluop = alu_add;
			ctrl.alumux_sel = 3'b011;
			ctrl.storemux_sel = 1'b1;
			ctrl.mem_write = 1'b1;
			ctrl.check_rd = 1'b1;
			ctrl.check_rs = 1'b1;
		end
		
		op_sti : begin
			ctrl.aluop = alu_add;
			ctrl.alumux_sel = 3'b011;
			ctrl.storemux_sel = 1'b1;
			ctrl.mem_write = 1'b1;
			ctrl.mem_read = 1'b1;
			ctrl.check_rd = 1'b1;
			ctrl.check_rs = 1'b1;
		end
		
		op_stb : begin
			ctrl.alumux_sel = 3'b010;
			ctrl.storemux_sel = 1'b1;
			ctrl.mem_write = 1'b1;
			ctrl.aluop = alu_add;
			ctrl.check_rd = 1'b1;
			ctrl.check_rs = 1'b1;
		end
		
		op_br: begin
			ctrl.addermux_sel = 1'b1;
			ctrl.pcmux_sel = 3'b001;
		end
		
		op_jmp: begin
			ctrl.aluop = alu_pass;
			ctrl.pcmux_sel = 3'b010;
			ctrl.check_rs = 1'b1;
		end
		
		op_jsr: begin
			ctrl.destmux_sel = 1'b1;
			ctrl.regfilemux_sel = 3'b011;
			ctrl.load_regfile = 1'b1;
			ctrl.addermux_sel = 1'b0;
			if (jsr_bit == 1'b0)
				begin
					ctrl.pcmux_sel = 3'b010;
					ctrl.aluop = alu_pass;
					ctrl.check_rs = 1'b1;
				end
			else
				begin
					ctrl.pcmux_sel = 3'b101;
					ctrl.aluop = alu_add;
				end
		end
		
		op_trap: begin
			ctrl.destmux_sel = 1'b1;
			ctrl.regfilemux_sel = 3'b011;
			ctrl.load_regfile = 1'b1;
			ctrl.marmux_sel = 2'b10;
			ctrl.pcmux_sel = 3'b011;
			ctrl.mdrmux_sel = 1'b1;
			ctrl.mem_read = 1'b1;
		end
		
		default : begin
			ctrl = 0;
		end
	endcase
end

endmodule : control_rom
