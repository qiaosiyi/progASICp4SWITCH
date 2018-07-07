`timescale 1ns / 1ps
`define NULL 0

// Coder:	joe
// Description:
//	4:1rr 调度
//  
//   
//
//  
//
module input_arb
	#(
		parameter DATA_WIDTH = 480,
		parameter CTRL_WIDTH=32,
		parameter STAGE_NUMBER = 2,
		parameter NUM_QUEUES = 4
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
		
		
		output reg out_wr0,
		output reg [CTRL_WIDTH-1:0] out_ctl0,
		output reg [DATA_WIDTH-1:0] out_data0
		
	);
	
	wire [3:0] nearly_full_num;
	// ------------- Regs/ wires -----------
	wire [NUM_QUEUES-1:0]               nearly_full;
	wire [NUM_QUEUES-1:0]               empty;
	wire [DATA_WIDTH-1:0]               in_data      [NUM_QUEUES-1:0];
	wire [CTRL_WIDTH-1:0]               in_ctrl      [NUM_QUEUES-1:0];
	wire [NUM_QUEUES-1:0]               in_wr;
	wire [CTRL_WIDTH-1:0]               fifo_out_ctrl[NUM_QUEUES-1:0];
	wire [DATA_WIDTH-1:0]               fifo_out_data[NUM_QUEUES-1:0];	
	reg  [NUM_QUEUES-1:0]               rd_en;
	
	
	
	
	//assign nearly_full_num = {};
	
// ------------ Modules -------------

	generate
	genvar i;
	for(i=0; i<NUM_QUEUES; i=i+1) begin: in_queues
		fifo_full
			#( )
		in_fifo
			(// Outputs
			.dout                           ({fifo_out_ctrl[i], fifo_out_data[i]}),
			.full                           (),
			.nearly_full                    (nearly_full[i]),
			.empty                          (empty[i]),
			// Inputs
			.din                            ({in_ctrl[i], in_data[i]}),
			.wr_en                          (in_wr[i]),
			.rd_en                          (rd_en[i]),
			.reset                          (!rst),
			.clk                            (clk));
	end 
	endgenerate	
	
	
	assign in_data[0]         = in_data0;
	assign in_ctrl[0]         = in_ctl0;
	assign in_wr[0]           = datavalid0;
	
    assign in_data[1]         = in_data1;
	assign in_ctrl[1]         = in_ctl1;
	assign in_wr[1]           = datavalid1;
	
    assign in_data[2]         = in_data2;
	assign in_ctrl[2]         = in_ctl2;
	assign in_wr[2]           = datavalid2;
	
    assign in_data[3]         = in_data3;
	assign in_ctrl[3]         = in_ctl3;
	assign in_wr[3]           = datavalid3;
	
	
	
	always @(*)begin
		if(!rst)begin
			out_wr0 <= 0;
			out_ctl0 <= 0;
			out_data0 <= 0;
			rd_en <= 0;
		end else begin
			rd_en = 0;
			out_wr0 = 0;
			
			
			if(nearly_full[0])begin
				out_wr0 = 1;
				out_ctl0 = fifo_out_ctrl[0];
				out_data0 = fifo_out_data[0];
				rd_en[0] = 1;
			end else if(nearly_full[1])begin
				out_wr0 = 1;
				out_ctl0 = fifo_out_ctrl[1];
				out_data0 = fifo_out_data[1];
				rd_en[1] = 1;
			end else if(nearly_full[2])begin
				out_wr0 = 1;
				out_ctl0 = fifo_out_ctrl[2];
				out_data0 = fifo_out_data[2];
				rd_en[2] = 1;
			end else if(nearly_full[3])begin
				out_wr0 = 1;
				out_ctl0 = fifo_out_ctrl[3];
				out_data0 = fifo_out_data[3];
				rd_en[3] = 1;
			end else if(!empty[0])begin
				out_wr0 = 1;
				out_ctl0 = fifo_out_ctrl[0];
				out_data0 = fifo_out_data[0];
				rd_en[0] = 1;
			end else if(!empty[1])begin
				out_wr0 = 1;
				out_ctl0 = fifo_out_ctrl[1];
				out_data0 = fifo_out_data[1];
				rd_en[1] = 1;
			end else if(!empty[2])begin
				out_wr0 = 1;
				out_ctl0 = fifo_out_ctrl[2];
				out_data0 = fifo_out_data[2];
				rd_en[2] = 1;
			end else if(!empty[3])begin
				out_wr0 = 1;
				out_ctl0 = fifo_out_ctrl[3];
				out_data0 = fifo_out_data[3];
				rd_en[3] = 1;
			end else begin
				out_wr0 = 0;
				rd_en = 0;
			end
		end
		
	end
	
	
	
endmodule
