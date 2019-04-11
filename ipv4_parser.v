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
		input                         pkt_data_vld_in,
		input [DATA_WIDTH-1:0]        pkt_data_in,
		
		output                     tuple_vld,
		
		output                     dmac_vld,
		output  [48-1:0]           dmac_data,
		
		output                     smac_vld,
		output  [48-1:0]           smac_data,
		
		output                     sip_vld,
		output  [32-1:0]           sip_data,
		
		output                     dip_vld,
		output  [32-1:0]           dip_data,
		
		output                     sport_vld,
		output  [16-1:0]           sport_data,
		
		output                     dport_vld,
		output  [16-1:0]           dport_data,
		
		output                     pkt_data_vld_out,
		output  [DATA_WIDTH-1:0]   pkt_data_out,
		
		input clk,
		input reset
	);
	
	reg pkt_data_vld_in_1;
	reg pkt_data_vld_in_2;
	reg pkt_data_vld_in_3;
	
	reg tuple_vld_1;
	reg tuple_vld_2;
	reg tuple_vld_3;
	
	reg          dmac_vld_0;
	reg [48-1:0] dmac_data_0;
	reg          smac_vld_0;
	reg [48-1:0] smac_data_0;
	
	reg          dmac_vld_1;
	reg [48-1:0] dmac_data_1;
	reg          smac_vld_1;
	reg [48-1:0] smac_data_1;
	
	reg          dmac_vld_2;
	reg [48-1:0] dmac_data_2;
	reg          smac_vld_2;
	reg [48-1:0] smac_data_2;
	
	reg          sip_vld_0;
	reg [32-1:0] sip_data_0;
	reg	         dip_vld_0;
	reg [32-1:0] dip_data_0;
	
	reg          sip_vld_1;
	reg [32-1:0] sip_data_1;
	reg	         dip_vld_1;
	reg [32-1:0] dip_data_1;
	
	reg          sp_vld_0 ;
	reg [16-1:0]  sp_data_0;
	reg	         dp_vld_0 ;
	reg [16-1:0]  dp_data_0;         
	
	reg [DATA_WIDTH-1:0] pkt_data_in_1;
	reg [DATA_WIDTH-1:0] pkt_data_in_2;
	reg [DATA_WIDTH-1:0] pkt_data_in_3;
	
	//wire [0:15] ipindex;
	//assign ipindex = pkt_data_in[383:368];
	wire [0:7] tcpindex;
	assign tcpindex = pkt_data_in_1[295:288];
	assign dmac_vld = 	dmac_vld_2;
	assign dmac_data = 	dmac_data_2;
	assign smac_vld = 	smac_vld_2;
	assign smac_data = 	smac_data_2;
	assign sip_vld = 	sip_vld_1;
	assign sip_data = 	sip_data_1;
	assign dip_vld = 	dip_vld_1;
	assign dip_data = 	dip_data_1;
	assign sport_vld = 	sp_vld_0;
	assign sport_data = sp_data_0;
	assign dport_vld = 	dp_vld_0;
	assign dport_data = 	dp_data_0;
	assign pkt_data_vld_out = 	pkt_data_vld_in_3;
	assign pkt_data_out     = 	pkt_data_in_3;
	assign tuple_vld = tuple_vld_3;
	
	wire v1;
	assign v1 = pkt_data_vld_in && pkt_data_in[383:368] == 16'h0800;
	wire v2;
	assign v2 = tuple_vld_1 && pkt_data_in_1[295:288] == 8'h06;
	wire v3;
	assign v3 = tuple_vld_2;
	
	always@(posedge clk)begin
		if(!reset)begin
			dmac_vld_0 <= 0;
			dmac_data_0 <= 0;
			smac_vld_0 <= 0;
			smac_data_0 <= 0;
			
			pkt_data_vld_in_1 <= 0;
			pkt_data_in_1 <= 0;
			tuple_vld_1 <= 0;
			
		end else begin
			if(v1)begin
				dmac_vld_0 <= 1;
				dmac_data_0 <= pkt_data_in[479:432];
				smac_vld_0 <= 1;
				smac_data_0 <= pkt_data_in[431:384];
				pkt_data_vld_in_1 <= 1;
				pkt_data_in_1 <= pkt_data_in;
				tuple_vld_1 <= 1;
			end else begin
				dmac_vld_0 <= 0;
				dmac_data_0 <= 0;
				pkt_data_vld_in_1 <= 0;
				tuple_vld_1 <= 0;
				smac_vld_0 <= 0;
				smac_data_0 <= 0;
			end
		end
	end 
	
	always@(posedge clk)begin
		if(!reset)begin
		
			pkt_data_vld_in_2 <= 0;
			pkt_data_in_2 <= 0;
			tuple_vld_2 <= 0;
			
			dmac_vld_1 <= 0;
			dmac_data_1 <= 0;
			smac_vld_1 <= 0;
			smac_data_1 <= 0;
			
			sip_vld_0 <= 0;
			sip_data_0 <= 0;
			dip_vld_0 <= 0;
			dip_data_0 <= 0;
		end else begin
			if(v2)begin
				sip_vld_0 <= 1;
				sip_data_0 <= pkt_data_in_1[271:240];
				dip_vld_0 <= 1;
				dip_data_0 <= pkt_data_in_1[239:208];
				
				pkt_data_vld_in_2 <= 1;
				pkt_data_in_2 <= pkt_data_in_1;
				tuple_vld_2 <= 1;
				
				dmac_vld_1 <=  dmac_vld_0;
				dmac_data_1 <= dmac_data_0;
				smac_vld_1 <=  smac_vld_0;
				smac_data_1 <= smac_data_0;
			end else begin
				sip_vld_0 <= 0;
				sip_data_0 <= 0;
				dip_vld_0 <= 0;
				dip_data_0 <= 0;
				pkt_data_vld_in_2 <= 0;
				tuple_vld_2 <= 0;
				dmac_vld_1 <=  0;
				dmac_data_1 <= 0;
				smac_vld_1 <=  0;
				smac_data_1 <= 0;
			end
		end
	end 
	
	always@(posedge clk)begin
		if(!reset)begin
			pkt_data_vld_in_3 <= 0;
			pkt_data_in_3 <= 0;
			tuple_vld_3 <= 0;
		
			dmac_vld_2 <= 0;
			dmac_data_2 <= 0;
			smac_vld_2 <= 0;
			smac_data_2 <= 0;
			
			sip_vld_1 <= 0;
			sip_data_1 <= 0;
			dip_vld_1 <= 0;
			dip_data_1 <= 0;
			
			sp_vld_0 <= 0;
			sp_data_0 <= 0;
			dp_vld_0 <= 0;
			dp_data_0 <= 0;
		end else begin
			if(v3)begin
				sp_vld_0 <= 1;
				sp_data_0 <= pkt_data_in_2[207:192];
				dp_vld_0 <= 1;
				dp_data_0 <= pkt_data_in_2[191:176];
				
				pkt_data_vld_in_3 <= 1;
				pkt_data_in_3 <= pkt_data_in_2;
				tuple_vld_3 <= 1;
				
				dmac_vld_2 <=  dmac_vld_1;
				dmac_data_2 <= dmac_data_1;
				smac_vld_2 <=  smac_vld_1;
				smac_data_2 <= smac_data_1;
				
				sip_vld_1 <=  sip_vld_0; 
				sip_data_1 <= sip_data_0;
				dip_vld_1 <=  dip_vld_0; 
				dip_data_1 <= dip_data_0;
			end else begin
				sp_vld_0 <= 0;
				sp_data_0 <= 0;
				dp_vld_0 <= 0;
				dp_data_0 <= 0;
				pkt_data_vld_in_3 <= 0;
				tuple_vld_3 <= 0;
				pkt_data_in_3 <= 0;
				dmac_vld_1 <=  0;
				dmac_data_1 <= 0;
				smac_vld_1 <=  0;
				smac_data_1 <= 0;
				sip_vld_1 <= 0;
		    	sip_data_1 <= 0;
				dip_vld_1 <= 0;
				dip_data_1 <= 0;
				dmac_vld_2 <= 0;
				dmac_data_2 <= 0;
				smac_vld_2 <= 0;
				smac_data_2 <= 0;
			end
		end
	end
endmodule


