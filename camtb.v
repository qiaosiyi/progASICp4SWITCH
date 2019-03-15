`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/14/2019 12:18:57 PM
// Design Name: 
// Module Name: cam_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cam_tb(

    );
    
    reg clk = 1;
    reg reset = 1;
    reg data_in_vld = 0;
    reg [3:0] data_in = 0;
    wire cam_out_vld;
    wire [3:0] cam_out;
	wire tcam_out_vld;
    wire [3:0] tcam_out;
    always begin
        #5 clk = ~clk;
    end
    initial begin
        #30 reset = 0;
        #10 data_in_vld = 1;data_in = 1;
        #10 data_in_vld = 0;data_in = 0;
        #10 data_in_vld = 1;data_in = 2;
        #10 data_in_vld = 0;data_in = 0;
        #10 data_in_vld = 1;data_in = 3;
        #10 data_in_vld = 0;data_in = 0;
        #10 data_in_vld = 1;data_in = 4;
        #10 data_in_vld = 0;data_in = 0;
    end
    cam#()cam_inst(
        .data_in_vld(data_in_vld),
        .data_in(data_in),
        .cam_out_vld(cam_out_vld),
        .cam_out(cam_out),
        .reset(reset),
        .clk(clk)
    );
    tcam#()tcam_inst(
        .data_in_vld(data_in_vld),
        .data_in(data_in),
        .tcam_out_vld(tcam_out_vld),
        .tcam_out(tcam_out),
        .reset(reset),
        .clk(clk)
    );
endmodule

