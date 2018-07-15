module c512to8
	#(
		parameter DATA_WIDTH = 480,
		parameter CTRL_WIDTH=32,
		parameter STAGE_NUMBER = 2,
		parameter NUM_QUEUES = 8
	) (
		input clk,
		input rst,
		input [CTRL_WIDTH-1:0] in_ctl,
		input [DATA_WIDTH-1:0] in_data,
		input datavalid,
		output reg [7:0] out_data,
		output reg out_wr

	);
	
	
	always @(posedge clk or negedge rst)
	begin
		if(!rst)begin
			out_data <= 0;
		    out_wr <= 0;
			end
		else begin
			if(datavalid) begin
				out_wr <= 1;
				out_data <= in_data[DATA_WIDTH-1-8:DATA_WIDTH-8-8];
			end else begin
				out_wr <= 0;
				out_data <= 0;
			end
			
		end	
	end
	
	
	
	
	
	
	
	
	
	
	
	
endmodule
	
	
	
	