module cam(
    input       data_in_vld,
    input [3:0] data_in,
    input [15:0] inde,
    
    output reg  cam_out_vld,
    output reg [3:0] cam_out,
    
    input reset,
    input clk
    );
    reg [3:0] cam_mm [0:15];
    reg [3:0] cam_cp [0:15];
    reg [15:0] index;
    reg temp;
    reg cp_vld;
    reg cm_vld;
    reg mux_vld;
    wire [3:0] result;
    assign result = prio(index);
    
    function [3:0] prio;
        input [15:0] inde;
        reg temp;
        integer i;
        begin
            temp = 1;
            prio = 0;
            for(i = 0; i < 16; i = i + 1)begin
                if(temp && inde[i])begin
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
   
   always@(posedge clk) begin
    if(reset)begin
        index <= 0;
        cm_vld <= 0;
        //mux_vld <= 0;
    end else begin
        if(cp_vld)begin
            cm_vld <= 1;
            if(cam_cp[0] == cam_mm[0])begin index[0] <= 1; end else begin index[0] <= 0; end 
	    if(cam_cp[1] == cam_mm[1])begin index[1] <= 1; end else begin index[1] <= 0; end 
	    if(cam_cp[2] == cam_mm[2])begin index[2] <= 1; end else begin index[2] <= 0; end 
		if(cam_cp[3] == cam_mm[3])begin index[3] <= 1; end else begin index[3] <= 0; end 
		if(cam_cp[4] == cam_mm[4])begin index[4] <= 1; end else begin index[4] <= 0; end 
		if(cam_cp[5] == cam_mm[5])begin index[5] <= 1; end else begin index[5] <= 0; end 
		if(cam_cp[6] == cam_mm[6])begin index[6] <= 1; end else begin index[6] <= 0; end 
		if(cam_cp[7] == cam_mm[7])begin index[7] <= 1; end else begin index[7] <= 0; end 
		if(cam_cp[8] == cam_mm[8])begin index[8] <= 1; end else begin index[8] <= 0; end 
		if(cam_cp[9] == cam_mm[9])begin index[9] <= 1; end else begin index[9] <= 0; end 
		if(cam_cp[10] == cam_mm[10])begin index[10] <= 1; end else begin index[10] <= 0; end
		if(cam_cp[11] == cam_mm[11])begin index[11] <= 1; end else begin index[11] <= 0; end  
		if(cam_cp[12] == cam_mm[12])begin index[12] <= 1; end else begin index[12] <= 0; end 
		if(cam_cp[13] == cam_mm[13])begin index[13] <= 1; end else begin index[13] <= 0; end 
		if(cam_cp[14] == cam_mm[14])begin index[14] <= 1; end else begin index[14] <= 0; end 
		if(cam_cp[15] == cam_mm[15])begin index[15] <= 1; end else begin index[15] <= 0; end
        end else begin
            cm_vld <= 0;
        end
    end
   end

   
   always@(posedge clk)begin
    if(reset)begin
        cam_out_vld <= 0;
        cam_out <= 0;
    end else begin
        if(cm_vld)begin
            cam_out_vld <= 1;
            cam_out <= result;
        end else begin
            cam_out_vld <= 0;
            cam_out <= 0;
        end
    end
   end
    
    always @(posedge clk)begin
        if(reset)begin
            cam_mm[0] <= 2;cam_mm[1] <= 6;cam_mm[2] <= 10;cam_mm[3] <= 13;
            cam_mm[4] <= 5;cam_mm[5] <= 3;cam_mm[6] <= 11;cam_mm[7] <= 8;
            cam_mm[8] <= 1;cam_mm[9] <= 0;cam_mm[10] <= 15;cam_mm[11] <= 9;
            cam_mm[12] <= 4;cam_mm[13] <= 7;cam_mm[14] <= 14;cam_mm[15] <= 12;
            cam_out_vld <= 0;
            cam_out <= 0;
            temp <= 0;
        end else begin

        end
    end   
    
    
endmodule
