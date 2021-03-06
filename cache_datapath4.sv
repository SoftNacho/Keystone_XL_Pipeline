import lc3b_types::*;
import cache_types::*;

module cache_datapath
(
	// CPU to Cache
	input clk,
	input lc3b_word mem_address,
	input lc3b_word mem_wdata,
	input lc3b_mem_wmask mem_byte_enable,
	output lc3b_word mem_rdata,
	
	// Cache Datapath to Control
	input address_sel,
	input data_read_sel,
	input addr_mux_sel,
	input logic [2:0] data_mux_sel,
	
	input load_dirty_valid0,
	input load_data0,
	input load_tag0,
	input load_dirty_valid1,
	input load_data1,
	input load_tag1,
	input load_dirty_valid2,
	input load_data2,
	input load_tag2,
	input load_dirty_valid3,
	input load_data3,
	input load_tag3,
	
	input pmem_write,
	input dirty_write,
	input load_lru,
	input logic[2:0] lru_in,
	
	output logic hit,
	output logic dirty,
	output logic [3:0] valid_array,
	output logic [3:0] hit_direction,
	output logic [2:0] lru_output,

	// Cache to Main Memory
	input cache_line pmem_rdata,
	output cache_line pmem_wdata,
	output lc3b_word pmem_address
);

/* Cache Signals */
cache_read_offset read_offset;
cache_offset offset;
cache_index index;
cache_tag tag;

assign offset = mem_address[3:0];
assign read_offset = mem_address[3:1];
assign index = mem_address[6:4];
assign tag = mem_address[15:7];

/* Way 0 Signals */
logic dirty0_out;
logic valid0_out;
cache_tag tag0_out;
cache_line data0_out;

/* Way 1 Signals */
logic dirty1_out;
logic valid1_out;
cache_tag tag1_out;
cache_line data1_out;

/* Way 2 Signals */
logic dirty2_out;
logic valid2_out;
cache_tag tag2_out;
cache_line data2_out;

/* Way 3 Signals */
logic dirty3_out;
logic valid3_out;
cache_tag tag3_out;
cache_line data3_out;

/* LRU Signals */
logic [2:0] lru_out;
assign lru_output = lru_out;
assign valid_array = {valid3_out, valid2_out, valid1_out, valid0_out};

/* MUX Signals */
cache_line datamux_out;
cache_line data_read_out;
cache_line overwrite_out;
cache_line evictmux_out;
cache_tag tag_selector_out;
lc3b_word address_mux_out;
lc3b_word form_address_out;
lc3b_word offset0_out;
lc3b_word offset1_out;
lc3b_word offset2_out;
lc3b_word offset3_out;
lc3b_word read_offset_out;

/* Cache to Main Memory Assignments */
assign pmem_wdata = evictmux_out;
assign pmem_address = address_mux_out;
assign mem_rdata = read_offset_out;

mux4_onehot_lru #(.width(1)) dirty_bit_mux
(
	.sel(lru_out),
	.a(dirty0_out),
	.b(dirty1_out),
	.c(dirty2_out),
	.d(dirty3_out),
	.f(dirty)
);

/* Way 0 */
array #(.width(1)) dirty0 
(
	.clk(clk),
	.write(load_dirty_valid0),
	.index(index),
	.datain(dirty_write),
	.dataout(dirty0_out)
);

array #(.width(9)) tag0
(
	.clk(clk),
	.write(load_tag0),
	.index(index),
	.datain(tag),
	.dataout(tag0_out)
);

array #(.width(1)) valid0
(
	.clk(clk),
	.write(load_dirty_valid0),
	.index(index),
	.datain(1'b1),
	.dataout(valid0_out)
);

array #(.width(128)) data0
(
	.clk(clk),
	.write(load_data0),
	.index(index),
	.datain(data_read_out),
	.dataout(data0_out)
);

/* Way 1 */
array #(.width(1)) dirty1 
(
	.clk(clk),
	.write(load_dirty_valid1),
	.index(index),
	.datain(dirty_write),
	.dataout(dirty1_out)
);

array #(.width(9)) tag1
(
	.clk(clk),
	.write(load_tag1),
	.index(index),
	.datain(tag),
	.dataout(tag1_out)
);

array #(.width(1)) valid1
(
	.clk(clk),
	.write(load_dirty_valid1),
	.index(index),
	.datain(1'b1),
	.dataout(valid1_out)
);

array #(.width(128)) data1
(
	.clk(clk),
	.write(load_data1),
	.index(index),
	.datain(data_read_out),
	.dataout(data1_out)
);


/* Way 2 */
array #(.width(1)) dirty2 
(
	.clk(clk),
	.write(load_dirty_valid2),
	.index(index),
	.datain(dirty_write),
	.dataout(dirty2_out)
);

array #(.width(9)) tag2
(
	.clk(clk),
	.write(load_tag2),
	.index(index),
	.datain(tag),
	.dataout(tag2_out)
);

array #(.width(1)) valid2
(
	.clk(clk),
	.write(load_dirty_valid2),
	.index(index),
	.datain(1'b1),
	.dataout(valid2_out)
);

array #(.width(128)) data2
(
	.clk(clk),
	.write(load_data2),
	.index(index),
	.datain(data_read_out),
	.dataout(data2_out)
);


/* Way 3 */
array #(.width(1)) dirty3
(
	.clk(clk),
	.write(load_dirty_valid3),
	.index(index),
	.datain(dirty_write),
	.dataout(dirty3_out)
);

array #(.width(9)) tag3
(
	.clk(clk),
	.write(load_tag3),
	.index(index),
	.datain(tag),
	.dataout(tag3_out)
);

array #(.width(1)) valid3
(
	.clk(clk),
	.write(load_dirty_valid3),
	.index(index),
	.datain(1'b1),
	.dataout(valid3_out)
);

array #(.width(128)) data3
(
	.clk(clk),
	.write(load_data3),
	.index(index),
	.datain(data_read_out),
	.dataout(data3_out)
);

/* LRU */
array #(.width(3)) lru
(
	.clk(clk),
	.write(load_lru),
	.index(index),
	.datain(lru_in),
	.dataout(lru_out)
);

mux4_onehot_lru #(.width(128)) data_mux
(
	.sel(data_mux_sel),
	.a(data0_out),
	.b(data1_out),
	.c(data2_out),
	.d(data3_out),
	.f(datamux_out)
);

mux4_onehot_evict #(.width(128)) evict_mux
(
	.sel(data_mux_sel),
	.a(data0_out),
	.b(data1_out),
	.c(data2_out),
	.d(data3_out),
	.f(evictmux_out)
);

mux8 offset0_mux
(
	.sel(read_offset),
	.a(data0_out[15:0]),
	.b(data0_out[31:16]),
	.c(data0_out[47:32]),
	.d(data0_out[63:48]),
	.e(data0_out[79:64]),
	.g(data0_out[95:80]),
	.h(data0_out[111:96]),
	.i(data0_out[127:112]),
	.f(offset0_out)
);

mux8 offset1_mux
(
	.sel(read_offset),
	.a(data1_out[15:0]),
	.b(data1_out[31:16]),
	.c(data1_out[47:32]),
	.d(data1_out[63:48]),
	.e(data1_out[79:64]),
	.g(data1_out[95:80]),
	.h(data1_out[111:96]),
	.i(data1_out[127:112]),
	.f(offset1_out)
);

mux8 offset2_mux
(
	.sel(read_offset),
	.a(data2_out[15:0]),
	.b(data2_out[31:16]),
	.c(data2_out[47:32]),
	.d(data2_out[63:48]),
	.e(data2_out[79:64]),
	.g(data2_out[95:80]),
	.h(data2_out[111:96]),
	.i(data2_out[127:112]),
	.f(offset2_out)
);

mux8 offset3_mux
(
	.sel(read_offset),
	.a(data3_out[15:0]),
	.b(data3_out[31:16]),
	.c(data3_out[47:32]),
	.d(data3_out[63:48]),
	.e(data3_out[79:64]),
	.g(data3_out[95:80]),
	.h(data3_out[111:96]),
	.i(data3_out[127:112]),
	.f(offset3_out)
);

mux4_onehot #(.width(16)) read_offset_mux
(
	.sel(hit_direction),
	.a(offset0_out),
	.b(offset1_out),
	.c(offset2_out),
	.d(offset3_out),
	.f(read_offset_out)
);

mux2 #(.width(128)) data_read_mux
(
	.sel(data_read_sel),
	.a(overwrite_out),
	.b(pmem_rdata),
	.f(data_read_out)
);

overwrite overwrite1
(
	.offset(read_offset),
	.mem_byte_enable(mem_byte_enable),
	.data_in(datamux_out),
	.mem_wdata(mem_wdata),
	.data_out(overwrite_out)
);

hit_detector hit_detector1
(
	.tag0(tag0_out),
	.tag1(tag1_out),
	.tag2(tag2_out),
	.tag3(tag3_out),
	.tag_orig(tag),
	.valid0(valid0_out),
	.valid1(valid1_out),
	.valid2(valid2_out),
	.valid3(valid3_out),
	.hit(hit),
	.hit_direction(hit_direction)
);

// TODO
mux4_onehot_lru #(.width(9)) tag_selector_mux
(
	.sel(lru_out),
	.a(tag0_out),
	.b(tag1_out),
	.c(tag2_out),
	.d(tag3_out),
	.f(tag_selector_out)
);

form_address form_address1
(
	.index(index),
	.offset(offset),
	.tag(tag_selector_out),
	.address(form_address_out)
);

mux2 address_mux
(
	.sel(addr_mux_sel),
	.a({mem_address}),
	.b(form_address_out),
	.f(address_mux_out)
);

endmodule : cache_datapath