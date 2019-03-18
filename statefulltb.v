`timescale 1ns / 1ps

module statefulltb;

wire 		pkt_vld_out;
wire [511:0] pkt_data_out;
wire [15:0] action_out;
wire [7:0] state_out;

reg 		pkt_vld_in;
reg [511:0] pkt_data_in;

always begin
		#5 clk = 1;
		#5 clk = 0;
	end

	initial begin

		#7 reset = 1;

		#23 reset = 0;
		
		#10 pkt_vld_in = 1;pkt_data_in = 'h4321;
		#10 pkt_vld_in = 0;pkt_data_in = 0;
		
		#10 pkt_vld_in = 1;pkt_data_in = 'h4321;
		#10 pkt_vld_in = 0;pkt_data_in = 0;
		
		#10 pkt_vld_in = 1;pkt_data_in = 'h4321;
		#10 pkt_vld_in = 0;pkt_data_in = 0;
	end

	
	statefull#()statefull_inst(
		.pkt_vld_in(pkt_vld_in),
		.pkt_data_in(pkt_data_in),

		.pkt_vld_out(pkt_vld_out),
		.pkt_data_out(pkt_data_out),
		.action_out(action_out),
		.state_out(state_out)	
	);
	
	
	

endmodule