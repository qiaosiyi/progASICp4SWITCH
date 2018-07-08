`timescale 1ns / 1ps
`define NULL 0

// Coder:	joe
// Description:
//	流图中的一个节点，包含paser 交叉开关 流表 action set 流表是并行方式的
//  out_wr为有效标识，高有效。
//  
//
//  
//

module flowtablepoint
	#(
		parameter DATA_WIDTH = 480,
		parameter CTRL_WIDTH=32,
		parameter STAGE_NUMBER = 2,
		parameter NUM_QUEUES = 4
	) (
		input clk,
		input rst,
		
		//////////////////////////////////////////////////0
		input in_wr_0_0,
		input [CTRL_WIDTH-1:0]			in_ctl_0_0,
		input [DATA_WIDTH-1:0]			in_data_0_0,
		
		input in_wr_0_1,
		input [CTRL_WIDTH-1:0]			in_ctl_0_1,
		input [DATA_WIDTH-1:0]			in_data_0_1,
		
		input in_wr_0_2,
		input [CTRL_WIDTH-1:0]			in_ctl_0_2,
		input [DATA_WIDTH-1:0]			in_data_0_2,
		
		input in_wr_0_3,
		input [CTRL_WIDTH-1:0]			in_ctl_0_3,
		input [DATA_WIDTH-1:0]			in_data_0_3,
		//////////////////////////////////////////////////1
		input in_wr_1_0,
		input [CTRL_WIDTH-1:0]			in_ctl_1_0,
		input [DATA_WIDTH-1:0]			in_data_1_0,
		
		input in_wr_1_1,
		input [CTRL_WIDTH-1:0]			in_ctl_1_1,
		input [DATA_WIDTH-1:0]			in_data_1_1,
		
		input in_wr_1_2,
		input [CTRL_WIDTH-1:0]			in_ctl_1_2,
		input [DATA_WIDTH-1:0]			in_data_1_2,
		
		input in_wr_1_3,
		input [CTRL_WIDTH-1:0]			in_ctl_1_3,
		input [DATA_WIDTH-1:0]			in_data_1_3,
		//////////////////////////////////////////////////2
		input in_wr_2_0,
		input [CTRL_WIDTH-1:0]			in_ctl_2_0,
		input [DATA_WIDTH-1:0]			in_data_2_0,
		
		input in_wr_2_1,
		input [CTRL_WIDTH-1:0]			in_ctl_2_1,
		input [DATA_WIDTH-1:0]			in_data_2_1,
		
		input in_wr_2_2,
		input [CTRL_WIDTH-1:0]			in_ctl_2_2,
		input [DATA_WIDTH-1:0]			in_data_2_2,
		
		input in_wr_2_3,
		input [CTRL_WIDTH-1:0]			in_ctl_2_3,
		input [DATA_WIDTH-1:0]			in_data_2_3,
		//////////////////////////////////////////////////3
		input in_wr_3_0,
		input [CTRL_WIDTH-1:0]			in_ctl_3_0,
		input [DATA_WIDTH-1:0]			in_data_3_0,
		
		input in_wr_3_1,
		input [CTRL_WIDTH-1:0]			in_ctl_3_1,
		input [DATA_WIDTH-1:0]			in_data_3_1,
		
		input in_wr_3_2,
		input [CTRL_WIDTH-1:0]			in_ctl_3_2,
		input [DATA_WIDTH-1:0]			in_data_3_2,
		
		input in_wr_3_3,
		input [CTRL_WIDTH-1:0]			in_ctl_3_3,
		input [DATA_WIDTH-1:0]			in_data_3_3,
		//////////////////////////////////////////////////
		//////////////////////////////////////////////////0
		output out_wr_0_0,
		output [CTRL_WIDTH-1:0]			out_ctl_0_0,
		output [DATA_WIDTH-1:0]			out_data_0_0,
		
		output out_wr_0_1,
		output [CTRL_WIDTH-1:0]			out_ctl_0_1,
		output [DATA_WIDTH-1:0]			out_data_0_1,
		
		output out_wr_0_2,
		output [CTRL_WIDTH-1:0]			out_ctl_0_2,
		output [DATA_WIDTH-1:0]			out_data_0_2,
		
		output out_wr_0_3,
		output [CTRL_WIDTH-1:0]			out_ctl_0_3,
		output [DATA_WIDTH-1:0]			out_data_0_3,
		//////////////////////////////////////////////////1
		output out_wr_1_0,
		output [CTRL_WIDTH-1:0]			out_ctl_1_0,
		output [DATA_WIDTH-1:0]			out_data_1_0,
		
		output out_wr_1_1,
		output [CTRL_WIDTH-1:0]			out_ctl_1_1,
		output [DATA_WIDTH-1:0]			out_data_1_1,
		
		output out_wr_1_2,
		output [CTRL_WIDTH-1:0]			out_ctl_1_2,
		output [DATA_WIDTH-1:0]			out_data_1_2,
		
		output out_wr_1_3,
		output [CTRL_WIDTH-1:0]			out_ctl_1_3,
		output [DATA_WIDTH-1:0]			out_data_1_3,
		//////////////////////////////////////////////////2
		output out_wr_2_0,
		output [CTRL_WIDTH-1:0]			out_ctl_2_0,
		output [DATA_WIDTH-1:0]			out_data_2_0,
		
		output out_wr_2_1,
		output [CTRL_WIDTH-1:0]			out_ctl_2_1,
		output [DATA_WIDTH-1:0]			out_data_2_1,
		
		output out_wr_2_2,
		output [CTRL_WIDTH-1:0]			out_ctl_2_2,
		output [DATA_WIDTH-1:0]			out_data_2_2,
		
		output out_wr_2_3,
		output [CTRL_WIDTH-1:0]			out_ctl_2_3,
		output [DATA_WIDTH-1:0]			out_data_2_3,
		//////////////////////////////////////////////////3
		output out_wr_3_0,
		output [CTRL_WIDTH-1:0]			out_ctl_3_0,
		output [DATA_WIDTH-1:0]			out_data_3_0,
		
		output out_wr_3_1,
		output [CTRL_WIDTH-1:0]			out_ctl_3_1,
		output [DATA_WIDTH-1:0]			out_data_3_1,
		
		output out_wr_3_2,
		output [CTRL_WIDTH-1:0]			out_ctl_3_2,
		output [DATA_WIDTH-1:0]			out_data_3_2,
		
		output out_wr_3_3,
		output [CTRL_WIDTH-1:0]			out_ctl_3_3,
		output [DATA_WIDTH-1:0]			out_data_3_3
		//////////////////////////////////////////////////
		
		
	);
	
	// ------------- Regs/ wires -----------
	wire [NUM_QUEUES-1:0]			input_arb_in_wr0;
	wire [CTRL_WIDTH-1:0]			input_arb_in_ctl0 [NUM_QUEUES-1:0];
	wire [DATA_WIDTH-1:0]			input_arb_in_data0 [NUM_QUEUES-1:0];
	wire [NUM_QUEUES-1:0]			input_arb_in_wr1;
	wire [CTRL_WIDTH-1:0]			input_arb_in_ctl1 [NUM_QUEUES-1:0];
	wire [DATA_WIDTH-1:0]			input_arb_in_data1 [NUM_QUEUES-1:0];
	wire [NUM_QUEUES-1:0]			input_arb_in_wr2;
	wire [CTRL_WIDTH-1:0]			input_arb_in_ctl2 [NUM_QUEUES-1:0];
	wire [DATA_WIDTH-1:0]			input_arb_in_data2 [NUM_QUEUES-1:0];
	wire [NUM_QUEUES-1:0]			input_arb_in_wr3;
	wire [CTRL_WIDTH-1:0]			input_arb_in_ctl3 [NUM_QUEUES-1:0];
	wire [DATA_WIDTH-1:0]			input_arb_in_data3 [NUM_QUEUES-1:0];
	                     
	wire [NUM_QUEUES-1:0]			input_arb_out_wr;	
	wire [CTRL_WIDTH-1:0]			input_arb_out_ctl	[NUM_QUEUES-1:0];
	wire [DATA_WIDTH-1:0]			input_arb_out_data	[NUM_QUEUES-1:0];
	
	wire [NUM_QUEUES-1:0]			select_out_wr;
	wire [CTRL_WIDTH-1:0]			select_out_ctl 	[NUM_QUEUES-1:0];
	wire [DATA_WIDTH-1:0]			select_out_data [NUM_QUEUES-1:0];
	
	wire [NUM_QUEUES-1:0]			crossbar_out_wr;
	wire [CTRL_WIDTH-1:0]			crossbar_out_ctl [NUM_QUEUES-1:0];
	wire [DATA_WIDTH-1:0]			crossbar_out_data [NUM_QUEUES-1:0];
	
	wire [NUM_QUEUES-1:0]			lookup_out_wr;
	wire [CTRL_WIDTH-1:0]			lookup_out_ctl [NUM_QUEUES-1:0];
	wire [DATA_WIDTH-1:0]			lookup_out_data [NUM_QUEUES-1:0];
	
	wire [NUM_QUEUES-1:0]			next_out_wr0;
	wire [CTRL_WIDTH-1:0]			next_out_ctl0 [NUM_QUEUES-1:0];
	wire [DATA_WIDTH-1:0]			next_out_data0 [NUM_QUEUES-1:0];
	wire [NUM_QUEUES-1:0]			next_out_wr1;
	wire [CTRL_WIDTH-1:0]			next_out_ctl1 [NUM_QUEUES-1:0];
	wire [DATA_WIDTH-1:0]			next_out_data1 [NUM_QUEUES-1:0];
	wire [NUM_QUEUES-1:0]			next_out_wr2;
	wire [CTRL_WIDTH-1:0]			next_out_ctl2 [NUM_QUEUES-1:0];
	wire [DATA_WIDTH-1:0]			next_out_data2 [NUM_QUEUES-1:0];
	wire [NUM_QUEUES-1:0]			next_out_wr3;
	wire [CTRL_WIDTH-1:0]			next_out_ctl3 [NUM_QUEUES-1:0];
	wire [DATA_WIDTH-1:0]			next_out_data3 [NUM_QUEUES-1:0];
	
	
	
	// ------------ Modules -------------
	
	generate
	genvar iinarb;
	for(iinarb=0; iinarb<NUM_QUEUES; iinarb=iinarb+1) begin: input_arb_q
		input_arb
			#()
		input_arbs
			(
			.clk(clk),
			.rst(rst),
			
			.datavalid0(input_arb_in_wr0[iinarb]),
			.in_ctl0(input_arb_in_ctl0[iinarb]),
			.in_data0(input_arb_in_data0[iinarb]),
		
			.datavalid1(input_arb_in_wr1[iinarb]), 
			.in_ctl1(input_arb_in_ctl1[iinarb]),
			.in_data1(input_arb_in_data1[iinarb]),
		
			.datavalid2(input_arb_in_wr2[iinarb]),
			.in_ctl2(input_arb_in_ctl2[iinarb]),
			.in_data2(input_arb_in_data2[iinarb]),
		
			.datavalid3(input_arb_in_wr3[iinarb]),
			.in_ctl3(input_arb_in_ctl3[iinarb]),
			.in_data3(input_arb_in_data3[iinarb]),
			
			.out_wr0		(input_arb_out_wr	[iinarb]),
			.out_ctl0	(input_arb_out_ctl	[iinarb]),
			.out_data0	(input_arb_out_data	[iinarb]));
	end 
	endgenerate

	generate
	genvar isel;
	for(isel=0; isel<NUM_QUEUES; isel=isel+1) begin: selector_q
		selector
			#()
		selectors
			(
			.clk(clk),
			.rst(rst),
			.datavalid(input_arb_out_wr[isel]),
			.in_ctl(input_arb_out_ctl[isel]),
			.in_data(input_arb_out_data[isel]),
			.out_wr(select_out_wr[isel]),
			.out_ctl(select_out_ctl[isel]),
			.out_data(select_out_data[isel]));
	end 
	endgenerate
	
	crossbar #() crossbar0(
		.clk(clk),
		.rst(rst),
		
		
		.datavalid0(select_out_wr[0]),
		.in_ctl0(select_out_ctl[0]),
		.in_data0(select_out_data[0]),
		
		.datavalid1(select_out_wr[1]), 
		.in_ctl1(select_out_ctl[1]),
		.in_data1(select_out_data[1]),
		
		.datavalid2(select_out_wr[2]),
		.in_ctl2(select_out_ctl[2]),
		.in_data2(select_out_data[2]),
		
		.datavalid3(select_out_wr[3]),
		.in_ctl3(select_out_ctl[3]),
		.in_data3(select_out_data[3]),
		
		
		.out_wr0(crossbar_out_wr[0]),
		.out_ctl0(crossbar_out_ctl[0]),
		.out_data0(crossbar_out_data[0]),
		
		.out_wr1(crossbar_out_wr[1]),
		.out_ctl1(crossbar_out_ctl[1]),
		.out_data1(crossbar_out_data[1]),
		
		.out_wr2(crossbar_out_wr[2]),
		.out_ctl2(crossbar_out_ctl[2]),
		.out_data2(crossbar_out_data[2]),
		
		.out_wr3(crossbar_out_wr[3]),
		.out_ctl3(crossbar_out_ctl[3]),
		.out_data3(crossbar_out_data[3])
	);
	
	generate
	genvar ilookup;
	for(ilookup=0; ilookup<NUM_QUEUES; ilookup=ilookup+1) begin: lookup_q
		lookup
			#()
		lookups
			(
			.clk(clk),
			.rst(rst),
			.datavalid(crossbar_out_wr[ilookup]),
			.in_ctl(crossbar_out_ctl[ilookup]),
			.in_data(crossbar_out_data[ilookup]),
			.out_wr(lookup_out_wr[ilookup]),
			.out_ctl(lookup_out_ctl[ilookup]),
			.out_data(lookup_out_data[ilookup]));
	end 
	endgenerate
	
	generate
	genvar inext;
	for(inext=0; inext<NUM_QUEUES; inext=inext+1) begin: out_next_point_q
		out_next_point
			#()
		out_next_points
			(
			.clk(clk),
			.rst(rst),
			.datavalid0(lookup_out_wr[inext]),
			.in_ctl0(lookup_out_ctl[inext]),
			.in_data0(lookup_out_data[inext]),
			
			.out_wr0(next_out_wr0[inext]),
			.out_ctl0(next_out_ctl0[inext]),
			.out_data0(next_out_data0[inext]),
			
			.out_wr1(next_out_wr1[inext]),
			.out_ctl1(next_out_ctl1[inext]),
			.out_data1(next_out_data1[inext]),
			
			.out_wr2(next_out_wr2[inext]),
			.out_ctl2(next_out_ctl2[inext]),
			.out_data2(next_out_data2[inext]),
			
			.out_wr3(next_out_wr3[inext]),
			.out_ctl3(next_out_ctl3[inext]),
			.out_data3(next_out_data3[inext]));
	end 
	endgenerate
	
	// ------------- Logic ------------

	
	assign out_wr_0_0				 = next_out_wr0[0];
	assign out_wr_0_1				 = next_out_wr0[1];
	assign out_wr_0_2				 = next_out_wr0[2];
	assign out_wr_0_3				 = next_out_wr0[3];
	
	assign out_ctl_0_0				 = next_out_ctl0[0];
	assign out_ctl_0_1				 = next_out_ctl0[1];
	assign out_ctl_0_2				 = next_out_ctl0[2];
	assign out_ctl_0_3				 = next_out_ctl0[3];
	
	assign out_data_0_0				 = next_out_data0[0];
	assign out_data_0_1				 = next_out_data0[1];
	assign out_data_0_2				 = next_out_data0[2];
	assign out_data_0_3				 = next_out_data0[3];
	
	assign out_wr_1_0				 = next_out_wr1[0];
	assign out_wr_1_1				 = next_out_wr1[1];
	assign out_wr_1_2				 = next_out_wr1[2];
	assign out_wr_1_3				 = next_out_wr1[3];
	
	assign out_ctl_1_0				 = next_out_ctl1[0];
	assign out_ctl_1_1				 = next_out_ctl1[1];
	assign out_ctl_1_2				 = next_out_ctl1[2];
	assign out_ctl_1_3				 = next_out_ctl1[3];
	
	assign out_data_1_0				 = next_out_data1[0];
	assign out_data_1_1				 = next_out_data1[1];
	assign out_data_1_2				 = next_out_data1[2];
	assign out_data_1_3				 = next_out_data1[3];
	
	assign out_wr_2_0				 = next_out_wr2[0];
	assign out_wr_2_1				 = next_out_wr2[1];
	assign out_wr_2_2				 = next_out_wr2[2];
	assign out_wr_2_3				 = next_out_wr2[3];
	
	assign out_ctl_2_0				 = next_out_ctl2[0];
	assign out_ctl_2_1				 = next_out_ctl2[1];
	assign out_ctl_2_2				 = next_out_ctl2[2];
	assign out_ctl_2_3				 = next_out_ctl2[3];
	
	assign out_data_2_0				 = next_out_data2[0];
	assign out_data_2_1				 = next_out_data2[1];
	assign out_data_2_2				 = next_out_data2[2];
	assign out_data_2_3				 = next_out_data2[3];
	
	assign out_wr_3_0				 = next_out_wr3[0];
	assign out_wr_3_1				 = next_out_wr3[1];
	assign out_wr_3_2				 = next_out_wr3[2];
	assign out_wr_3_3				 = next_out_wr3[3];
	
	assign out_ctl_3_0				 = next_out_ctl3[0];
	assign out_ctl_3_1				 = next_out_ctl3[1];
	assign out_ctl_3_2				 = next_out_ctl3[2];
	assign out_ctl_3_3				 = next_out_ctl3[3];
	
	assign out_data_3_0				 = next_out_data3[0];
	assign out_data_3_1				 = next_out_data3[1];
	assign out_data_3_2				 = next_out_data3[2];
	assign out_data_3_3				 = next_out_data3[3];
	///////////////////////////////////////////////////////////////////////////////////
	assign input_arb_in_wr0[0]		 = in_wr_0_0;
	assign input_arb_in_wr1[0]		 = in_wr_0_1;
	assign input_arb_in_wr2[0]		 = in_wr_0_2;
	assign input_arb_in_wr3[0]		 = in_wr_0_3;
	
	assign input_arb_in_ctl0[0]		 = in_ctl_0_0;
	assign input_arb_in_ctl1[0]		 = in_ctl_0_1;
	assign input_arb_in_ctl2[0]		 = in_ctl_0_2;
	assign input_arb_in_ctl3[0]		 = in_ctl_0_3;
	
	assign input_arb_in_data0[0]	 = in_data_0_0;
	assign input_arb_in_data1[0]	 = in_data_0_1;
	assign input_arb_in_data2[0]	 = in_data_0_2;
	assign input_arb_in_data3[0]	 = in_data_0_3;
	
	assign input_arb_in_wr0[1]		 = in_wr_1_0;
	assign input_arb_in_wr1[1]		 = in_wr_1_1;
	assign input_arb_in_wr2[1]		 = in_wr_1_2;
	assign input_arb_in_wr3[1]		 = in_wr_1_3;
	
	assign input_arb_in_ctl0[1]		 = in_ctl_1_0;
	assign input_arb_in_ctl1[1]		 = in_ctl_1_1;
	assign input_arb_in_ctl2[1]		 = in_ctl_1_2;
	assign input_arb_in_ctl3[1]		 = in_ctl_1_3;
	
	assign input_arb_in_data0[1]	 = in_data_1_0;
	assign input_arb_in_data1[1]	 = in_data_1_1;
	assign input_arb_in_data2[1]	 = in_data_1_2;
	assign input_arb_in_data3[1]	 = in_data_1_3;
	
	assign input_arb_in_wr0[2]		 = in_wr_2_0;
	assign input_arb_in_wr1[2]		 = in_wr_2_1;
	assign input_arb_in_wr2[2]		 = in_wr_2_2;
	assign input_arb_in_wr3[2]		 = in_wr_2_3;
	
	assign input_arb_in_ctl0[2]		 = in_ctl_2_0;
	assign input_arb_in_ctl1[2]		 = in_ctl_2_1;
	assign input_arb_in_ctl2[2]		 = in_ctl_2_2;
	assign input_arb_in_ctl3[2]		 = in_ctl_2_3;
	
	assign input_arb_in_data0[2]	 = in_data_2_0;
	assign input_arb_in_data1[2]	 = in_data_2_1;
	assign input_arb_in_data2[2]	 = in_data_2_2;
	assign input_arb_in_data3[2]	 = in_data_2_3;
	
	assign input_arb_in_wr0[3]		 = in_wr_3_0;
	assign input_arb_in_wr1[3]		 = in_wr_3_1;
	assign input_arb_in_wr2[3]		 = in_wr_3_2;
	assign input_arb_in_wr3[3]		 = in_wr_3_3;
	
	assign input_arb_in_ctl0[3]		 = in_ctl_3_0;
	assign input_arb_in_ctl1[3]		 = in_ctl_3_1;
	assign input_arb_in_ctl2[3]		 = in_ctl_3_2;
	assign input_arb_in_ctl3[3]		 = in_ctl_3_3;
	
	assign input_arb_in_data0[3]	 = in_data_3_0;
	assign input_arb_in_data1[3]	 = in_data_3_1;
	assign input_arb_in_data2[3]	 = in_data_3_2;
	assign input_arb_in_data3[3]	 = in_data_3_3;

endmodule
