import lc3b_types::*;
import cache_types::*;

module arbiter_controller
(
	input clk,
	input l2_resp,
	input ipmem_read,
	input ipmem_write,
	input dpmem_read,
	input dpmem_write,
	output logic instr_service,
	output logic data_service,
	output logic instr_resp,
	output logic data_resp
);


enum int unsigned
{
	S_IDLE,
	S_SERVICE_DATA,
	S_SERVICE_INSTRUCTION
} cur_state, next_state;

always_ff @ (posedge clk)
begin
	cur_state <= next_state;
end

always_comb
begin : next_state_logic

	next_state = cur_state;
	
	case (cur_state)
		S_IDLE : begin
			if (dpmem_read || dpmem_write)
				next_state = S_SERVICE_DATA;
			else if (ipmem_read || ipmem_write)
				next_state = S_SERVICE_INSTRUCTION;
		end
		
		S_SERVICE_DATA : begin
			if (l2_resp)
				next_state = S_IDLE;
		end
		
		S_SERVICE_INSTRUCTION : begin
			if (l2_resp)
				next_state = S_IDLE;
		end
		
	endcase
	
end : next_state_logic

always_comb
begin : state_actions
	
	instr_resp = 1'b0;
	data_resp = 1'b0;
	instr_service = 1'b0;
	data_service = 1'b0;
	
	case (cur_state)
		S_IDLE : ;
	
		S_SERVICE_DATA : begin
			if (l2_resp)
				data_resp = 1'b1;
			data_service = 1'b1;
		end
		S_SERVICE_INSTRUCTION : begin
			if (l2_resp)
				instr_resp = 1'b1;
			instr_service = 1'b1;
		end
	
	endcase

end : state_actions

endmodule : arbiter_controller