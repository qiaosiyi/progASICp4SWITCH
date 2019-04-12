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
		
	);
	
	reg [11:0] depth [0:7];

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
		end else begin
			if(depth[0] > 0) begin
				
			end
		end
	end

	
	endmodule
