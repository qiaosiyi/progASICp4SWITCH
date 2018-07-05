`timescale 1ns / 1ps
`define NULL 0

// Coder:	joe
// Description:
//	将bit位parse出来，并查找crossbar对应的出口，并将结果附在crl-byte的flowtable字中
//  
//   
//
//  
//

module selector
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
	
	reg [7:0] res [0:15];
	reg [7:0] src_port;
	reg [7:0] dst_port;
	reg [7:0] pcie_port;
	reg [7:0] next_output;
	wire [3:0] parse;
	wire [3:0] resalt;
	
	
	assign parse = {in_data[239-2+1],in_data[239-17+1],in_data[239-19+1],in_data[239-25+1]};//2,17,19,25for test; 9 12 13 16 is best
	assign resalt = res[parse];
	
	always @(posedge clk or negedge rst)begin
		if(!rst)begin
			res[0] = 8'h00;
			res[1] = 8'h00;
			res[2] = 8'h00;
			res[3] = 8'h00;
			
			res[4] = 8'h01;
			res[5] = 8'h01;
			res[6] = 8'h01;
			res[7] = 8'h01;
			
			res[8] = 8'h02;
			res[9] = 8'h02;
			res[10] = 8'h02;
			res[11] = 8'h02;
			
			res[12] = 8'h03;
			res[13] = 8'h03;
			res[14] = 8'h03;
			res[15] = 8'h03;
			
			src_port <= 0;
		    dst_port <= 0;
		    pcie_port <= 0;
		    next_output <= 0;
			
			out_wr <= 0;
			
		end else begin
			if(datavalid)begin
				out_ctl <= {src_port,dst_port,pcie_port,resalt};
				out_data <= in_data;
				out_wr <= 1;
			end else begin
				out_wr <= 0;
			end
			
		end
		
	end
	
	
endmodule
