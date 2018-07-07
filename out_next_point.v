`timescale 1ns / 1ps
`define NULL 0

// Coder:	joe
// Description:
//	1:4 出口开关
//  
//   
//
//  
//
module out_next_point#(
		parameter DATA_WIDTH = 480,
		parameter CTRL_WIDTH=32,
		parameter STAGE_NUMBER = 2,
		parameter NUM_QUEUES = 4
	)(
		input clk,
		input rst,
	
		input datavalid0,
		input [CTRL_WIDTH-1:0] in_ctl0,
		input [DATA_WIDTH-1:0] in_data0,
		
		output reg out_wr0,
		output reg [CTRL_WIDTH-1:0] out_ctl0,
		output reg [DATA_WIDTH-1:0] out_data0,
		
		output reg out_wr1,
		output reg [CTRL_WIDTH-1:0] out_ctl1,
		output reg [DATA_WIDTH-1:0] out_data1,
		
		output reg out_wr2,
		output reg [CTRL_WIDTH-1:0] out_ctl2,
		output reg [DATA_WIDTH-1:0] out_data2,
		
		output reg out_wr3,
		output reg [CTRL_WIDTH-1:0] out_ctl3,
		output reg [DATA_WIDTH-1:0] out_data3

	
	);
	
	always @(posedge clk or negedge rst)begin
		if(!rst)begin
			out_wr0 <= 0;
			out_wr1 <= 0;
			out_wr2 <= 0;
			out_wr3 <= 0;

			out_ctl0 <= 0;
			out_ctl1 <= 0;
			out_ctl2 <= 0;
			out_ctl3 <= 0;
			
			out_data0 <= 0;
			out_data1 <= 0;
			out_data2 <= 0;
			out_data3 <= 0;
		end else begin
			if(datavalid0)begin
				if(in_ctl0[1:0] == 0)begin
					out_wr0 <= 1;
					out_ctl0 <= in_ctl0;
					out_data0 <= in_data0;
				end 
				if(in_ctl0[1:0] == 1)begin
					out_wr1 <= 1;
					out_ctl1 <= in_ctl0;
					out_data1 <= in_data0;
				end 
				if(in_ctl0[1:0] == 2)begin
					out_wr2 <= 1;
					out_ctl2 <= in_ctl0;
					out_data2 <= in_data0;
				end 
				if(in_ctl0[1:0] == 3)begin
					out_wr3 <= 1;
					out_ctl3 <= in_ctl0;
					out_data3 <= in_data0;
				end 
			end else begin
				out_wr0 <= 0;
				out_wr1 <= 0;
				out_wr2 <= 0;
				out_wr3 <= 0;
			end
		
		end
	end
	

	
endmodule
