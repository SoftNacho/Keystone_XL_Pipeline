import lc3b_types::*;
import cache_types::*;

module cache_level_split_register
(
	input clk,
	input load,
	input lc3b_word address,
	input cache_line data,
	input read,
	input write,
	
	output lc3b_word address_out,
	output cache_line data_out,
	output logic read_out,
	output logic write_out
);

lc3b_word data_address;
cache_line data_data;
logic data_read;
logic data_write;

initial
begin
	data_address = 16'b0;
	data_data = 128'h0;
	data_read = 1'b0;
	data_write = 1'b0;
end

always_ff @ (posedge clk)
begin
	if (load) begin
		data_address  <= address;
		data_data <= data;
		data_read <= read;
		data_write <= write;
	end
end

always_comb
begin
	address_out = data_address;
	data_out = data_data;
	read_out = data_read;
	write_out = data_write;
end

endmodule : cache_level_split_register