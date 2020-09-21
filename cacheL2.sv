import lc3b_types::*;
import cache_types::*;

module cacheL2
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
	
	output logic hit_out,
	output logic miss_out,
	
	output logic eviction,
	output logic hit_or_miss,
	output logic retrieve_data,
	output logic valid
);

logic address_sel;
logic data_read_sel;
logic addr_mux_sel;
logic data_mux_sel;
logic data_write_sel;

logic compare0;
logic compare1;
logic lru_out; 
logic hit;
logic miss;
logic dirty;
logic dirty_write;

logic load_dirty_valid0, load_tag0, load_data0;
logic load_dirty_valid1, load_tag1, load_data1;
logic load_lru;

logic lru_in;

logic pmem_write_internal;
assign pmem_write = pmem_write_internal;

assign miss_out = miss;
assign hit_out = hit;

cache_datapathL2 datapath
(
	// CPU to Cache
	.clk(clk),
	.mem_address(mem_address),
	.mem_wdata(mem_wdata),
	.mem_rdata(mem_rdata),
	.mem_byte_enable(mem_byte_enable),
		
	// Cache Datapath to Control
	.address_sel(address_sel),
	.data_read_sel(data_read_sel),
	.addr_mux_sel(addr_mux_sel),
	.data_write_sel(data_write_sel),
	.hit(hit),
	.dirty(dirty),
	.dirty_write(dirty_write),
	.load_dirty_valid0(load_dirty_valid0),
	.load_data0(load_data0),
	.load_tag0(load_tag0),
	.load_dirty_valid1(load_dirty_valid1),
	.load_data1(load_data1),
	.load_tag1(load_tag1),
	.pmem_write(pmem_write_internal),
	.compare0_out(compare0),
	.compare1_out(compare1),
	.lru_output(lru_out),
	.data_mux_sel(data_mux_sel),
	.load_lru(load_lru),
	.lru_in(lru_in),
	.valid_out(valid),
	
	// Cache to Main Memory
	.pmem_rdata(pmem_rdata),
	.pmem_wdata(pmem_wdata),
	.pmem_address(pmem_address)
);

cache_controlL2 control
(
	// CPU to Cache
	.clk(clk),
	.mem_read(mem_read),
	.mem_write(mem_write),
	.mem_resp(mem_resp),	
	
	// Cache Control to Datapath
	.address_sel(address_sel),
	.data_read_sel(data_read_sel),
	.addr_mux_sel(addr_mux_sel),
	.data_write_sel(data_write_sel),
	.hit(hit),
	.miss(miss),
	.dirty(dirty),
	.dirty_write(dirty_write),
	.load_dirty_valid0(load_dirty_valid0),
	.load_data0(load_data0),
	.load_tag0(load_tag0),
	.load_dirty_valid1(load_dirty_valid1),
	.load_data1(load_data1),
	.load_tag1(load_tag1),
	.compare0(compare0),
	.compare1(compare1),
	.lru_output(lru_out),
	.data_mux_sel(data_mux_sel),
	.load_lru(load_lru),
	.lru_in(lru_in),
	
	.eviction_out(eviction),
	.hit_or_miss_out(hit_or_miss),
	.retrieve_data_out(retrieve_data),
	
	// Cache to Main Memory
	.pmem_read(pmem_read),
	.pmem_write(pmem_write_internal),
	.pmem_resp(pmem_resp)
);


endmodule : cacheL2