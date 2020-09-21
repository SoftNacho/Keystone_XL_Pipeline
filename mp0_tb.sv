import lc3b_types::*;
import cache_types::*;
module mp0_tb;

timeunit 1ns;
timeprecision 1ns;

logic clk;
logic pmem_resp;
logic pmem_read;
logic pmem_write;
cache_line pmem_rdata;

lc3b_mem_wmask pmem_byte_enable;
lc3b_word pmem_address;
cache_line pmem_wdata;

/* Clock generator */
initial clk = 0;
always #5 clk = ~clk;

KeystoneXL NattyLight
(
	.clk, .pmem_resp, .pmem_rdata, .pmem_read, .pmem_write, .pmem_address, .pmem_byte_enable, .pmem_wdata
);

physical_memory phys_mem
(
	.clk, .read(pmem_read), .write(pmem_write), .address(pmem_address), .wdata(pmem_wdata), .resp(pmem_resp), .rdata(pmem_rdata)
);

endmodule : mp0_tb
