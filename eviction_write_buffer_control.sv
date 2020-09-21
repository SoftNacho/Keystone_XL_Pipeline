import lc3b_types::*;
import cache_types::*;

module eviction_write_buffer_control
(
	input clk,
	input full,
	input pmem_read,
	input write,
	input pmem_resp,
	output logic load,
	output logic pmem_write
);

enum int unsigned
{
	S_IDLE,
	S_WB
} state, next_state;

always_comb
begin : next_state_logic
	next_state = state;
	case (state)
		S_IDLE : begin
			if (!pmem_read && full)
				next_state = S_WB;
		end
		S_WB : begin
			if (pmem_resp || pmem_read)
				next_state = S_IDLE;
		end
	endcase
end : next_state_logic

always_comb
begin : state_actions
	load = 1'b0;
	pmem_write = 1'b0;
	case (state)
		S_IDLE : begin
			if (write && !full)
				load = 1'b1;
		end
		S_WB : begin
			pmem_write = 1'b1;
		end
	endcase

end : state_actions

always_ff @ (posedge clk)
begin : next_state_assignment
	state <= next_state;
end : next_state_assignment



endmodule : eviction_write_buffer_control