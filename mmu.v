`timescale 1ns / 1ps
`define NULL 0

// Coder:	joe
// Description:
//	MMU,input: packet
//  store packet and return a PID handle
//  If input PID MMU return a packet which is located by index PID.
//	memory size is 512 packet * 2048 Byte.10M
//  
//

module mmu
	#(
		parameter DATA_WIDTH = 512,
		parameter CTRL_WIDTH = 8
	) (
		input clk,
		input reset,
		input in_valid_pkt_fifo,
		input [7:0] in_pkt_ctl_fifo,
		input [511:0] in_pkt_data_fifo,
		
		
		input in_valid_pid_fifo,
		input [8:0] in_pid_fifo,
		input [7:0] in_pid_valid_lenth_fifo,//有效长度*512等于发送出去的长度。
		
		output reg out_valid_pid,
		output reg [8:0] out_pid,
		output reg [511:0] header//收到数据包后只发出包头

	);
	//-----------------------wire-------
	wire empty_pkt;
	wire empty_pid;
	
	wire [7:0] in_pkt_ctl;
	wire [511:0] in_pkt_data;
	
	wire [8:0] in_pid;
	wire [7:0] in_pid_valid_lenth;
	
	wire [8:0] result_mux_prio;
	//-----------------------wire-------
	//------------------------reg-------
	reg rd_en_pkt;
	reg rd_en_pid;
	
	reg [519:0] mm [0:32*512-1];
	reg [511:0] index;
	
	reg [7:0] state;
	//------------------------reg-------
	//------------------------assign----
	assign result_mux_prio = mux_prio(index);
	
	
	
	//------------------------assign----
	
	 localparam    IDLE = 0;
	 localparam    SAVE0 = 1;
	 localparam    PICKUP0 = 2;
	 
	 
	//------------------------function--
	function [8:0] mux_prio;
		input [511:0] index;
		reg temp;
		integer i;
		begin
			temp = 1;
			mux_prio = 0;
			for(i = 0; i < 512; i = i + 1)begin
				if(temp && index[i])begin
					temp = 0;
					mux_prio = i;
				end
			end
		end
	endfunction
	
	
	//------------------------function--
	
	//------------------------always----
	fifofall
			#( .C_WIDTH(DATA_WIDTH+CTRL_WIDTH),
           .C_MAX_DEPTH_BITS(4))
		in_fifo_pkt
			(// Outputs
			.dout                           ({in_pkt_data, in_pkt_ctl}),
			.full                           (),
			.nearly_full                    (),
			.empty                          (empty_pkt),
			// Inputs
			.din                            ({in_pkt_data_fifo, in_pkt_ctl_fifo}),
			.wr_en                          (in_valid_pkt_fifo),
			.rd_en                          (rd_en_pkt),
			.rst                            (reset),
			.clk                            (clk));
	
fifofall
			#( .C_WIDTH(9+8),
           .C_MAX_DEPTH_BITS(4))
		in_fifo_pid
			(// Outputs
			.dout                           ({in_pid, in_pid_valid_lenth}),
			.full                           (),
			.nearly_full                    (),
			.empty                          (empty_pid),
			// Inputs
			.din                            ({in_pid_fifo, in_pid_valid_lenth_fifo}),
			.wr_en                          (in_valid_pid_fifo),
			.rd_en                          (rd_en_pid),
			.rst                            (reset),
			.clk                            (clk)); 
	
	
	always @(posedge clk)begin
		if(reset)begin
			index <= 512'h00ff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ff00;
			state <= IDLE;
		end else begin
			case(state)
				IDLE: begin
					if(!empty_pkt)begin
						state <= SAVE0;
					end else if(!empty_pid)begin
						state <= PICKUP0;
					end
				end
				SAVE0:begin
					
				end
				
				PICKUP0:begin
					
				end
			endcase
		end
	end
	
	
	//------------------------always----	
	
endmodule
