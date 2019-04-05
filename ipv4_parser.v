`timescale 1ns / 1ps
`define NULL 0
// Coder:	joe
// Description:
//	解析ipv4包头的二层三层四层
//  out_wr为有效标识，高有效。
//  
//	| dmac | smac | sip | dip | sport | dport |
//    0:47  48:95  208:239  240:271  272:287    288:303   
//  ipv4:96:111:0x0800    tcp:184:191:0x06
//  如果是tcp数据包 那么tuple_vld 为1，否则为0，子内容有效性由vld表达。
//  

module ipv4parser#(
		parameter DATA_WIDTH = 480,
		parameter CTRL_WIDTH=32,
		parameter STAGE_NUMBER = 2,
		parameter NUM_QUEUES = 8
	) (
		input pkt_data_vld_in,
		input [DATA_WIDTH-1:0] pkt_data_in,
		
		output reg tuple_vld;
		
		output reg dmac_vld,
		output reg [48-1:0] dmac_data,
		
		output reg smac_vld,
		output reg [48-1:0] smac_data,
		
		output reg sip_vld,
		output reg [32-1:0] sip_data,
		
		output reg dip_vld,
		output reg [32-1:0] dip_data,
		
		output reg sport_vld,
		output reg [32-1:0] sport_data,
		
		output reg dport_vld,
		output reg [32-1:0] dport_data,
		
		output reg pkt_data_vld_out,
		output reg [DATA_WIDTH-1:0] pkt_data_out,
		
		input clk,
		input reset
	);

	
	always@(posedge clk)begin
		if(reset)begin
			dmac_vld_0 <= 1;
			dmac_data_0 <= 0;
			pkt_data_vld_in_1 <= 0;
			pkt_data_in_1 <= 0;
			tuple_vld_1 <= 0;
		end else begin
			if(pkt_data_vld_in && pkt_data_in[96:111] == 0x0800)begin
				dmac_vld_0 <= 1;
				dmac_data_0 <= pkt_data_in[0:47];
				pkt_data_vld_in_1 <= 1;
				pkt_data_in_1 <= pkt_data_in;
				tuple_vld_1 <= 1;
			end else begin
				dmac_vld_0 <= 0;
				dmac_data_0 <= 0;
				pkt_data_vld_in_1 <= 0;
				tuple_vld_1 <= 0;
			end
		end
	end 
	
	
endmodule


