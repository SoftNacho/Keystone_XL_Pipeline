import lc3b_types::*;
import cache_types::*;

module KeystoneXL
(
  input clk,
  input pmem_resp,
  input cache_line pmem_rdata,
  output logic pmem_read,
  output logic pmem_write,
  output lc3b_mem_wmask pmem_byte_enable,
  output lc3b_word pmem_address,
  output cache_line pmem_wdata
);

logic l2_write_out;
cache_line l2_wdata_out;
cache_line pmem_rdata_int;
logic pmemewb_resp;
logic ewb_resp;
lc3b_word pmem_waddress;
lc3b_word pmem_raddress;

lc3b_word l2_address;
lc3b_word l2_address_arb;
cache_line l2_wdata;
cache_line l2_wdata_arb;
logic l2_read;
logic l2_read_arb;
logic l2_write;
logic l2_write_arb;
cache_line l2_cache_read_data;
logic l2_resp;

logic dpmem_resp;
cache_line dpmem_rdata;
logic dpmem_read;
logic dpmem_write;
lc3b_mem_wmask dpmem_byte_enable;
lc3b_word dpmem_address;
cache_line dpmem_wdata;


logic imem_read;
lc3b_word imem_address;
logic imem_resp;
lc3b_word imem_rdata;

logic mem_resp;
logic mem_read;
logic mem_write;
lc3b_mem_wmask mem_byte_enable;
lc3b_word mem_address;
lc3b_word mem_wdata;
lc3b_word mem_rdata;

logic ipmem_write_out;
logic dpmem_write_out;
cache_line l1_cache_write_data;

lc3b_word ipmem_address;
cache_line ipmem_wdata;
logic ipmem_read;
logic ipmem_write;

lc3b_word instr_reg_addr_out;
cache_line instr_reg_data;
logic instr_reg_read_out;
logic instr_reg_write_out;
logic instr_load;

lc3b_word data_reg_addr_out;
cache_line data_reg_data;
logic data_reg_read_out;
logic data_reg_write_out;
logic data_load;

logic icache_miss;
logic dcache_miss;
logic icache_hit;
logic dcache_hit;
logic l2_hit;
logic l2_miss;

logic data_resp;
logic instr_resp;
logic data_service;
logic instr_service;

//assign instr_load = clk;//ipmem_read || ipmem_write || pmem_resp;
//assign data_load = clk;//dpmem_read || dpmem_write || pmem_resp;

assign pmem_byte_enable = mem_byte_enable;
//assign pmemewb_resp = pmem_resp | ewb_resp;

always_comb
begin
	if (pmem_write)
		begin
			pmem_address = pmem_waddress;
			pmemewb_resp= 1'b0;
		end
	else
		begin
			pmem_address = pmem_raddress;
			if (l2_write_out)
				pmemewb_resp = ewb_resp;
			else
				pmemewb_resp = pmem_resp;
		end
	if (pmem_raddress[15:4] == pmem_waddress[15:4] && !ewb_resp)
		pmem_rdata_int = pmem_wdata;
	else
		pmem_rdata_int = pmem_rdata;
end

cpu lc3_b (.*);
/*
arbiter ARBYS_WE_HAVE_THE_MEATS
(
	.ipmem_wdata(instr_reg_data), .ipmem_address(instr_reg_addr_out), .ipmem_read(instr_reg_read_out), .ipmem_write(instr_reg_write_out), .dpmem_wdata(data_reg_data), .dpmem_address(data_reg_addr_out), 
	.dpmem_read(data_reg_read_out), .dpmem_write(data_reg_write_out), 
	.pmem_rdata, .pmem_resp, .mem_wdata(l1_cache_write_data), .ipmem_write_out, .dpmem_write_out, 
	.pmem_wdata, .pmem_address, .pmem_read, .pmem_write
);
*/

arbiter ARBYS_WE_HAVE_THE_MEATS
(
	.clk, .ipmem_wdata, .ipmem_address, .ipmem_read, .ipmem_write, .dpmem_wdata, .dpmem_address, 
	.dpmem_read, .dpmem_write, 
	.pmem_rdata(l2_cache_read_data), .pmem_resp(l2_resp), .mem_wdata(l1_cache_write_data), .instr_resp, .data_resp, 
	.pmem_wdata(l2_wdata_arb), .pmem_address(l2_address_arb), .pmem_read(l2_read_arb), .pmem_write(l2_write_arb), .instr_service, .data_service
);


// might be able to get rid of pmem_rdata in arbys
/*
cache_level_split_register instruction_register
(
	.clk, .load(1'b1),.address(ipmem_address), .data(ipmem_wdata), .read(ipmem_read), .write(ipmem_write), .address_out(instr_reg_addr_out), 
	.data_out(instr_reg_data),  .read_out(instr_reg_read_out), .write_out(instr_reg_write_out)
);

cache_level_split_register data_register
(
	.clk, .load(1'b1), .address(dpmem_address), .data(dpmem_wdata), .read(dpmem_read), .write(dpmem_write), .address_out(data_reg_addr_out), 
	.data_out(data_reg_data), .read_out(data_reg_read_out), .write_out(data_reg_write_out)
);
*/

cache_level_split_register multicyclone
(
		.clk, .load(1'b1), .address(l2_address_arb), .data(l2_wdata_arb), .read(l2_read_arb), .write(l2_write_arb), .address_out(l2_address),
		.data_out(l2_wdata), .read_out(l2_read), .write_out(l2_write)
);

cache d_cache 
(
	.clk, .mem_address(mem_address), .mem_wdata(mem_wdata), .mem_read(mem_read), .mem_write(mem_write), .mem_byte_enable(mem_byte_enable),
	.mem_rdata(mem_rdata), .mem_resp(mem_resp), .pmem_rdata(l1_cache_write_data), .pmem_resp(data_resp), 
	.pmem_wdata(dpmem_wdata), .pmem_address(dpmem_address), .pmem_read(dpmem_read), .pmem_write(dpmem_write), .miss_out(dcache_miss), .hit_out(dcache_hit)
);

cache i_cache
(
	.clk, .mem_address(imem_address), .mem_wdata(16'b0), .mem_read(imem_read), .mem_write(1'b0), .mem_byte_enable(2'b11),
	.mem_rdata(imem_rdata), .mem_resp(imem_resp), .pmem_rdata(l1_cache_write_data), .pmem_resp(instr_resp), 
	.pmem_wdata(ipmem_wdata), .pmem_address(ipmem_address), .pmem_read(ipmem_read), .pmem_write(ipmem_write), .miss_out(icache_miss), .hit_out(icache_hit)
);


eightway_cache hehehehe 
(
	.clk, .mem_address(l2_address), .mem_wdata(l2_wdata), .mem_read(l2_read), .mem_write(l2_write), .mem_byte_enable(2'b11),
	.mem_rdata(l2_cache_read_data), .mem_resp(l2_resp), .pmem_rdata(pmem_rdata_int), .pmem_resp(pmemewb_resp), 
	.pmem_wdata(l2_wdata_out), .pmem_address(pmem_raddress), .pmem_read, .pmem_write(l2_write_out), .miss_out(l2_miss), .hit_out(l2_hit)
);

eviction_write_buffer ewb
(
	.clk, .address(pmem_raddress), .write(l2_write_out), .pmem_read, .din(l2_wdata_out), .pmem_resp, .resp(ewb_resp), .dout(pmem_wdata), .address_out(pmem_waddress), .pmem_write
);


endmodule : KeystoneXL