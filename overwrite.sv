import lc3b_types::*;
import cache_types::*;

module overwrite
(
	input cache_read_offset offset,
	input lc3b_mem_wmask mem_byte_enable,
	input cache_line data_in,
	input lc3b_word mem_wdata,
	output cache_line data_out
);

logic [7:0] mux0_0_out, mux0_1_out, mux1_0_out, mux1_1_out, mux2_0_out, mux2_1_out, mux3_0_out, mux3_1_out, mux4_0_out, mux4_1_out, 
				mux5_0_out, mux5_1_out, mux6_0_out, mux6_1_out, mux7_0_out, mux7_1_out;

logic mux0_0_sel, mux0_1_sel, mux1_0_sel, mux1_1_sel, mux2_0_sel, mux2_1_sel, mux3_0_sel, mux3_1_sel, mux4_0_sel, mux4_1_sel, 
				mux5_0_sel, mux5_1_sel, mux6_0_sel, mux6_1_sel, mux7_0_sel, mux7_1_sel;

assign data_out = {mux7_1_out, mux7_0_out, mux6_1_out, mux6_0_out, mux5_1_out, mux5_0_out, mux4_1_out, mux4_0_out, mux3_1_out, 
				mux3_0_out, mux2_1_out, mux2_0_out, mux1_1_out, mux1_0_out, mux0_1_out, mux0_0_out};

always_comb
begin
	mux0_0_sel = 0;
	mux0_1_sel = 0;
	mux1_0_sel = 0;
	mux1_1_sel = 0;
	mux2_0_sel = 0;
	mux2_1_sel = 0;
	mux3_0_sel = 0;
	mux3_1_sel = 0;
	mux4_0_sel = 0;
	mux4_1_sel = 0;
	mux5_0_sel = 0;
	mux5_1_sel = 0;
	mux6_0_sel = 0;
	mux6_1_sel = 0;
	mux7_0_sel = 0;
	mux7_1_sel = 0;
	
	if (offset == 3'b000) begin
		if (mem_byte_enable == 2'b11) begin
			mux0_0_sel = 1;
			mux0_1_sel = 1;
		end else if (mem_byte_enable == 2'b10) begin
			mux0_0_sel = 0;
			mux0_1_sel = 1;
		end else if (mem_byte_enable == 2'b01) begin
			mux0_0_sel = 1;
			mux0_1_sel = 0;
		end else begin
			mux0_0_sel = 0;
			mux0_1_sel = 0;
		end
	end else if (offset == 3'b001) begin
		if (mem_byte_enable == 2'b11) begin
			mux1_0_sel = 1;
			mux1_1_sel = 1;
		end else if (mem_byte_enable == 2'b10) begin
			mux1_0_sel = 0;
			mux1_1_sel = 1;
		end else if (mem_byte_enable == 2'b01) begin
			mux1_0_sel = 1;
			mux1_1_sel = 0;
		end else begin
			mux1_0_sel = 0;
			mux1_1_sel = 0;
		end
	end else if (offset == 3'b010) begin
		if (mem_byte_enable == 2'b11) begin
			mux2_0_sel = 1;
			mux2_1_sel = 1;
		end else if (mem_byte_enable == 2'b10) begin
			mux2_0_sel = 0;
			mux2_1_sel = 1;
		end else if (mem_byte_enable == 2'b01) begin
			mux2_0_sel = 1;
			mux2_1_sel = 0;
		end else begin
			mux2_0_sel = 0;
			mux2_1_sel = 0;
		end	
	end else if (offset == 3'b011) begin
		if (mem_byte_enable == 2'b11) begin
			mux3_0_sel = 1;
			mux3_1_sel = 1;
		end else if (mem_byte_enable == 2'b10) begin
			mux3_0_sel = 0;
			mux3_1_sel = 1;
		end else if (mem_byte_enable == 2'b01) begin
			mux3_0_sel = 1;
			mux3_1_sel = 0;
		end else begin
			mux3_0_sel = 0;
			mux3_1_sel = 0;
		end	
	end else if (offset == 3'b100) begin
		if (mem_byte_enable == 2'b11) begin
			mux4_0_sel = 1;
			mux4_1_sel = 1;
		end else if (mem_byte_enable == 2'b10) begin
			mux4_0_sel = 0;
			mux4_1_sel = 1;
		end else if (mem_byte_enable == 2'b01) begin
			mux4_0_sel = 1;
			mux4_1_sel = 0;
		end else begin
			mux4_0_sel = 0;
			mux4_1_sel = 0;
		end	
	end else if (offset == 3'b101) begin
		if (mem_byte_enable == 2'b11) begin
			mux5_0_sel = 1;
			mux5_1_sel = 1;
		end else if (mem_byte_enable == 2'b10) begin
			mux5_0_sel = 0;
			mux5_1_sel = 1;
		end else if (mem_byte_enable == 2'b01) begin
			mux5_0_sel = 1;
			mux5_1_sel = 0;
		end else begin
			mux5_0_sel = 0;
			mux5_1_sel = 0;
		end	
	end else if (offset == 3'b110) begin
		if (mem_byte_enable == 2'b11) begin
			mux6_0_sel = 1;
			mux6_1_sel = 1;
		end else if (mem_byte_enable == 2'b10) begin
			mux6_0_sel = 0;
			mux6_1_sel = 1;
		end else if (mem_byte_enable == 2'b01) begin
			mux6_0_sel = 1;
			mux6_1_sel = 0;
		end else begin
			mux6_0_sel = 0;
			mux6_1_sel = 0;
		end	
	end else if (offset == 3'b111) begin
		if (mem_byte_enable == 2'b11) begin
			mux7_0_sel = 1;
			mux7_1_sel = 1;
		end else if (mem_byte_enable == 2'b10) begin
			mux7_0_sel = 0;
			mux7_1_sel = 1;
		end else if (mem_byte_enable == 2'b01) begin
			mux7_0_sel = 1;
			mux7_1_sel = 0;
		end else begin
			mux7_0_sel = 0;
			mux7_1_sel = 0;
		end	
	end
end
				
mux2 #(.width(8)) mux0_0
(
	.sel(mux0_0_sel),
	.a(data_in[7:0]),
	.b(mem_wdata[7:0]),
	.f(mux0_0_out)
);

mux2 #(.width(8)) mux0_1
(
	.sel(mux0_1_sel),
	.a(data_in[15:8]),
	.b(mem_wdata[15:8]),
	.f(mux0_1_out)
);

mux2 #(.width(8)) mux1_0
(
	.sel(mux1_0_sel),
	.a(data_in[23:16]),
	.b(mem_wdata[7:0]),
	.f(mux1_0_out)
);

mux2 #(.width(8)) mux1_1
(
	.sel(mux1_1_sel),
	.a(data_in[31:24]),
	.b(mem_wdata[15:8]),
	.f(mux1_1_out)
);

mux2 #(.width(8)) mux2_0
(
	.sel(mux2_0_sel),
	.a(data_in[39:32]),
	.b(mem_wdata[7:0]),
	.f(mux2_0_out)
);

mux2 #(.width(8)) mux2_1
(
	.sel(mux2_1_sel),
	.a(data_in[47:40]),
	.b(mem_wdata[15:8]),
	.f(mux2_1_out)
);

mux2 #(.width(8)) mux3_0
(
	.sel(mux3_0_sel),
	.a(data_in[55:48]),
	.b(mem_wdata[7:0]),
	.f(mux3_0_out)
);

mux2 #(.width(8)) mux3_1
(
	.sel(mux3_1_sel),
	.a(data_in[63:56]),
	.b(mem_wdata[15:8]),
	.f(mux3_1_out)
);

mux2 #(.width(8)) mux4_0
(
	.sel(mux4_0_sel),
	.a(data_in[71:64]),
	.b(mem_wdata[7:0]),
	.f(mux4_0_out)
);

mux2 #(.width(8)) mux4_1
(
	.sel(mux4_1_sel),
	.a(data_in[79:72]),
	.b(mem_wdata[15:8]),
	.f(mux4_1_out)
);

mux2 #(.width(8)) mux5_0
(
	.sel(mux5_0_sel),
	.a(data_in[87:80]),
	.b(mem_wdata[7:0]),
	.f(mux5_0_out)
);

mux2 #(.width(8)) mux5_1
(
	.sel(mux5_1_sel),
	.a(data_in[95:88]),
	.b(mem_wdata[15:8]),
	.f(mux5_1_out)
);

mux2 #(.width(8)) mux6_0
(
	.sel(mux6_0_sel),
	.a(data_in[103:96]),
	.b(mem_wdata[7:0]),
	.f(mux6_0_out)
);

mux2 #(.width(8)) mux6_1
(
	.sel(mux6_1_sel),
	.a(data_in[111:104]),
	.b(mem_wdata[15:8]),
	.f(mux6_1_out)
);

mux2 #(.width(8)) mux7_0
(
	.sel(mux7_0_sel),
	.a(data_in[119:112]),
	.b(mem_wdata[7:0]),
	.f(mux7_0_out)
);

mux2 #(.width(8)) mux7_1
(
	.sel(mux7_1_sel),
	.a(data_in[127:120]),
	.b(mem_wdata[15:8]),
	.f(mux7_1_out)
);

endmodule : overwrite