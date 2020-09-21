import lc3b_types::*;

module cccomp
(
	input lc3b_nzp CC_nzp, 
	input lc3b_reg IR_nzp,
	output logic br_enable
);

always_comb
begin
	if ((CC_nzp[2] && IR_nzp[2]) || (CC_nzp[1] && IR_nzp[1]) || (CC_nzp[0] && IR_nzp[0]))
		br_enable = 1;
	else
		br_enable = 0;
end

endmodule : cccomp