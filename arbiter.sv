import lc3b_types::*;
import cache_types::*;

module arbiter
(
	input clk,
	// from i-Cache
	input cache_line ipmem_wdata,
	input lc3b_word ipmem_address,
	input logic ipmem_read,
	input logic ipmem_write,
	
	// from d-Cache
	input cache_line dpmem_wdata,
	input lc3b_word dpmem_address,
	input logic dpmem_read,
	input logic dpmem_write,
	
	// from L2 cache
	input cache_line pmem_rdata,
	input logic pmem_resp,
	
	// to L1 caches
	output cache_line mem_wdata,
	output logic instr_resp,
	output logic data_resp,
	
	// to L2 cache
	output cache_line pmem_wdata,
	output lc3b_word pmem_address,
	output logic pmem_read,
	output logic pmem_write,
	output logic instr_service,
	output logic data_service
);

logic l2_resp;
assign l2_resp = pmem_resp;

arbiter_datapath datapath (.*);

arbiter_controller comptroller (.*);

endmodule : arbiter