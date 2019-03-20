`timescale 1ns / 1ps

module statefull(
    input            	pkt_vld_in,
    input [511:0]    	pkt_data_in,
    
    output reg       	pkt_vld_out,
    output reg [511:0] 	pkt_data_out,
	output reg [15:0] 	action_out,
	output reg [7:0] 	state_out,
    
    input reset,
    input clk
    );
	
	reg [23:0] ram_cam [0:15];
	reg [23:0] ram2 [0:128];
	reg [7:0]  state_tmp;
	reg [23:0] action_tmp;
	reg [3:0]  cam_q_tmp;
	reg mm_cam_vld;
	
	wire [511:0] fifo_pkt_dout;
	reg cam_q_vld;
	reg fifo_pkt_rd;
	wire cam_out_vld;
	wire [3:0] cam_q_data;
	
	
	fifofall #(//存放packet数据
	  .C_WIDTH(512),
      .C_MAX_DEPTH_BITS(8)
      ) fifo_state_tx
      (// Outputs
      .dout              (fifo_pkt_dout),
      .full              (),
      .nearly_full       (),
      .empty             (fifo_pkt_empty),
      // Inputs
      .din               (pkt_data_in),
      .wr_en             (pkt_vld_in),
      .rd_en             (fifo_pkt_rd),
      
      .rst               (reset),
      .clk               (clk));
	  
	  cam#() cam_inst(
		.data_in_vld(cam_q_vld),
		.data_in(fifo_pkt_dout[3:0]),
		.cam_out_vld(cam_out_vld),
		.cam_out(cam_q_data),
		.reset(reset),
		.clk(clk)
	  );
	  
	always @(posedge clk)begin //查cam表
		if(reset)begin
			cam_q_vld <= 0;
		end else begin
			if(pkt_vld_in)begin
				cam_q_vld <= 1;
			end else begin
				cam_q_vld <= 0;
			end
		end
	end
	
	always @(posedge clk)begin //查mm_cam表
		if(reset)begin

			ram_cam[0] <= {16'h00ff,8'h00};
			action_tmp <= 0;
			mm_cam_vld <= 0;
		end else begin
			if(cam_q_vld)begin
				state_tmp <= ram_cam[cam_q_data][7:0];
				action_tmp <= ram_cam[cam_q_data][23:8];
				cam_q_tmp <= cam_q_data;
				mm_cam_vld <= 1;
			end else begin
				mm_cam_vld <= 0;
			end
		end
	end	
	
	always @(posedge clk)begin //查 mm_cam表
		if(reset)begin
			cam_q_vld <= 0;
			ram2[0] <= {16'h00ff,8'h01};
			ram2[1] <= {16'h00ff,8'h02};
			ram2[2] <= {16'h0200,8'h03};
			fifo_pkt_rd <= 0;
			pkt_vld_out <= 0;
			action_out <= 0;
			state_out <= 0;
		end else begin
			if(mm_cam_vld)begin
				if(action_tmp[15:8] > 0)begin
					action_out <= action_tmp;
					state_out <= state_tmp;
					fifo_pkt_rd <= 1;
					pkt_vld_out <= 1;
					pkt_data_out <= fifo_pkt_dout;
				end else if(action_tmp[7:0] > 0)begin
					ram_cam[cam_q_data] <= ram2[cam_q_data * 8 + state_tmp];
					action_out <= action_tmp;
					state_out <= state_tmp;
					pkt_data_out <= fifo_pkt_dout;
					fifo_pkt_rd <= 1;
					pkt_vld_out <= 1;
				end
			end else begin
				action_out <= 0;
				fifo_pkt_rd <= 0;
				pkt_vld_out <= 0;
				state_out <= 0;
			end
		end
	end		
	

	endmodule
