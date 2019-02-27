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
		output reg [7:0] out_ctl,
		output reg [511:0] out_header,//收到数据包后只发出包头
		
		output reg out_valid_pkt_ppl,
		output reg [7:0] out_pkt_ctl_ppl,
		output reg [511:0] out_pkt_data_ppl//mmu返回给数据平面的接口
		
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
	reg [7:0] num_data_slice=0;//若有多个节拍的数据包，则此变量代表存储目的地址的增加偏移。
	
	reg [519:0] mm [0:32*512-1];
	reg [511:0] index;
	
	reg [7:0] state;
	//------------------------reg-------
	//------------------------assign----
	assign result_mux_prio = mux_prio(index);
	
	
	
	//------------------------assign----
	
	 localparam    IDLE = 0;
	 localparam    SAVE0 = 1;
	 localparam    SAVE1 = 2;
	 localparam    PICKUP0 = 3;
	 
	 
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
//pkt_ctl 0x00:invalid
//pkt_ctl 0x01:start
//pkt_ctl 0x02:payload
//pkt_ctl 0x03:end.
//pkt_ctl 0x04:64byte packet, only takes one cycle.
	
	always @(posedge clk)begin
		if(reset)begin
			index <= 512'hffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff;
			state <= IDLE;
			out_valid_pid <= 0;
			out_pid <= 0;
			out_ctl <= 0;
			out_header <= 0;
			rd_en_pkt <= 0;
			num_data_slice <= 0;
			out_valid_pkt_ppl <= 0;
			rd_en_pid <= 0;
			out_pkt_data_ppl <= 0;
			out_pkt_ctl_ppl<=0;
		end else begin
			case(state)
				IDLE: begin
					out_valid_pid <= 0;
					rd_en_pkt <= 0;
					out_pid <= 0;
					out_ctl<= 0;
					out_header <= 0;
					num_data_slice <= 0;
					out_valid_pkt_ppl <= 0;
					rd_en_pid <= 0;
					if(!empty_pkt)begin
						state <= SAVE0;
					end else if(!empty_pid)begin
						state <= PICKUP0;
					end else begin
						state <= IDLE;
					end
				end
				SAVE0:begin
					if(in_pkt_ctl == 8'h04)begin//只有一个节拍，则直接输出给协处理器，不做存储。
						out_valid_pid <= 1;
						out_pid <= 0;
						out_ctl<= in_pkt_ctl;
						out_header <= in_pkt_data;
						rd_en_pkt <= 1;//读取fifo值
						state <= IDLE;
					end else if(in_pkt_ctl == 8'h01)begin//有多个节拍，调到循环状态中去。需要存储。发送包头。
						mm[ 512 * result_mux_prio ] <= {in_pkt_data, in_pkt_ctl};
						rd_en_pkt <= 1;
						out_pid <= result_mux_prio;
						index[result_mux_prio] <= 0;//指示位置零。
						num_data_slice <= num_data_slice + 1;//存储偏移+1
						out_valid_pid <= 1;
						out_pid <= result_mux_prio;
						out_ctl <= in_pkt_ctl;
						out_header <= in_pkt_data;
						state <= SAVE1;
					end
				end
				SAVE1:begin//写入的第二个状态，直到写完为止。
					if(empty_pkt)begin//同一个数据包，fifo为空,数据中断，只要不读就行，不会有输出信号
						rd_en_pkt <= 0;
						out_valid_pid <= 0;
						out_pid <= 0;
						out_ctl <= 0;
						out_header <= 0;
						state <= SAVE1;
					end else begin
						if(in_pkt_ctl != 8'h03)begin//没到结尾，一直存储，读取FIFO，不输出
							mm[ 512 * result_mux_prio + num_data_slice] <= {in_pkt_data, in_pkt_ctl};
							rd_en_pkt <= 1;
							out_valid_pid <= 0;
							out_pid <= 0;
							out_ctl <= 0;
							out_header <= 0;
							num_data_slice <= num_data_slice + 1;
							state <= SAVE1;
						end else begin//到了结尾，存储，跳出状态，
							mm[ 512 * result_mux_prio + num_data_slice] <= {in_pkt_data, in_pkt_ctl};
							rd_en_pkt <= 1;
							out_valid_pid <= 0;
							out_pid <= 0;
							out_ctl <= 0;
							out_header <= 0;
							num_data_slice <= 0;
							if(empty_pid && !empty_pkt)begin
								state <= SAVE0;
							end else if(empty_pid && empty_pkt)begin
								state <= IDLE;
							end else if(!empty_pid)begin
								state <= PICKUP0;
							end
						end
					end
				end
				PICKUP0:begin//从写入跳过来，清零一些标志位，
					rd_en_pkt <= 0;
					out_valid_pid <= 0;
					out_pid <= 0;
					out_ctl <= 0;
					out_header <= 0;
					if(mm[in_pid_fifo][7:0] == 8'h04)begin//只有一个周期的包,直接发送出去。
						index[in_pid_fifo] <= 1;
						out_valid_pkt_ppl <= 1;
						{out_pkt_data_ppl, out_pkt_ctl_ppl} <= mm[in_pid_fifo + num_data_slice];
						num_data_slice <= num_data_slice + 1;
						state <= IDLE;
					end else if(mm[in_pid_fifo][7:0] != 8'h03)begin//还没有到包的结尾
						index[in_pid_fifo] <= 1;
						out_valid_pkt_ppl <= 1;
						{out_pkt_data_ppl, out_pkt_ctl_ppl} <= mm[in_pid_fifo + num_data_slice];
						num_data_slice <= num_data_slice + 1;
						state <= PICKUP0;
					end else if(mm[in_pid_fifo][7:0] == 8'h03)begin
						index[in_pid_fifo] <= 1;
						out_valid_pkt_ppl <= 1;
						{out_pkt_data_ppl, out_pkt_ctl_ppl} <= mm[in_pid_fifo + num_data_slice];
						num_data_slice <= num_data_slice + 1;
						rd_en_pid <= 1;
						state <= IDLE;
					end
				end
			endcase
		end
	end
	
	
	//------------------------always----	
	
endmodule
