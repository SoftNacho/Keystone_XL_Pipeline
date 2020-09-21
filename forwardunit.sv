import lc3b_types::*;

module forwardunit
(
	input lc3b_reg idex_rt,
	input lc3b_reg idex_rs,
	input lc3b_reg idex_rd,
	input lc3b_reg exmem_rd,
	input lc3b_reg memwb_rd,
	input mem_regwrite,
	input wb_regwrite,
	input check_rs,
	input check_rt,
	input check_rd,
	output logic [1:0] forwardA,
	output logic [1:0] forwardB,
	output logic [1:0] forwardC
);

logic exmem_hazard, exmemb_hazard, exmemc_hazard;
logic int_hazard, intb_hazard, intc_hazard;

always_comb
begin
	exmem_hazard = 1'b0;
	int_hazard = 1'b0;
	if (((exmem_rd == idex_rs) && check_rs) && mem_regwrite)
		exmem_hazard = 1'b1;
	if (((memwb_rd == idex_rs) && check_rs) && wb_regwrite)
		int_hazard = 1'b1;
	forwardA[0] = exmem_hazard;
	forwardA[1] = ~exmem_hazard & int_hazard;
end

always_comb
begin
	exmemb_hazard = 1'b0;
	intb_hazard = 1'b0;
	if (((exmem_rd == idex_rt) && check_rt) && mem_regwrite)
		exmemb_hazard = 1'b1;
	if (((memwb_rd == idex_rt) && check_rt) && wb_regwrite)
		intb_hazard = 1'b1;
	forwardB[0] = exmemb_hazard;
	forwardB[1] = ~exmemb_hazard & intb_hazard;
end

always_comb
begin
	exmemc_hazard = 1'b0;
	intc_hazard = 1'b0;
	if (((exmem_rd == idex_rd) && check_rd) && mem_regwrite)
		exmemc_hazard = 1'b1;
	if (((memwb_rd == idex_rd) && check_rd) && wb_regwrite)
		intc_hazard = 1'b1;
	forwardC[0] = exmemc_hazard;
	forwardC[1] = ~exmemc_hazard & intc_hazard;
end

endmodule : forwardunit