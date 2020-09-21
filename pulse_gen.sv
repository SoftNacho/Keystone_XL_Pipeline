module pulse_gen
(
	input clk,
	input en,
	output logic ready
);

reg r1, r2, r3;

always_comb 
begin
	ready = r2 & ~r3;
end

always_ff @ (posedge clk)
begin
	r1 <= en;
	r2 <= r1;
	r3 <= r2;
end

endmodule : pulse_gen