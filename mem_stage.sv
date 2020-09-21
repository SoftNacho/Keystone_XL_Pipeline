import lc3b_types::*;

module mem_stage
(
	input clk,
	input mem_resp_in,
	input lc3b_word alu,
	input lc3b_word mem_rdata,
	input [1:0] marmux_sel,
	input mdrmux_sel,
	input mem_read_in,
	input mem_write_in,
	input lc3b_word sr2_data,
	input lc3b_opcode opcode,
	input lc3b_trapvect trapvect,
	input load_cc,
	input lc3b_nzp nzp,
	input lc3b_word mem_branch_address_out,
	input lc3b_word mem_pc_plus2_out,
	input [2:0] regfilemux_sel,
	output logic branch_enable,
	output logic ctrl_hazard,
	
	output lc3b_word mem_address,
	output lc3b_word mem_wdata,
	output logic mem_read_out,
	output logic mem_write_out,
	output logic stall,
	output logic mem_byte_sel,
	output lc3b_mem_wmask mem_byte_enable,
	
	input icache_miss,
	input dcache_miss,
	input icache_hit,
	input dcache_hit,
	input hazard_stall,
	input l2_hit,
	input l2_miss,
	input reset_sig
);

//logic mem_resp;
logic [1:0] marmux_sel_new;
logic load_mar;
lc3b_word mem_write_data;
lc3b_word mar_out;
lc3b_word trapzext_out;
lc3b_word regfilemux_out;
assign mem_byte_sel = mem_address[0];
enum logic {S_IDLE, S_INDI} cur_state, next_state;

logic load_counter;
logic load_icache_miss, reset_icache_miss;
logic [9:0] icache_miss_data;
logic load_icache_hit, reset_icache_hit;
logic [9:0] icache_hit_data;
logic load_dcache_miss, reset_dcache_miss;
logic [9:0] dcache_miss_data;
logic load_dcache_hit, reset_dcache_hit;
logic [9:0] dcache_hit_data;
logic load_stall, reset_stall;
logic [9:0] stall_data;
logic load_hazard_stall, reset_hazard_stall;
logic [9:0] hazard_stall_data;
logic load_l2_miss, reset_l2_miss;
logic [9:0] l2_miss_data;
logic load_l2_hit, reset_l2_hit;
logic [9:0] l2_hit_data;
logic load_bp, reset_bp;
logic [9:0] bp_data;

lc3b_word zext_out;
lc3b_nzp gencc_out;
lc3b_nzp cc_out;
logic compare_true;

initial
begin
	cur_state = S_IDLE;
end

always_comb
begin
	if (compare_true && (opcode == op_br))
		branch_enable = 1'b1;
	else
		branch_enable= 1'b0;
		
	if ((opcode == op_jmp) || (opcode == op_jsr) || (opcode == op_trap) || ((opcode == op_br) && (nzp != 3'b000) && branch_enable)) // changed from !branch_enable
		ctrl_hazard = 1'b1;
	else
		ctrl_hazard = 1'b0;
end

register #(.width(3)) cc
(
	.clk(clk),
	.load(load_cc),
	.din(gencc_out),
	.dout(cc_out)
);

gencc gencc1 
(
	.in(regfilemux_out), .out(gencc_out)
);

cccomp cccomp1 
(
	.CC_nzp(cc_out), .IR_nzp(nzp), .br_enable(compare_true)
);

always_ff @ (posedge clk)
begin
	cur_state <= next_state;
end

always_comb
begin
	next_state = cur_state;
	case (cur_state)
		S_IDLE : begin
			if ((opcode == op_ldi) || (opcode == op_sti) && mem_resp_in) 
				begin
					next_state = S_INDI;
				end
		end
		S_INDI : begin
			if (mem_resp_in)
				next_state = S_IDLE;
		end
	endcase
end

always_comb
begin
	mem_wdata = mem_write_data;
	if (mem_byte_sel && (opcode == op_stb))
		begin
			mem_byte_enable = 2'b10;
			mem_wdata[15:8] = mem_write_data[7:0];
		end
	else if ((mem_byte_sel == 1'b0) && (opcode == op_stb))
		mem_byte_enable = 2'b01;
	else
		mem_byte_enable = 2'b11;
	
	load_icache_miss = 1'b0;
	load_icache_hit = 1'b0;
	load_dcache_miss = 1'b0;
	load_dcache_hit = 1'b0;
	load_stall = 1'b0;
	load_hazard_stall = 1'b0;
	load_l2_miss = 1'b0;
	load_l2_hit = 1'b0;
	load_bp = 1'b0;
	if (mem_address == 16'hFFFF) begin
		load_icache_miss = 1'b1;
		mem_write_out = 1'b0;
		mem_read_out = 1'b0;		
	end else if (mem_address == 16'hFFFD) begin
		load_icache_hit = 1'b1;
		mem_write_out = 1'b0;
		mem_read_out = 1'b0;	
	end else if (mem_address == 16'hFFFB) begin
		load_dcache_miss = 1'b1;
		mem_write_out = 1'b0;
		mem_read_out = 1'b0;	
	end else if (mem_address == 16'hFFF9) begin
		load_dcache_hit = 1'b1;
		mem_write_out = 1'b0;
		mem_read_out = 1'b0;	
	end else if (mem_address == 16'hFFF7) begin
		load_stall = 1'b1;
		mem_write_out = 1'b0;
		mem_read_out = 1'b0;	
	end else if (mem_address == 16'hFFF5) begin
		load_hazard_stall = 1'b1;
		mem_write_out = 1'b0;
		mem_read_out = 1'b0;	
	end else if (mem_address == 16'hFFF3) begin
		load_l2_miss = 1'b1;
		mem_write_out = 1'b0;
		mem_read_out = 1'b0;	
	end else if (mem_address == 16'hFFF1) begin
		load_l2_hit = 1'b1;
		mem_write_out = 1'b0;
		mem_read_out = 1'b0;	
	end else if (mem_address == 16'hFFEF) begin
		load_bp = 1'b1;
		mem_write_out = 1'b0;
		mem_read_out = 1'b0;		
	end else begin
		mem_write_out = mem_write_in;
		mem_read_out = mem_read_in;	
	end
		
	reset_icache_miss = 1'b0;
	reset_icache_hit = 1'b0;
	reset_dcache_miss = 1'b0;
	reset_dcache_hit = 1'b0;
	reset_stall = 1'b0;
	reset_hazard_stall = 1'b0;
	reset_l2_miss = 1'b0;
	reset_l2_hit = 1'b0;
	reset_bp = 1'b0;
	if (load_icache_miss && opcode == op_str)
		reset_icache_miss = 1'b1;
	if (load_icache_hit && opcode == op_str)
		reset_icache_hit = 1'b1;
	if (load_dcache_miss && opcode == op_str)
		reset_dcache_miss = 1'b1;
	if (load_dcache_hit && opcode == op_str)
		reset_dcache_hit = 1'b1;
	if (load_stall && opcode == op_str)
		reset_stall = 1'b1;
	if (load_hazard_stall && opcode == op_str)
		reset_hazard_stall = 1'b1;
	if (load_l2_miss && opcode == op_str)
		reset_l2_miss = 1'b1;
	if (load_l2_hit && opcode == op_str)
		reset_l2_hit = 1'b1;
	if (load_bp && opcode == op_str)
		reset_bp = 1'b1;
		
	if (load_icache_miss && opcode == op_ldr)
		mem_wdata = icache_miss_data;
	if (load_icache_hit && opcode == op_ldr)
		mem_wdata = icache_hit_data;
	if (load_dcache_miss && opcode == op_ldr)
		mem_wdata = dcache_miss_data;
	if (load_dcache_hit && opcode == op_ldr)
		mem_wdata = dcache_hit_data;
	if (load_stall && opcode == op_ldr)
		mem_wdata = stall_data;
	if (load_hazard_stall && opcode == op_ldr)
		mem_wdata = hazard_stall_data;
	if (load_l2_miss && opcode == op_ldr)
		mem_wdata = l2_miss_data;
	if (load_l2_hit && opcode == op_ldr)
		mem_wdata = l2_hit_data;
	if (load_bp && opcode == op_ldr)
		mem_wdata = bp_data;
		
	stall = 1'b0;
	load_counter = load_icache_miss | load_icache_hit | load_dcache_miss | load_dcache_hit | load_hazard_stall | load_stall | load_l2_miss | load_l2_hit | load_bp;
	
	case (cur_state)
		S_IDLE: begin
			load_mar = 1'b1;
			if ((mem_read_in || mem_write_in) && ~load_counter)
				begin
					stall = 1'b1;
					if ((opcode == op_ldi) || (opcode == op_sti)) 
						mem_write_out = 1'b0;
					else
						begin
							if (mem_resp_in)
								stall = 1'b0;
						end
				end
			marmux_sel_new = marmux_sel;
		end
		S_INDI: begin
			load_mar = 1'b0;
			stall = 1'b1;
			marmux_sel_new = 2'b01;
			if (mem_resp_in)
				stall = 1'b0;
			if (opcode == op_sti)
				begin
					mem_read_out = 1'b0;
					mem_write_out = 1'b1;
				end
			else 
				begin
					mem_read_out = 1'b1;
					mem_write_out = 1'b0;
				end
		end
	endcase
end

register mar
(
	.clk, .load(load_mar), .din(mem_rdata), .dout(mar_out)
);

mux3 marmux
(
	.sel(marmux_sel_new), .a(alu), .b(mar_out), .c(trapzext_out), .f(mem_address)
);

mux2 mdrmux
(
	.sel(mdrmux_sel), .a(sr2_data), .b(mem_rdata), .f(mem_write_data)
);

trapzext trapzext
(
	.in(trapvect), .out(trapzext_out)
);

mux5 regfilemux
(
	.sel(regfilemux_sel), .a(alu), .b(mem_wdata), .c(mem_branch_address_out), .d(mem_pc_plus2_out), .e(zext_out), .f(regfilemux_out)
);

zext zext1 
(
	.zext_in(mem_wdata), .byte_sel(mem_byte_sel), .zext_out(zext_out)
);


performance_counter icache_miss_counter
(
	.clk(clk),
	.count_event(icache_miss),
	.reset(reset_icache_miss),
	.data_out(icache_miss_data)
);

performance_counter icache_hit_counter
(
	.clk(clk),
	.count_event(icache_hit),
	.reset(reset_icache_hit),
	.data_out(icache_hit_data)
);

performance_counter dcache_miss_counter
(
	.clk(clk),
	.count_event(dcache_miss),
	.reset(reset_dcache_miss),
	.data_out(dcache_miss_data)
);

performance_counter dcache_hit_counter
(
	.clk(clk),
	.count_event(dcache_hit),
	.reset(reset_dcache_hit),
	.data_out(dcache_hit_data)
);

performance_counter stall_counter
(
	.clk(clk),
	.count_event(stall),
	.reset(reset_stall),
	.data_out(stall_data)
);

performance_counter hazard_stall_counter
(
	.clk(clk),
	.count_event(hazard_stall),
	.reset(reset_hazard_stall),
	.data_out(hazard_stall_data)
);

performance_counter l2_miss_counter
(
	.clk(clk),
	.count_event(l2_miss),
	.reset(reset_l2_miss),
	.data_out(l2_miss_data)
);

performance_counter l2_hit_counter
(
	.clk(clk),
	.count_event(l2_hit),
	.reset(reset_l2_hit),
	.data_out(l2_hit_data)
);

performance_counter bp_counter
(
	.clk(clk),
	.count_event(reset_sig),
	.reset(reset_bp),
	.data_out(bp_data)
);

endmodule : mem_stage