
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/14/2019 11:46:56 AM
// Design Name: 
// Module Name: cam
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


module tcam(//4bits key 4bits musk 16 entries.
    input       data_in_vld,
    input [3:0] data_in,
    
    output reg  tcam_out_vld,
    output reg [3:0] tcam_out,
    
    input reset,
    input clk
    );
    reg [3:0] cam_mm [0:15];
    reg [3:0] cam_mask [0:15];
    reg [3:0] cam_cp [0:15];
	reg [3:0] cam_cp_mask [0:15];
    reg [15:0] index;
    //reg temp;
    reg cp_vld;
    reg cm_vld;
   // reg mux_vld;
	reg mask_vld;
    wire [3:0] result;
    assign result = prio(index);
    
    function [3:0] prio;
        input [15:0] index;
        reg temp;
        integer i;
        begin
            temp = 1;
            prio = 0;
            for(i = 0; i < 16; i = i + 1)begin
                if(temp && index[i])begin
                    temp = 0;
                    prio = i;
                end
            end
        end
    endfunction
    
   always @(posedge clk)begin //cp stage
    if(reset)begin
        cam_cp[0] <= 0;cam_cp[1] <= 0;cam_cp[2] <= 0;cam_cp[3] <= 0;
        cam_cp[4] <= 0;cam_cp[5] <= 0;cam_cp[6] <= 0;cam_cp[7] <= 0;
        cam_cp[8] <= 0;cam_cp[9] <= 0;cam_cp[10] <= 0;cam_cp[11] <= 0;
        cam_cp[12] <= 0;cam_cp[13] <= 0;cam_cp[14] <= 0;cam_cp[15] <= 0;cp_vld <= 0;
    end else begin
        if(data_in_vld)begin
            cp_vld <= 1;
            cam_cp[0] <= data_in;cam_cp[1] <= data_in;cam_cp[2] <= data_in;cam_cp[3] <= data_in;
            cam_cp[4] <= data_in;cam_cp[5] <= data_in;cam_cp[6] <= data_in;cam_cp[7] <= data_in;
            cam_cp[8] <= data_in;cam_cp[9] <= data_in;cam_cp[10] <= data_in;cam_cp[11] <= data_in;
            cam_cp[12] <= data_in;cam_cp[13] <= data_in;cam_cp[14] <= data_in;cam_cp[15] <= data_in;
        end else begin
            cp_vld <= 0;
        end
    end
   end
   
   always @(posedge clk)begin //mask stage
    if(reset)begin
        cam_cp_mask[0] <= 0;cam_cp_mask[1] <= 0;cam_cp_mask[2] <= 0;cam_cp_mask[3] <= 0;
        cam_cp_mask[4] <= 0;cam_cp_mask[5] <= 0;cam_cp_mask[6] <= 0;cam_cp_mask[7] <= 0;
        cam_cp_mask[8] <= 0;cam_cp_mask[9] <= 0;cam_cp_mask[10] <= 0;cam_cp_mask[11] <= 0;
        cam_cp_mask[12] <= 0;cam_cp_mask[13] <= 0;cam_cp_mask[14] <= 0;cam_cp_mask[15] <= 0;mask_vld <= 0;
    end else begin
        if(cp_vld)begin
            mask_vld <= 1;
            cam_cp_mask[0] <= cam_cp[0] & cam_mask[0];cam_cp_mask[1] <= cam_cp[1] & cam_mask[1];cam_cp_mask[2] <= cam_cp[2] & cam_mask[2];cam_cp_mask[3] <= cam_cp[3] & cam_mask[3];
            cam_cp_mask[4] <= cam_cp[4] & cam_mask[4];cam_cp_mask[5] <= cam_cp[5] & cam_mask[5];cam_cp_mask[6] <= cam_cp[6] & cam_mask[6];cam_cp_mask[7] <= cam_cp[7] & cam_mask[7];
            cam_cp_mask[8] <= cam_cp[8] & cam_mask[8];cam_cp_mask[9] <= cam_cp[9] & cam_mask[9];cam_cp_mask[10] <= cam_cp[10] & cam_mask[10];cam_cp_mask[11] <= cam_cp[11] & cam_mask[11];
            cam_cp_mask[12] <= cam_cp[12] & cam_mask[12];cam_cp_mask[13] <= cam_cp[13] & cam_mask[13];cam_cp_mask[14] <= cam_cp[14] & cam_mask[14];cam_cp_mask[15] <= cam_cp[15] & cam_mask[15];
        end else begin
            mask_vld <= 0;
        end
    end
   end   
   
   always@(posedge clk) begin//compaer stage
    if(reset)begin
        index <= 0;
        cm_vld <= 0;
        //mux_vld <= 0;
    end else begin
        if(mask_vld)begin
            cm_vld <= 1;
            if(cam_cp_mask[0] == cam_mm[0])begin index[0] <= 1; end else begin index[0] <= 0; end 
	    if(cam_cp_mask[1] == cam_mm[1])begin index[1] <= 1; end else begin index[1] <= 0; end 
	    if(cam_cp_mask[2] == cam_mm[2])begin index[2] <= 1; end else begin index[2] <= 0; end 
		if(cam_cp_mask[3] == cam_mm[3])begin index[3] <= 1; end else begin index[3] <= 0; end 
		if(cam_cp_mask[4] == cam_mm[4])begin index[4] <= 1; end else begin index[4] <= 0; end 
		if(cam_cp_mask[5] == cam_mm[5])begin index[5] <= 1; end else begin index[5] <= 0; end 
		if(cam_cp_mask[6] == cam_mm[6])begin index[6] <= 1; end else begin index[6] <= 0; end 
		if(cam_cp_mask[7] == cam_mm[7])begin index[7] <= 1; end else begin index[7] <= 0; end 
		if(cam_cp_mask[8] == cam_mm[8])begin index[8] <= 1; end else begin index[8] <= 0; end 
		if(cam_cp_mask[9] == cam_mm[9])begin index[9] <= 1; end else begin index[9] <= 0; end 
		if(cam_cp_mask[10] == cam_mm[10])begin index[10] <= 1; end else begin index[10] <= 0; end
		if(cam_cp_mask[11] == cam_mm[11])begin index[11] <= 1; end else begin index[11] <= 0; end  
		if(cam_cp_mask[12] == cam_mm[12])begin index[12] <= 1; end else begin index[12] <= 0; end 
		if(cam_cp_mask[13] == cam_mm[13])begin index[13] <= 1; end else begin index[13] <= 0; end 
		if(cam_cp_mask[14] == cam_mm[14])begin index[14] <= 1; end else begin index[14] <= 0; end 
		if(cam_cp_mask[15] == cam_mm[15])begin index[15] <= 1; end else begin index[15] <= 0; end
        end else begin
            cm_vld <= 0;
        end
    end
   end

   
   always@(posedge clk)begin
    if(reset)begin
        tcam_out_vld <= 0;
        tcam_out <= 0;
    end else begin
        if(cm_vld)begin
            tcam_out_vld <= 1;
            tcam_out <= result;
        end else begin
            tcam_out_vld <= 0;
            tcam_out <= 0;
        end
    end
   end
    
    always @(posedge clk)begin
        if(reset)begin
            cam_mm[0] <= 2&4'b1110;cam_mm[1] <= 6&4'b1100;cam_mm[2] <= 10&4'b1010;cam_mm[3] <= 13&4'b1010;
            cam_mm[4] <= 5&4'b1111;cam_mm[5] <= 3&4'b0110;cam_mm[6] <= 11&4'b0010;cam_mm[7] <= 8&4'b1001;
            cam_mm[8] <= 1&4'b1110;cam_mm[9] <= 0&4'b1111;cam_mm[10] <= 15&4'b1110;cam_mm[11] <= 9&4'b1011;
            cam_mm[12] <= 4&4'b1111;cam_mm[13] <= 7&4'b1111;cam_mm[14] <= 14&4'b1101;cam_mm[15] <= 12&4'b0111;
			
			cam_mask[0] <= 4'b1110;cam_mask[1] <= 4'b1100;cam_mask[2] <= 4'b1010;cam_mask[3] <= 4'b1010;
            cam_mask[4] <= 4'b1111;cam_mask[5] <= 4'b0110;cam_mask[6] <= 4'b0010;cam_mask[7] <= 4'b1001;
            cam_mask[8] <= 4'b1110;cam_mask[9] <= 4'b1111;cam_mask[10] <= 4'b1110;cam_mask[11] <= 4'b1011;
            cam_mask[12] <= 4'b1111;cam_mask[13] <= 4'b1111;cam_mask[14] <= 4'b1101;cam_mask[15] <= 4'b0111;
			

        end else begin

        end
    end   
    
    
endmodule
