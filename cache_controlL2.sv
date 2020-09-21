import lc3b_types::*;
import cache_types::*;

module cache_controlL2
(
	// CPU to Cache
	input clk,
	input logic mem_read,
	input logic mem_write,
	output logic mem_resp,
	
	// Cache Control to Datapath
	input logic hit,
	input logic dirty,
	input logic compare0,
	input logic compare1,
	input logic lru_output,
	
	output logic load_lru,
	output logic address_sel,
	output logic data_read_sel,
	output logic addr_mux_sel,
	output logic data_mux_sel,
	output logic data_write_sel,
	output logic dirty_write,
	output logic load_dirty_valid0,
	output logic load_data0,
	output logic load_tag0, 
	output logic load_dirty_valid1,
	output logic load_data1,
	output logic load_tag1, 
	output logic lru_in,
	output logic miss,
	output logic retrieve_data_out,
	output logic hit_or_miss_out,
	output logic eviction_out,
	
	// Cache to Main Memory
	input logic pmem_resp,
	output logic pmem_read,
	output logic pmem_write
);

enum int unsigned {
	/* List of Cache States */
	hit_or_miss,
	eviction,
	retrieve_data
} state, next_state;

always_comb 
begin : state_actions
	/* Default output assignemnts */
	pmem_write = 1'b0;
	pmem_read = 1'b0;
	mem_resp = 1'b0;
	address_sel = 1'b0;
	data_read_sel = 1'b0;
	addr_mux_sel = 1'b1;
	data_mux_sel = 1'b0;
	data_write_sel = 1'b0;
	dirty_write = 1'b0;
	load_dirty_valid0 = 1'b0;
	load_data0 = 1'b0;
	load_tag0 = 1'b0;
	load_dirty_valid1 = 1'b0;
	load_data1 = 1'b0;
	load_tag1 = 1'b0;
	load_lru = 1'b0;
	lru_in = 1'b0;
	miss = 1'b0;
	eviction_out = 1'b0;
	hit_or_miss_out = 1'b0;
	retrieve_data_out = 1'b0;
	
	case(state)
		hit_or_miss: begin
			data_mux_sel = ~compare0 && compare1;
			lru_in = compare0 && ~compare1;
			
			data_read_sel = 1'b0;
			hit_or_miss_out = 1'b1;
			
			if (hit == 1) begin
				if (mem_read == 1) begin
					load_lru = 1'b1;
					mem_resp = 1'b1; 
				end
				else if (mem_write == 1) begin
					load_lru = 1'b1;
					mem_resp = 1'b1;
					load_dirty_valid0 = compare0;
					load_dirty_valid1 = ~compare0;
					data_write_sel = 1'b1;
					
					load_data0 = compare0;
					load_data1 = ~compare0;
				end
				dirty_write = 1'b1;
			end
		end
		
		eviction: begin
			pmem_write = 1'b1;
			addr_mux_sel = 1'b1;
			eviction_out = 1'b1;
			data_mux_sel = lru_output;
		end
		
		retrieve_data: begin
			pmem_read = 1'b1;
			addr_mux_sel = 1'b0;
			dirty_write = 1'b0;
			data_read_sel = 1'b1;
			retrieve_data_out = 1'b1;
			miss = 1'b1;
			if (pmem_resp == 1) begin
				load_dirty_valid0 = ~lru_output;
				load_data0 = ~lru_output;
				load_tag0 = ~lru_output;
				
				load_dirty_valid1 = lru_output;
				load_data1 = lru_output;
				load_tag1 = lru_output;
			end
		end
	endcase
end

always_comb
begin : next_state_logic
	next_state = state;
	
	case(state)
		hit_or_miss: begin
			if (hit == 1'b1) begin
					next_state = hit_or_miss;
			end
			else if (hit == 1'b0 && dirty == 1'b1 && ((mem_read == 1'b1) || (mem_write == 1'b1))) begin
					next_state = eviction;
			end
			else if (hit == 1'b0 && (mem_read == 1'b1 || mem_write == 1'b1)) begin
					next_state = retrieve_data;
			end
			else begin
					next_state = state;
			end
		end
		
		eviction: begin
			if (pmem_resp == 1) begin
				next_state = retrieve_data;
			end else begin
				next_state = eviction;
			end
		end
		
		retrieve_data: begin
			if (pmem_resp == 1'b1)
				next_state = hit_or_miss;
			else
				next_state = retrieve_data;
		end
	endcase
end

always_ff @ (posedge clk)
begin : next_state_assignment
	state <= next_state;
end: next_state_assignment

endmodule : cache_controlL2