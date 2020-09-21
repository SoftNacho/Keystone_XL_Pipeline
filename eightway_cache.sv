import cache_types::*;
import lc3b_types::*;

import cache_types::*;
import lc3b_types::*;

module eightway_cache 
(
	input clk,
	
	// Signal between CPU Datapath and Cache
	input lc3b_word mem_address,
	input cache_line mem_wdata,
	input logic mem_read,
	input logic mem_write,
	input lc3b_mem_wmask mem_byte_enable,
	
	output cache_line mem_rdata,
	output logic mem_resp,
	
	// Signals between Cache and Main Memory
	input cache_line pmem_rdata,
	input logic pmem_resp,
	
	output cache_line pmem_wdata,
	output lc3b_word pmem_address,
	output logic pmem_read,
	output logic pmem_write,
	
	output hit_out,
	output miss_out
);

// inputs to cache
cache_line mem_wdata_cache0, mem_wdata_cache1;
logic mem_read_cache0, mem_read_cache1;
logic mem_write_cache0, mem_write_cache1;
cache_line pmem_rdata0, pmem_rdata1;
logic pmem_resp0, pmem_resp1;

//outputs of cache
cache_line mem_rdata0, mem_rdata1;
logic mem_resp0, mem_resp1;
cache_line pmem_wdata0, pmem_wdata1;
lc3b_word pmem_address0, pmem_address1;
logic pmem_read0, pmem_read1;
logic pmem_write0, pmem_write1;
logic hit0, hit1, miss0, miss1;

//state variables from caches
logic eviction, retrieve_data, hit_or_miss;
logic eviction0, retrieve_data0, hit_or_miss0;
logic eviction1, retrieve_data1, hit_or_miss1;
logic lru, lru_in, load_lru;
cache_index index;

assign eviction = eviction0 | eviction1;
assign retrieve_data = retrieve_data0 | retrieve_data1;
assign hit_or_miss = hit_or_miss0 & hit_or_miss1;
assign hit_out = hit0 | hit1;
assign miss_out = 1'b0;
assign index = mem_address[6:4];
 
always_comb
begin
	lru_in = 1'b0;
	load_lru = 1'b0;
	mem_resp = 1'b0;
	mem_read_cache0 = 1'b0;
	mem_write_cache0 = 1'b0;
	mem_read_cache1 = 1'b0;
	mem_write_cache1 = 1'b0;
	mem_wdata_cache0 = 128'b0;
	mem_wdata_cache1 = 128'b0;
	mem_rdata = 128'b0;
	pmem_read = 1'b0;
	pmem_write = 1'b0;
	pmem_address = 16'b0;
	pmem_wdata = 128'b0;
	pmem_rdata0 = 128'b0;
	pmem_rdata1 =128'b0;
	pmem_resp0 = 1'b0;
	pmem_resp1 =1'b0;
	
	if (hit_or_miss == 1'b1)
	begin
		if (hit0 == 1'b1)
			begin
				if(mem_resp0)
					begin
						mem_resp = mem_resp0;
						lru_in = 1'b1;
						load_lru = 1'b1;
					end
				if (mem_read == 1'b1)
					begin
						mem_read_cache0 = 1'b1;
						mem_write_cache0 = 1'b0;
						mem_rdata = mem_rdata0;
					end
				else if (mem_write == 1'b1)
					begin
						mem_read_cache0 = 1'b0;
						mem_write_cache0 = 1'b1;
						mem_wdata_cache0 = mem_wdata;
					end
			end
		
		else if (hit1 == 1'b1)
			begin
				if (mem_resp1)
					begin
						mem_resp = mem_resp1;
						lru_in = 1'b0;
						load_lru = 1'b1;
					end
				if (mem_read == 1'b1)
					begin
						mem_read_cache1 = 1'b1;
						mem_write_cache1 = 1'b0;
						mem_rdata = mem_rdata1;					
					end
				else if (mem_write == 1'b1)
					begin
						mem_read_cache1 = 1'b0;
						mem_write_cache1 = 1'b1;
						mem_wdata_cache1 = mem_wdata;
					end				
			end
			
		else if (hit0 == 1'b0 && hit1 == 1'b0)
			begin
				if (lru == 1'b0)
					begin
						mem_read_cache0 = mem_read;
						mem_write_cache0 = mem_write;					
					end
				else if (lru == 1'b1)
					begin
						mem_read_cache1 = mem_read;
						mem_write_cache1 = mem_write;					
					end
				end
	end
			
	else if (eviction == 1'b1)
	begin
		if (lru == 1'b0)
			begin
				pmem_read = pmem_read0;
				pmem_write = pmem_write0;
				pmem_address = pmem_address0;
				pmem_wdata = pmem_wdata0;
				pmem_resp0 = pmem_resp;
			end
			
		else if (lru == 1'b1)
			begin
				pmem_read = pmem_read1;
				pmem_write = pmem_write1;
				pmem_address = pmem_address1;
				pmem_wdata = pmem_wdata1;
				pmem_resp1 = pmem_resp;
			end
	end
	
	else if (retrieve_data == 1'b1)
	begin
		if (lru == 1'b0)
			begin
				pmem_read = pmem_read0;
				pmem_write = pmem_write0;
				pmem_address = pmem_address0;
				pmem_rdata0 = pmem_rdata;
				pmem_resp0 = pmem_resp;
			end
		else if (lru == 1'b1)
			begin
				pmem_read = pmem_read1;
				pmem_write = pmem_write1;
				pmem_address = pmem_address1;
				pmem_rdata1 = pmem_rdata;
				pmem_resp1 = pmem_resp;
			end		
	end
	
end

four_waycache its_an_orgy_now
(
	.clk, .mem_address(mem_address), .mem_wdata(mem_wdata_cache0), .mem_read(mem_read_cache0), .mem_write(mem_write_cache0), .mem_byte_enable(2'b11),
	.mem_rdata(mem_rdata0), .mem_resp(mem_resp0), .pmem_rdata(pmem_rdata0), .pmem_resp(pmem_resp0), 
	.pmem_wdata(pmem_wdata0), .pmem_address(pmem_address0), .pmem_read(pmem_read0), .pmem_write(pmem_write0), .miss_out(miss0), .hit_out(hit0),
   .eviction_out(eviction0), .hit_or_miss_out(hit_or_miss0), .retrieve_data_out(retrieve_data0)
);

four_waycache winky_face_p3
(
	.clk, .mem_address(mem_address), .mem_wdata(mem_wdata_cache1), .mem_read(mem_read_cache1), .mem_write(mem_write_cache1), .mem_byte_enable(2'b11),
	.mem_rdata(mem_rdata1), .mem_resp(mem_resp1), .pmem_rdata(pmem_rdata1), .pmem_resp(pmem_resp1), 
	.pmem_wdata(pmem_wdata1), .pmem_address(pmem_address1), .pmem_read(pmem_read1), .pmem_write(pmem_write1), .miss_out(miss1), .hit_out(hit1),
   .eviction_out(eviction1), .hit_or_miss_out(hit_or_miss1), .retrieve_data_out(retrieve_data1)
);

array #(.width(1)) lru_reg
(
	.clk(clk),
	.write(load_lru),
	.index(index),
	.datain(lru_in),
	.dataout(lru)
);

endmodule : eightway_cache