`timescale 1ns / 1ps
`define NULL 0

// Coder:	joe
// Description:
//	将lookup后出来，并查找action，记录到ctl字段里
//  
//   
//
//  
//

module lookup
	#(
		parameter DATA_WIDTH = 480,
		parameter CTRL_WIDTH=32,
		parameter STAGE_NUMBER = 2,
		parameter NUM_QUEUES = 8
	) (
		input clk,
		input rst,
		input datavalid,
		input [CTRL_WIDTH-1:0] in_ctl,
		input [DATA_WIDTH-1:0] in_data,
		output reg out_wr=0,
		output reg [CTRL_WIDTH-1:0] out_ctl=0,
		output reg [DATA_WIDTH-1:0] out_data=0
	);
	
	reg [1:0] EMtable [0:1];
	//wire [15:0] parseEM;
	wire parseEM;
	wire [1:0] resaltEM;
	
	reg [1:0] next_point_table [0:1];
	wire parseNEXT;
	wire [1:0] resaltNEXT;
	
	
	assign parseEM = in_data[239-32+1];//{in_data[239-2+1],in_data[239-17+1],in_data[239-19+1],in_data[239-25+1]};//2,17,19,25for test; 9 12 13 16 is best
	assign resaltEM = EMtable[parseEM];
	
	assign parseNEXT = in_data[239-32+1];
	assign resaltNEXT = next_point_table[parseNEXT];
	
	//assign resaltEM = 2;

	always @(posedge clk or negedge rst)begin
		if(!rst)begin
			EMtable[0] = 2;
			EMtable[1] = 3;
			next_point_table[0] = 3;
			next_point_table[1] = 2;
			out_wr <= 0;
		end else begin
			if(datavalid)begin
				out_ctl[1:0] <= resaltNEXT;
				out_ctl[15:8] <= in_ctl[15:8];
				out_ctl[17:16] <= resaltEM;
				out_ctl[31:24] <= in_ctl[31:24];
				out_data <= in_data;
				out_wr <= 1;
			end else begin
				out_wr <= 0;
			end
			
		end
		
	end
	
	
endmodule
