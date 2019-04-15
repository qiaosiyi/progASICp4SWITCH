`timescale 1ns / 1ps
module top(
    input clk,
    input reset,
    input in_valid,
    input [7:0] in_ctl,
    input [7:0] in_data,
    
    output out_valid,
    output [7:0] out_ctl,
    output [7:0] out_data,
    
    output out_valid1,
    output [7:0] out_ctl1,
    output [7:0] out_data1
    );
    
    wire in2mm_out_wr;
    wire [7:0] in2mm_out_ctl;
    wire [479:0] in2mm_out_data;
    
    wire mm2out_out_valid_pid;
    wire [479:0] mm2out_out_header;
    wire mm2out_out_valid_pid1;
    wire [7:0] mm2out_out_ctl;
    wire [479:0] mm2out_out_pkt_data_ppl;

 
    
    c8to512 c8to512_inst(
        .clk(clk),
		.rst(reset),
		.data_in(in_data),//8
		.datavalid(in_valid),
		.newpkt(in_valid),
		.out_wr(in2mm_out_wr),
		.out_ctl(in2mm_out_ctl),//8
		.out_data(in2mm_out_data)//480
    );
    
    mmu mmu_inst(
        .clk(clk),
		.reset(reset),
		.in_valid_pkt_fifo(in2mm_out_wr),
		.in_pkt_ctl_fifo(in2mm_out_ctl),//8
		.in_pkt_data_fifo({32'h0,in2mm_out_data}),//512
		
		.in_valid_pid_fifo(in2mm_out_wr),
		.in_pid_fifo(in2mm_out_ctl),//8
		.in_pid_valid_lenth_fifo(in2mm_out_ctl),//有效长度*512等于发送出去的长度。8
		
		.out_valid_pid(mm2out_out_valid_pid),
		.out_pid(mm2out_out_ctl),//8
		.out_ctl(mm2out_out_ctl),//8
		.out_header({32'h0,mm2out_out_header}),//收到数据包后只发出包头512
		
		.out_valid_pkt_ppl(mm2out_out_valid_pid1),
		.out_pkt_ctl_ppl(mm2out_out_ctl),//8
		.out_pkt_data_ppl({32'h0,mm2out_out_pkt_data_ppl})//mmu返回给数据平面的接口512
    );
    
    c512to8 c512to8_inst0(
        .clk(clk),
		.rst(reset),
		.in_ctl(mm2out_out_ctl),//8
		.in_data({32'h0,mm2out_out_header}),//480
		.datavalid(mm2out_out_valid_pid),
		.out_data(out_data),//8
		.out_wr(out_valid)
    );
    c512to8 c512to8_inst1(
        .clk(clk),
		.rst(reset),
		.in_ctl(mm2out_out_ctl),//8
		.in_data({32'h0,mm2out_out_pkt_data_ppl}),//480
		.datavalid(mm2out_out_valid_pid1),
		.out_data(out_data1),//8
		.out_wr(out_valid1)
    );
endmodule
