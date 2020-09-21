import lc3b_types::*;

module hdu
(
	input idex_mem_read,
	input lc3b_reg idex_rd,
	input lc3b_reg ifid_rs,
	input lc3b_reg ifid_rt,
	input check_rs,
	input check_rt,
	output logic hazard_stall
);

always_comb
begin
	hazard_stall = 1'b0;
	if (idex_mem_read && (((idex_rd == ifid_rs) && check_rs) || ((idex_rd == ifid_rt) && check_rt)))
		hazard_stall = 1'b1;
end

endmodule : hdu