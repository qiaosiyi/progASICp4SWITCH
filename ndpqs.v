`timescale 1ns / 1ps
`define NULL 0

module ndpqs
	#(
		parameter DATA_WIDTH = 480,
		parameter CTRL_WIDTH=32,
		parameter STAGE_NUMBER = 2,
		parameter NUM_IN_QUEUES = 4,
		parameter NUM_OUT_QUEUES = 8
	) (
		input clk,
		input rst,
		
		input datavalid0,
		input [CTRL_WIDTH-1:0] in_ctl0,
		input [DATA_WIDTH-1:0] in_data0,
		
		input datavalid1,
		input [CTRL_WIDTH-1:0] in_ctl1,
		input [DATA_WIDTH-1:0] in_data1,
		
		input datavalid2,
		input [CTRL_WIDTH-1:0] in_ctl2,
		input [DATA_WIDTH-1:0] in_data2,
		
		input datavalid3,
		input [CTRL_WIDTH-1:0] in_ctl3,
		input [DATA_WIDTH-1:0] in_data3,
		
		input datavalid4,
		input [CTRL_WIDTH-1:0] in_ctl4,
		input [DATA_WIDTH-1:0] in_data4,
		
		input datavalid5,
		input [CTRL_WIDTH-1:0] in_ctl5,
		input [DATA_WIDTH-1:0] in_data5,
		
		input datavalid6,
		input [CTRL_WIDTH-1:0] in_ctl6,
		input [DATA_WIDTH-1:0] in_data6,
		
		input datavalid7,
		input [CTRL_WIDTH-1:0] in_ctl7,
		input [DATA_WIDTH-1:0] in_data7,
		
		output wire [CTRL_WIDTH/4-1:0] out_len0,
		output wire [CTRL_WIDTH/4-1:0] out_len1,
		output wire [CTRL_WIDTH/4-1:0] out_len2,
		output wire [CTRL_WIDTH/4-1:0] out_len3,
		output wire [CTRL_WIDTH/4-1:0] out_len4,
		output wire [CTRL_WIDTH/4-1:0] out_len5,
		output wire [CTRL_WIDTH/4-1:0] out_len6,
		output wire [CTRL_WIDTH/4-1:0] out_len7
		
		
	);
	wire [7:0] len [0:7];
	assign len[0] = in_ctl0[7:0];
	assign len[1] = in_ctl1[7:0];
	assign len[2] = in_ctl2[7:0];
	assign len[3] = in_ctl3[7:0];
	assign len[4] = in_ctl4[7:0];
	assign len[5] = in_ctl5[7:0];
	assign len[6] = in_ctl6[7:0];
	assign len[7] = in_ctl7[7:0];
	
	
	
	reg [11:0] depth [0:7];
	reg [7:0] trans_len [0:7];
	parameter C_SEND_SPEED = 62;//100G 200MHz : 500b 62.5byte
	parameter C_MAX_DEPTH = 12*1024;//12KByte
	
	assign out_len0 = trans_len[0];
	assign out_len1 = trans_len[1];
	assign out_len2 = trans_len[2];
	assign out_len3 = trans_len[3];
	assign out_len4 = trans_len[4];
	assign out_len5 = trans_len[5];
	assign out_len6 = trans_len[6];
	assign out_len7 = trans_len[7];
	
	always @(posedge clk)begin
		if(!rst)begin
			depth[0] <= 0;
			depth[1] <= 0;
			depth[2] <= 0;
			depth[3] <= 0;
			depth[4] <= 0;
			depth[5] <= 0;
			depth[6] <= 0;
			depth[7] <= 0;
			trans_len[0] <= 0;
			trans_len[1] <= 0;
			trans_len[2] <= 0;
			trans_len[3] <= 0;
			trans_len[4] <= 0;
			trans_len[5] <= 0;
			trans_len[6] <= 0;
			trans_len[7] <= 0;
		end else begin
			if(datavalid0)begin
				if(depth[0] + len[0] - C_SEND_SPEED > 0)begin
					depth[0] <= depth[0] + len[0] - C_SEND_SPEED;
				end else begin
					depth[0] <= 0;
				end
				if(depth[0] > C_MAX_DEPTH)begin
					trans_len[0] <= 0;
				end
			end else begin
				if(depth[0] - C_SEND_SPEED > 0)begin
					depth[0] <= depth[0] - C_SEND_SPEED;
				end else begin
					depth[0] <= 0;
				end
			end
			if(datavalid1)begin
				if(depth[1] + len[1] - C_SEND_SPEED > 0)begin
					depth[1] <= depth[1] + len[1] - C_SEND_SPEED;
				end else begin
					depth[1] <= 0;
				end
				if(depth[1] > C_MAX_DEPTH)begin
					trans_len[1] <= 0;
				end
			end else begin
				if(depth[1] - C_SEND_SPEED > 0)begin
					depth[1] <= depth[1] - C_SEND_SPEED;
				end else begin
					depth[1] <= 0;
				end
			end
			if(datavalid2)begin
				if(depth[2] + len[2] - C_SEND_SPEED > 0)begin
					depth[2] <= depth[2] + len[2] - C_SEND_SPEED;
				end else begin
					depth[2] <= 0;
				end
				if(depth[2] > C_MAX_DEPTH)begin
					trans_len[2] <= 0;
				end
			end else begin
				if(depth[2] - C_SEND_SPEED > 0)begin
					depth[2] <= depth[2] - C_SEND_SPEED;
				end else begin
					depth[2] <= 0;
				end
			end
			if(datavalid3)begin
				if(depth[3] + len[3] - C_SEND_SPEED > 0)begin
					depth[3] <= depth[3] + len[3] - C_SEND_SPEED;
				end else begin
					depth[3] <= 0;
				end
				if(depth[3] > C_MAX_DEPTH)begin
					trans_len[3] <= 0;
				end
			end else begin
				if(depth[3] - C_SEND_SPEED > 0)begin
					depth[3] <= depth[3] - C_SEND_SPEED;
				end else begin
					depth[3] <= 0;
				end
			end
			if(datavalid4)begin
				if(depth[4] + len[4] - C_SEND_SPEED > 0)begin
					depth[4] <= depth[4] + len[4] - C_SEND_SPEED;
				end else begin
					depth[4] <= 0;
				end
				if(depth[4] > C_MAX_DEPTH)begin
					trans_len[4] <= 0;
				end
			end else begin
				if(depth[4] - C_SEND_SPEED > 0)begin
					depth[4] <= depth[4] - C_SEND_SPEED;
				end else begin
					depth[4] <= 0;
				end
			end
			if(datavalid5)begin
				if(depth[5] + len[5] - C_SEND_SPEED > 0)begin
					depth[5] <= depth[5] + len[5] - C_SEND_SPEED;
				end else begin
					depth[5] <= 0;
				end
				if(depth[5] > C_MAX_DEPTH)begin
					trans_len[5] <= 0;
				end
			end else begin
				if(depth[5] - C_SEND_SPEED > 0)begin
					depth[5] <= depth[5] - C_SEND_SPEED;
				end else begin
					depth[5] <= 0;
				end
			end
			if(datavalid6)begin
				if(depth[6] + len[6] - C_SEND_SPEED > 0)begin
					depth[6] <= depth[6] + len[6] - C_SEND_SPEED;
				end else begin
					depth[6] <= 0;
				end
				if(depth[6] > C_MAX_DEPTH)begin
					trans_len[6] <= 0;
				end
			end else begin
				if(depth[6] - C_SEND_SPEED > 0)begin
					depth[6] <= depth[6] - C_SEND_SPEED;
				end else begin
					depth[6] <= 0;
				end
				if(depth[6] > C_MAX_DEPTH)begin
					trans_len[6] <= 0;
				end
			end
			if(datavalid7)begin
				if(depth[7] + len[7] - C_SEND_SPEED > 0)begin
					depth[7] <= depth[7] + len[7] - C_SEND_SPEED;
				end else begin
					depth[7] <= 0;
				end
				if(depth[7] > C_MAX_DEPTH)begin
					trans_len[7] <= 0;
				end
			end else begin
				if(depth[7] - C_SEND_SPEED > 0)begin
					depth[7] <= depth[7] - C_SEND_SPEED;
				end else begin
					depth[7] <= 0;
				end
			end

		end
	end

	
	endmodule
