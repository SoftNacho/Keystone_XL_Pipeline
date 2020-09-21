import lc3b_types::*;

module cpu_datapath
(
	input clk,
	//Mem to Datapath
	input lc3b_word mem_rdata,
	input lc3b_word imem_rdata,
	input mem_resp,
	input imem_resp,
	
	//Datapath to Mem
	output lc3b_word imem_address,
	output imem_read,
	output mem_read,
	output mem_write,
	output lc3b_mem_wmask mem_byte_enable,
	output lc3b_word mem_address,
	output lc3b_word mem_wdata,
	
	// Performance Counters
	input icache_miss,
	input dcache_miss,
	input icache_hit,
	input dcache_hit,
	input l2_hit,
	input l2_miss
);

/*Stage Loads */
logic load_stages;
logic global_stall;
logic hazard_stall;
logic ctrl_hazard_stall;
logic ifid_write;
logic reset_sig; 
logic ctrl_hazard;
lc3b_opcode id_opcode;
//assign imem_read = clk;

/*IF intermediate logics*/
lc3b_word pc_inc_out;
lc3b_word pc_out;
lc3b_control_word if_control_word;
lc3b_word if_instruction;


/*ID intermediate logics*/
lc3b_word id_instruction;
lc3b_word id_regfile_in;
lc3b_reg id_dest;
lc3b_control_word id_control_word_out;
logic id_reset;

lc3b_word id_pc_out;
lc3b_word id_pc_plus2_out;
lc3b_word id_pc;
lc3b_reg id_dr_out;
lc3b_reg id_rs_out;
lc3b_reg id_rt_out;
lc3b_word id_sr1_out;
lc3b_word id_sr2_out;
lc3b_nzp id_nzp_out;
lc3b_word id_imm4_out;
lc3b_word id_sext5_out;
lc3b_word id_sext6_out;
lc3b_word id_adj6_out;
lc3b_word id_adj9_out;
lc3b_word id_adj11_out;
lc3b_control_word id_control_word;

lc3b_reg wb_dest;
lc3b_word branch_address;
lc3b_word alu_out;
lc3b_word mem_data;

//EXMEM intermediate logics
lc3b_word sr2_forward;
lc3b_word ex_pc;
lc3b_word ex_pc_plus2;
lc3b_reg ex_dr;
lc3b_reg ex_rs;
lc3b_reg ex_rt;
lc3b_word ex_sr1;
lc3b_word ex_sr2;
lc3b_word ex_imm4;
lc3b_word ex_sext5;
lc3b_word ex_sext6;
lc3b_word ex_adj6;
lc3b_word ex_adj9;
lc3b_word ex_adj11;
lc3b_nzp ex_nzp;
lc3b_word ex_branch_address_out;
lc3b_word ex_alu_out;
lc3b_reg ex_destmux_out;
lc3b_control_word ex_control_word;
lc3b_nzp ex_nzp_out;
logic [1:0] ex_forwardA;
logic [1:0] ex_forwardB;

/*MEM intermediate logics*/
lc3b_word mem_pc_plus2_out;
lc3b_word mem_branch_address_out;
lc3b_reg mem_dr_out;
lc3b_word mem_alu_out;
lc3b_word mem_pc_out;
lc3b_control_word mem_control_word;
logic branch_enable, branch_enable_out;
lc3b_nzp mem_nzp_out;
lc3b_word mem_sr2_out;
logic mem_byte_sel;

/*WB intermediate logics*/
lc3b_word wb_pc_plus2;
lc3b_word wb_branch_address;
lc3b_reg wb_dr;
lc3b_word wb_alu;
lc3b_word wb_mem_data;
lc3b_word wb_pc;
lc3b_control_word wb_control_word;
//lc3b_nzp mem_nzp_out;
lc3b_word wb_trap_data;
logic mem_branch_enable;
logic wb_byte_sel;

assign load_stages = ~global_stall & ~ctrl_hazard_stall;
assign ifid_write = load_stages & ~hazard_stall;
assign id_opcode = lc3b_opcode'(16'(id_instruction[15:12]));

//IF Stage
if_stage if_stage
(
	.clk, .id_opcode, .imem_resp, .imem_read, .hazard_stall, .ctrl_hazard, .ctrl_hazard_stall, .global_stall, .jsr_address(mem_branch_address_out), .alu_out(mem_alu_out), .pc_inc_out, .wb_opcode(mem_control_word.opcode), /*.wb_nzp(mem_nzp_out),*/
	.imem_rdata, .instruction_out(if_instruction), .imem_address, .wb_pc_plus2, .if_control_word_out(if_control_word), .dr_in_prog(ex_dr), .branch_enable(mem_branch_enable), .pcmux_sel(mem_control_word.pcmux_sel), 
	/*.adj9_out(if_adj9),*/ .trap_data(mem_wdata), .reset_sig
);

//IFID
if_stage_register IFID
(
	.clk, .load(ifid_write), .reset_sig, .pc_plus2(pc_inc_out), .instruction(if_instruction), .control_word(if_control_word), /*.adj9(if_adj9), */
	.pc_plus2_out(id_pc_plus2_out), .instruction_out(id_instruction), .control_word_out(id_control_word) //, .adj9_out(id_adj9_out)
);


//ID Stage
id_stage id_stage
(
	.clk, .ir(id_instruction), .regfile_in(id_regfile_in), .dest_in(wb_dr), .load_regfile(wb_control_word.load_regfile), .storemux_sel(id_control_word.storemux_sel), .id_control_word,
	.idex_mem_read(ex_control_word.mem_read), .idex_rd(ex_dr), .dr(id_dr_out), .sr1(id_sr1_out), .sr2(id_sr2_out), .nzp(id_nzp_out), .imm4_out(id_imm4_out), .sext5_out(id_sext5_out), 
	.sext6_out(id_sext6_out), .adj6_out(id_adj6_out), .adj9_out(id_adj9_out), .adj11_out(id_adj11_out), .rs(id_rs_out), .rt(id_rt_out), .id_control_word_out, .hazard_stall, .check_rs(id_control_word.check_rs), .check_rt(id_control_word.check_rt),
	.id_reset
);

//IDEX
id_stage_register IDEX
(
	.clk, .load(load_stages), .reset_sig, .pc_plus2(id_pc_plus2_out), .dr(id_dr_out), .sr1(id_sr1_out), .sr2(id_sr2_out), .imm4(id_imm4_out),
	.sext5(id_sext5_out), .sext6(id_sext6_out), .adj6(id_adj6_out), .adj9(id_adj9_out), .adj11(id_adj11_out), .rs(id_rs_out), .rt(id_rt_out),
	.pc_plus2_out(ex_pc_plus2), .rs_out(ex_rs), .rt_out(ex_rt), .dr_out(ex_dr), .sr1_out(ex_sr1), .sr2_out(ex_sr2), .imm4_out(ex_imm4), .sext5_out(ex_sext5),
	.sext6_out(ex_sext6), .adj6_out(ex_adj6), .adj9_out(ex_adj9), .adj11_out(ex_adj11), .control_word(id_control_word_out), .control_word_out(ex_control_word),
	.nzp(id_nzp_out), .nzp_out(ex_nzp_out), .id_reset
);

//EX Stage
ex_stage ex_stage
(
	.pc_plus2(ex_pc_plus2), .sr1(ex_sr1), .sr2(ex_sr2), .rs(ex_rs), .rt(ex_rt), .dr(ex_dr), .imm4(ex_imm4), .sext5(ex_sext5), .sext6(ex_sext6), .adj6(ex_adj6), .adj9(ex_adj9), .adj11(ex_adj11),
	.check_rs(ex_control_word.check_rs), .check_rt(ex_control_word.check_rt), .check_rd(ex_control_word.check_rd), .exmem_alu(mem_alu_out), .wb_reg(id_regfile_in), .alumux_sel(ex_control_word.alumux_sel), 
	.destmux_sel(ex_control_word.destmux_sel), .addermux_sel(ex_control_word.addermux_sel), .aluop(ex_control_word.aluop), .mem_regwrite(mem_control_word.load_regfile), .wb_regwrite(wb_control_word.load_regfile),
	.exmem_opcode(mem_control_word.opcode), .exmem_branch_address(mem_branch_address_out),
	.branch_address(ex_branch_address_out), .alu_out(ex_alu_out), .destmux_out(ex_destmux_out), .memwb_rd(wb_dr), .exmem_rd(mem_dr_out), .sr2_forward
);

//EXMEM
ex_stage_register ex_stage_register
(
	.clk, .load(load_stages), .reset_sig, .pc_plus2(ex_pc_plus2), .branch_address(ex_branch_address_out), .alu(ex_alu_out), .dr(ex_destmux_out), .control_word(ex_control_word),
	.pc_plus2_out(mem_pc_plus2_out), .branch_address_out(mem_branch_address_out), .alu_out(mem_alu_out), .dr_out(mem_dr_out), .control_word_out(mem_control_word),
	.nzp(ex_nzp_out), .nzp_out(mem_nzp_out), .sr2_data(sr2_forward), .sr2_data_out(mem_sr2_out)
);

//MEM Stage
mem_stage mem_stage
(
	.clk, .mem_resp_in(mem_resp), .alu(mem_alu_out), .mem_rdata, .marmux_sel(mem_control_word.marmux_sel), .mdrmux_sel(mem_control_word.mdrmux_sel), 
	.mem_address(mem_address), .mem_wdata(mem_wdata), .mem_read_in(mem_control_word.mem_read), .mem_read_out(mem_read), .mem_byte_sel,
	.sr2_data(mem_sr2_out), .mem_write_in(mem_control_word.mem_write), .mem_write_out(mem_write), .stall(global_stall), .mem_byte_enable, .opcode(mem_control_word.opcode),
	.trapvect(mem_control_word.trapvect), .icache_miss(icache_miss), .dcache_miss(dcache_miss), .icache_hit(icache_hit), .dcache_hit(dcache_hit), .hazard_stall, .l2_miss, .l2_hit,
	.reset_sig, .load_cc(mem_control_word.load_cc), .nzp(mem_nzp_out),  .branch_enable(mem_branch_enable), .ctrl_hazard, .mem_branch_address_out, .mem_pc_plus2_out, .regfilemux_sel(mem_control_word.regfilemux_sel)
);

//MEMWB
mem_stage_register MEMWB
(
	.clk, .load(load_stages), .reset_sig(1'b0), .branch_address(mem_branch_address_out), .dr(mem_dr_out), .alu(mem_alu_out), .mem_data(mem_wdata), .byte_sel(mem_byte_sel),
	.pc_plus2(mem_pc_plus2_out), .control_word(mem_control_word), .branch_address_out(wb_branch_address), .dr_out(wb_dr), 
	.alu_out(wb_alu), .mem_data_out(wb_mem_data), .pc_plus2_out(wb_pc_plus2), .control_word_out(wb_control_word), .byte_sel_out(wb_byte_sel)
);

//WB Stage
wb_stage wb_stage
(
	.alu_out(wb_alu), .branch_address(wb_branch_address), .pc_plus2(wb_pc_plus2), .regfilemux_sel(wb_control_word.regfilemux_sel), 
	.mem_wdata(wb_mem_data), .byte_sel(wb_byte_sel), .regfilemux_out(id_regfile_in), .mem_data(wb_trap_data) 
);

endmodule : cpu_datapath