import lc3b_types::*;
import cache_types::*;

module cache
(
	input clk,
	
	// Signal between CPU Datapath and Cache
	input lc3b_word mem_address,
	input lc3b_word mem_wdata,
	input logic mem_read,
	input logic mem_write,
	input lc3b_mem_wmask mem_byte_enable,
	
	output lc3b_word mem_rdata,
	output logic mem_resp,
	
	// Signals between Cache and Main Memory
	input cache_line pmem_rdata,
	input logic pmem_resp,
	
	output cache_line pmem_wdata,
	output lc3b_word pmem_address,
	output logic pmem_read,
	output logic pmem_write
);

logic address_sel;
logic data_read_sel;
logic addr_mux_sel;
logic [2:0] data_mux_sel;

logic compare0;
logic compare1;
logic [2:0] lru_out; 
logic [2:0] lru_in;
logic [3:0] valid_array;

logic hit;
logic [3:0] hit_direction;
logic dirty;
logic dirty_write;

logic load_dirty_valid0, load_tag0, load_data0;
logic load_dirty_valid1, load_tag1, load_data1;
logic load_dirty_valid2, load_tag2, load_data2;
logic load_dirty_valid3, load_tag3, load_data3;
logic load_lru;


logic pmem_write_internal;
assign pmem_write = pmem_write_internal;

cache_datapath datapath
(
	// CPU to Cache
	.clk(clk),
	.mem_address(mem_address),
	.mem_wdata(mem_wdata),
	.mem_rdata(mem_rdata),
	.mem_byte_enable(mem_byte_enable),
		
	// Cache Datapath to Control
	.pmem_write(pmem_write_internal),
	.address_sel(address_sel),
	.data_read_sel(data_read_sel),
	.addr_mux_sel(addr_mux_sel),
	.data_mux_sel(data_mux_sel),
	
	.hit(hit),
	.dirty(dirty),
	.dirty_write(dirty_write),
	.lru_output(lru_out),
	.hit_direction(hit_direction),
	.valid_array(valid_array),
	
	.load_dirty_valid0(load_dirty_valid0),
	.load_data0(load_data0),
	.load_tag0(load_tag0),
	.load_dirty_valid1(load_dirty_valid1),
	.load_data1(load_data1),
	.load_tag1(load_tag1),	
	.load_dirty_valid2(load_dirty_valid2),
	.load_data2(load_data2),
	.load_tag2(load_tag2),
	.load_dirty_valid3(load_dirty_valid3),
	.load_data3(load_data3),
	.load_tag3(load_tag3),
	.load_lru(load_lru),
	.lru_in(lru_in),
	
	// Cache to Main Memory
	.pmem_rdata(pmem_rdata),
	.pmem_wdata(pmem_wdata),
	.pmem_address(pmem_address)
);

cache_control control
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
	.data_mux_sel(data_mux_sel),

	.hit(hit),
	.dirty(dirty),
	.dirty_write(dirty_write),
	.valid_array(valid_array),
	
	.load_dirty_valid0(load_dirty_valid0),
	.load_data0(load_data0),
	.load_tag0(load_tag0),
	.load_dirty_valid1(load_dirty_valid1),
	.load_data1(load_data1),
	.load_tag1(load_tag1),
	.load_dirty_valid2(load_dirty_valid2),
	.load_data2(load_data2),
	.load_tag2(load_tag2),
	.load_dirty_valid3(load_dirty_valid3),
	.load_data3(load_data3),
	.load_tag3(load_tag3),
	.lru_output(lru_out),
	.load_lru(load_lru),
	.lru_in(lru_in),
	.hit_direction(hit_direction),
	
	// Cache to Main Memory
	.pmem_read(pmem_read),
	.pmem_write(pmem_write_internal),
	.pmem_resp(pmem_resp)
);


endmodule : cache