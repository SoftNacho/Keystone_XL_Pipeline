module register #(parameter width = 16)
(
	input clk,
	input load,
	input [width-1 : 0] din,
	output logic [width-1 : 0] dout
);

logic [width-1 : 0] data;

initial
begin
	data = 1'b0;
end

always_ff @ (posedge clk)
begin
	if (load)
		data = din;
end

always_comb
begin
	dout = data;
end

endmodule : register