import lc3b_types::*;
import cache_types::*;

module eviction_write_buffer
(
	input clk,
	input lc3b_word address,
	input write,
	input pmem_read,
	input cache_line din,
	input pmem_resp,
	
	output logic resp,
	output cache_line dout,
	output lc3b_word address_out,
	output logic pmem_write
);

logic full;
logic load;
cache_line data;
lc3b_word data_address;

eviction_write_buffer_control ewb_command_center (.*);

assign resp = ~full;

initial
begin
	full = 1'b0;
	data = 0;
	data_address = 0;
end

always_comb
begin
	dout = data;
	address_out = data_address;
end

always_ff @ (posedge clk)
begin
	if (load)
		begin
			data <= din;
			full <= 1'b1;
			data_address <= address;
		end
	else if (pmem_write && pmem_resp)
		begin
			full <= 1'b0;
		end
end

endmodule : eviction_write_buffer