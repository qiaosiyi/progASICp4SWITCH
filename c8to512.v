`timescale 1ns / 1ps
`define NULL 0

// Coder:	joe
// Description:
//	将8bit数据流转换为480bit数据流，不足补0
//  out_wr为有效标识，高有效。
//   
//
//  
//

module c8to512
	#(
		parameter DATA_WIDTH = 480,
		parameter CTRL_WIDTH=32,
		parameter STAGE_NUMBER = 2,
		parameter NUM_QUEUES = 8
	) (
		input clk,
		input rst,
		input [7:0] data_in,
		input datavalid,
		input newpkt,
		output reg out_wr=0,
		output reg [CTRL_WIDTH-1:0] out_ctl=0,
		output reg [DATA_WIDTH-1:0] out_data=0
	);
	reg [7:0] cur_byte;
	reg flag;
	reg [7:0] src_port;
	reg [7:0] dst_port;
	reg [7:0] pcie_port;
	reg [7:0] next_output;
	
	always @(posedge clk or negedge rst)
	begin
		if(!rst)begin
			src_port <= 0;
		    dst_port <= 0;
		    pcie_port <= 0;
		    next_output <= 0;
			out_wr <= 0;
			cur_byte <= 0;
			flag <= 0;
			out_ctl <= 0;//控制位由这四个组成，目前默认参数均为零
			end
		else begin
			out_wr <= 0;
			out_ctl <= {src_port,dst_port,pcie_port,next_output};//控制位由这四个组成，目前默认参数均为零
			if(datavalid && cur_byte < 60) begin
				out_data <= {out_data[DATA_WIDTH-1-8:0],data_in};
				cur_byte <= cur_byte + 1;
			end
			
			if(!datavalid && cur_byte>0 && cur_byte < 60)begin
				if(!flag)begin
					flag <= 1;
					out_data <= {out_data[DATA_WIDTH-1-8:0],data_in};
					cur_byte <= cur_byte + 1;
				end else begin
					out_data <= {out_data[DATA_WIDTH-1-8:0],8'b0};
					cur_byte <= cur_byte + 1;
				end
				
				
			end
			
			if(newpkt)begin
				out_wr <= 1;
				cur_byte <= 0;
				flag <= 0;
			end
		end	
	end
	
	
	
	
	
	
	
	
	
	
	
	
endmodule
