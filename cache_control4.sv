import lc3b_types::*;
import cache_types::*;

module cache_control
(
	// CPU to Cache
	input clk,
	input logic mem_read,
	input logic mem_write,
	output logic mem_resp,
	
	// Cache Control to Datapath
	input logic hit,
	input logic dirty,
	input [2:0] lru_output,
	input [3:0] hit_direction,
	input [3:0] valid_array,
	
	output logic load_lru,
	output logic address_sel,
	output logic data_read_sel,
	output logic addr_mux_sel,
	output logic [2:0] data_mux_sel,
	output logic dirty_write,
	output logic load_dirty_valid0,
	output logic load_data0,
	output logic load_tag0, 
	output logic load_dirty_valid1,
	output logic load_data1,
	output logic load_tag1, 
	output logic load_dirty_valid2,
	output logic load_data2,
	output logic load_tag2, 
	output logic load_dirty_valid3,
	output logic load_data3,
	output logic load_tag3, 
	output logic [2:0] lru_in,
	
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
	data_mux_sel = 3'b000;
	dirty_write = 1'b0;
	load_dirty_valid0 = 1'b0;
	load_data0 = 1'b0;
	load_tag0 = 1'b0;
	load_dirty_valid1 = 1'b0;
	load_data1 = 1'b0;
	load_tag1 = 1'b0;
	load_dirty_valid2 = 1'b0;
	load_data2 = 1'b0;
	load_tag2 = 1'b0;
	load_dirty_valid3 = 1'b0;
	load_data3 = 1'b0;
	load_tag3 = 1'b0;
	load_lru = 1'b0;
	lru_in = 3'b000;
	
	case(state)
		hit_or_miss: begin
			//data_mux_sel = ~compare0 && compare1;
			//lru_in = compare0 && ~compare1;
			dirty_write = 1'b1;
			data_read_sel = 1'b0;

			case(hit_direction)
				//	hit_direction = {out3, out2, out1, out0};
				4'b0001: begin
					data_mux_sel = {lru_output[2], 2'b00};
				end
				4'b0010: begin
					data_mux_sel = {lru_output[2], 2'b10};
				end
				4'b0100: begin
					data_mux_sel = {1'b0, lru_output[1], 1'b1};
				end
				4'b1000: begin
					data_mux_sel = {1'b1, lru_output[1], 1'b1};
				end
				default: begin
					data_mux_sel = 3'b000;
				end
			endcase
			
			case(lru_output)
					3'b000: begin
						if (hit_direction == 4'b0001) lru_in = 3'b000;
						else if (hit_direction == 4'b0010) lru_in = 3'b010;
						else if (hit_direction == 4'b0100) lru_in = 3'b001;
						else lru_in = 3'b101;
					end
					3'b001: begin
						if (hit_direction == 4'b0001) lru_in = 3'b000;
						else if (hit_direction == 4'b0010) lru_in = 3'b010;
						else if (hit_direction == 4'b0100) lru_in = 3'b001;
						else lru_in = 3'b101;
					end
					3'b010: begin
						if (hit_direction == 4'b0001) lru_in = 3'b000;
						else if (hit_direction == 4'b0010) lru_in = 3'b010;
						else if (hit_direction == 4'b0100) lru_in = 3'b011;
						else lru_in = 3'b111;
					end
					3'b011: begin
						if (hit_direction == 4'b0001) lru_in = 3'b000;
						else if (hit_direction == 4'b0010) lru_in = 3'b010;
						else if (hit_direction == 4'b0100) lru_in = 3'b011;
						else lru_in = 3'b111;
					end
					3'b100: begin
						if (hit_direction == 4'b0001) lru_in = 3'b100;
						else if (hit_direction == 4'b0010) lru_in = 3'b110;
						else if (hit_direction == 4'b0100) lru_in = 3'b001;
						else lru_in = 3'b101;
					end
					3'b101: begin
						if (hit_direction == 4'b0001) lru_in = 3'b100;
						else if (hit_direction == 4'b0010) lru_in = 3'b110;
						else if (hit_direction == 4'b0100) lru_in = 3'b001;
						else lru_in = 3'b101;
					end
					3'b110: begin
						if (hit_direction == 4'b0001) lru_in = 3'b100;
						else if (hit_direction == 4'b0010) lru_in = 3'b110;
						else if (hit_direction == 4'b0100) lru_in = 3'b011;
						else lru_in = 3'b111;
					end
					3'b111: begin
						if (hit_direction == 4'b0001) lru_in = 3'b100;
						else if (hit_direction == 4'b0010) lru_in = 3'b110;
						else if (hit_direction == 4'b0100) lru_in = 3'b011;
						else lru_in = 3'b111;
					end
			endcase
						
			if (hit == 1) begin
				if (mem_read == 1) begin
					load_lru = 1'b1;
					mem_resp = 1'b1;
				end
				else if (mem_write == 1) begin
					load_lru = 1'b1;
					mem_resp = 1'b1;
					case(hit_direction)
						//	hit_direction = {out3, out2, out1, out0};
						4'b0001: begin
							load_dirty_valid0 = 1'b1;
							load_data0 = 1'b1;
						end
						4'b0010: begin
							load_dirty_valid1 = 1'b1;
							load_data1 = 1'b1;
						end
						4'b0100: begin
							load_dirty_valid2 = 1'b1;
							load_data2 = 1'b1;
						end
						4'b1000: begin
							load_dirty_valid3 = 1'b1;
							load_data3 = 1'b1;
						end
						default: begin
							load_dirty_valid0 = 1'b0;
							load_data0 = 1'b0;							
							load_dirty_valid1 = 1'b0;
							load_data1 = 1'b0;							
							load_dirty_valid2 = 1'b0;
							load_data2 = 1'b0;							
							load_dirty_valid3 = 1'b0;
							load_data3 = 1'b0;
						end
					endcase
				end
			end
		end
		
		eviction: begin
			pmem_write = 1'b1;
			addr_mux_sel = 1'b1;
			data_mux_sel = lru_output; // Make mux into one hot mux
		end
		
		retrieve_data: begin
			pmem_read = 1'b1;
			addr_mux_sel = 1'b0;
			dirty_write = 1'b0;
			data_read_sel = 1'b1;
			if (pmem_resp == 1) begin
				case(valid_array)
					4'b0000: begin
						load_dirty_valid0 = 1'b1;
						load_data0 = 1'b1;
						load_tag0 = 1'b1;
					end
					4'b0001: begin
						load_dirty_valid1 = 1'b1;
						load_data1 = 1'b1;
						load_tag1 = 1'b1;
					end
					4'b0011: begin
						load_dirty_valid2 = 1'b1;
						load_data2 = 1'b1;
						load_tag2 = 1'b1;
					end
					4'b0111: begin
						load_dirty_valid3 = 1'b1;
						load_data3 = 1'b1;
						load_tag3 = 1'b1;
					end
					4'b1111: begin
						case(lru_output)
							//L2L1L0
							3'b000: begin
								load_dirty_valid3 = 1'b1;
								load_data3 = 1'b1;
								load_tag3 = 1'b1;
							end
							3'b001: begin
								load_dirty_valid1 = 1'b1;
								load_data1 = 1'b1;
								load_tag1 = 1'b1;
							end
							3'b010: begin
								load_dirty_valid3 = 1'b1;
								load_data3 = 1'b1;
								load_tag3 = 1'b1;
							end
							3'b011: begin
								load_dirty_valid0 = 1'b1;
								load_data0 = 1'b1;
								load_tag0 = 1'b1;
							end
							3'b100: begin
								load_dirty_valid2 = 1'b1;
								load_data2 = 1'b1;
								load_tag2 = 1'b1;
							end
							3'b101: begin
								load_dirty_valid1 = 1'b1;
								load_data1 = 1'b1;
								load_tag1 = 1'b1;
							end
							3'b110: begin
								load_dirty_valid2 = 1'b1;
								load_data2 = 1'b1;
								load_tag2 = 1'b1;
							end 
							3'b111: begin
								load_dirty_valid0 = 1'b1;
								load_data0 = 1'b1;
								load_tag0 = 1'b1;
							end
						endcase
					end
					default: begin 
						load_dirty_valid0 = 1'b1;
						load_data0 = 1'b1;
						load_tag0 = 1'b1;						
						load_dirty_valid1 = 1'b1;
						load_data1 = 1'b1;
						load_tag1 = 1'b1;						
						load_dirty_valid2 = 1'b1;
						load_data2 = 1'b1;
						load_tag2 = 1'b1;						
						load_dirty_valid3 = 1'b1;
						load_data3 = 1'b1;
						load_tag3 = 1'b1;
					end
				endcase
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
			else if (dirty == 1'b1) begin
					next_state = eviction;
			end
			else begin
					next_state = retrieve_data;
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

endmodule : cache_control