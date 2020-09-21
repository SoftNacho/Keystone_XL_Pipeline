import lc3b_types::*;

module cpu
(
	input clk,
	
	//Mem to CPU
	input lc3b_word imem_rdata,
	input imem_resp,
	input lc3b_word mem_rdata,
	input mem_resp,
	
	//CPU to Mem
	output imem_read,
	output lc3b_word imem_address,
	output mem_read,
	output mem_write,
	output lc3b_mem_wmask mem_byte_enable,
	output lc3b_word mem_address,
	output lc3b_word mem_wdata,
	
	input icache_miss,
	input dcache_miss,
	input icache_hit,
	input dcache_hit,
	input l2_hit,
	input l2_miss
);

cpu_datapath mylittlecpu(.*);

endmodule : cpu