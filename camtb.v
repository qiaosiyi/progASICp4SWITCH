`timescale 1ns / 1ps



module cam_tb(

    );
    
    reg clk = 1;
    reg reset = 1;
    reg data_in_vld = 0;
    reg [3:0] data_in = 0;
    wire cam_out_vld;
    wire [3:0] cam_out;
    reg [15:0] inde;
    always begin
        #5 clk = ~clk;
    end
    initial begin
        #30 reset = 0;
        #10 data_in_vld = 1;data_in = 1;inde = 16'b0000_0000_0000_0010;
        #10 data_in_vld = 0;data_in = 0;
        #10 data_in_vld = 1;data_in = 2;inde = 16'b0000_0010_0000_0000;
        #10 data_in_vld = 0;data_in = 0;
        #10 data_in_vld = 1;data_in = 3;inde = 16'b0000_0000_0100_0000;
        #10 data_in_vld = 0;data_in = 0;
        #10 data_in_vld = 1;data_in = 2;inde = 16'b0000_1000_0000_0000;
        #10 data_in_vld = 0;data_in = 0;
    end
    cam#()cam_inst(
        .data_in_vld(data_in_vld),
        .data_in(data_in),
	.inde(inde),
        .cam_out_vld(cam_out_vld),
        .cam_out(cam_out),
        .reset(reset),
        .clk(clk)
    );
endmodule
