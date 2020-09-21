/*import lc3b_types::*;

module KeystoneXL
(
  input clk,
  input pmem_resp,
  input cache_line pmem_rdata,
  output logic pmem_read,
  output logic pmem_write,
  output lc3b_word pmem_address,
  output cache_line pmem_wdata
);

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

cpu lc3_b (.*);


magic_memory_dp dp_is_magic
(
	.clk, .read_a(imem_read), .write_a(1'b0), .wmask_a(2'b00), .address_a(imem_address), .wdata_a(16'b0), .resp_a(imem_resp), .rdata_a(imem_rdata), 
	.read_b(mem_read), .write_b(mem_write), .wmask_b(mem_byte_enable), .address_b(mem_address), .wdata_b(mem_wdata), .resp_b(mem_resp), .rdata_b(mem_rdata)
);
//cache lc3_b_cache (.*);


endmodule : KeystoneXL*/