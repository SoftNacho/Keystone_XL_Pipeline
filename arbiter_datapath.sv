import lc3b_types::*;
import cache_types::*;

module arbiter_datapath
(
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
	
	//from controller
	input instr_service,
	input data_service,
	
	// from L2 cache
	input cache_line pmem_rdata,
	
	// to L1 caches
	output cache_line mem_wdata,
	
	// to L2 cache
	output cache_line pmem_wdata,
	output lc3b_word pmem_address,
	output logic pmem_read,
	output logic pmem_write
);


assign mem_wdata = pmem_rdata;

always_comb
begin
		pmem_wdata = 0;
		pmem_address = 0; 
		pmem_read = 0;
		pmem_write = 0;
		
		if(data_service)
		begin
			pmem_wdata = dpmem_wdata;
			pmem_address = dpmem_address;
			pmem_read = dpmem_read;
			pmem_write = dpmem_write;
		end
	else if (instr_service)
		begin
			pmem_wdata = ipmem_wdata;
			pmem_address = ipmem_address;
			pmem_read = ipmem_read;
			pmem_write = ipmem_write;		
		end
end

endmodule : arbiter_datapath