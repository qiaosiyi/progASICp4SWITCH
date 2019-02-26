`timescale 1us / 1us
//pkt_ctl 0x00:invalid
//pkt_ctl 0x01:start
//pkt_ctl 0x02:stop
//pkt_ctl 0x03:64byte packet, only takes one cycle.


module test_b;

	wire rdy=0;
	reg	reset=1, clk=0;
	reg [511:0] pkt_data [0:3];
	reg [7:0] pkt_ctl [0:3];
	reg [0:0] times=0;
	reg [1:0] pkt_cnt=0;

	reg [511:0] pkt_data_in=0;
	reg [7:0] pkt_ctl_in=0;
	always begin
		#5 clk = 1;
		#5 clk = 0;
	end

	initial begin

		#7 reset = 1;

		#23 reset = 0;
	end
   
   
	always@(posedge clk or reset)begin
		if(reset)begin
			pkt_data[0] <= 'ha;
			pkt_ctl[0] <= 'h1;
			pkt_data[1] <= 'hb;
			pkt_ctl[1] <= 'h2;
			pkt_data[2] <= 'hc;
			pkt_ctl[2] <= 'h3;
			pkt_data[3] <= 'hd;
			pkt_ctl[3] <= 'h0;
		end else begin
			
			if(times == 1)begin
				pkt_data_in <= pkt_data[pkt_cnt];
				pkt_ctl_in <= pkt_ctl[pkt_cnt];
				pkt_cnt <= pkt_cnt + 1;
			end else begin
				pkt_ctl_in <= 0;
			end
			times <= times + 1;
			
		end
	end

endmodule // main
