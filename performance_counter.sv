module performance_counter
(
	input clk,
	input count_event,
	input reset,
	output [9:0] data_out
);

logic [9:0] count, count_in;
logic ready;

assign data_out = count;

initial 
begin
	count = 1'b0;
end

always_comb
begin
	if (ready)
		count_in = count + 1'b1;
	else if (reset)
		count_in = 1'b0;
	else
		count_in = count;
end

always_ff @ (posedge clk) 
begin
	count <= count_in;
end

pulse_gen ready_gen
(
	.clk(clk), .en(count_event), .ready(ready)
);

endmodule : performance_counter