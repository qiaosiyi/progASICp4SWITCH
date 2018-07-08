`timescale 1ns / 1ps
`define NULL 0

// Coder:	joe
// Description:
//	测试文件，读取数据，打入模块
//  
//   
//
//  
//

module PcapParser_test
#(
		parameter DATA_WIDTH = 480,
		parameter CTRL_WIDTH=32,
		parameter STAGE_NUMBER = 2,
		parameter NUM_QUEUES = 8
	);

	// Inputs
	reg CLOCK = 0;
	reg paused0 = 0;
	reg paused1 = 0;
	reg rst=0;
	wire available0;
	wire available1;
	wire [7:0] pktcount0;
	wire [7:0] pktcount1;
	wire streamvalid0;
	wire streamvalid1;
	wire [7:0] stream0;
	wire [7:0] stream1;
	wire pcapfinished0;
	wire pcapfinished1;
	wire newpkt0;
	wire newpkt1;
	
	wire out_ia_wr;
	wire [CTRL_WIDTH-1:0] out_ia_ctl;
	wire [DATA_WIDTH-1:0] out_ia_data;
	
	wire out_wr0;
	wire [CTRL_WIDTH-1:0] out_ctl0;
	wire [DATA_WIDTH-1:0] out_data0;
	
	wire out_wr1;
	wire [CTRL_WIDTH-1:0] out_ctl1;
	wire [DATA_WIDTH-1:0] out_data1;
	
	wire out_wr_crossbar0;
	wire [CTRL_WIDTH-1:0] out_ctl_crossbar0;
	wire [DATA_WIDTH-1:0] out_data_crossbar0;
	
	wire out_wr_crossbar1;
	wire [CTRL_WIDTH-1:0] out_ctl_crossbar1;
	wire [DATA_WIDTH-1:0] out_data_crossbar1;
	
	wire out_wr_lookup0;
	wire [CTRL_WIDTH-1:0] out_ctl_lookup0;
	wire [DATA_WIDTH-1:0] out_data_lookup0;
	
	wire out_wr_lookup1;
	wire [CTRL_WIDTH-1:0] out_ctl_lookup1;
	wire [DATA_WIDTH-1:0] out_data_lookup1;

	// Instantiate the Unit Under Test (UUT)
	PcapParser #(
		.pcap_filename( "2.pcap" )
	) pcap0 (
		.CLOCK(CLOCK),
		.pause(paused0),
		.available(available0),
		.datavalid(streamvalid0),
		.data(stream0),
		.pktcount(pktcount0),
		.newpkt(newpkt0),
		.pcapfinished(pcapfinished0)
	);
	
	PcapParser #(
		.pcap_filename( "1.pcap" )
	) pcap1 (
		.CLOCK(CLOCK),
		.pause(paused1),
		.available(available1),
		.datavalid(streamvalid1),
		.data(stream1),
		.pktcount(pktcount1),
		.newpkt(newpkt1),
		.pcapfinished(pcapfinished1)
	);
	
	c8to512 #(
		
	) c8to512_0(
		.clk(CLOCK),
		.rst(rst),
		.data_in(stream0),
		.datavalid(available0),
		.newpkt(newpkt0),
		.out_wr(out_wr0),
		.out_ctl(out_ctl0),
		.out_data(out_data0)
	);
	c8to512 #(
		
	) c8to512_1(
		.clk(CLOCK),
		.rst(rst),
		.data_in(stream1),
		.datavalid(available1),
		.newpkt(newpkt1),
		.out_wr(out_wr1),
		.out_ctl(out_ctl1),
		.out_data(out_data1)
	);
	
	flowtablepoint
	#() flowtablepoint0(
		.clk(CLOCK),
		.rst(rst),
		
		//////////////////////////////////////////////////0
		.in_wr_0_0(out_wr0),
		.in_ctl_0_0(out_ctl0),
		.in_data_0_0(out_data0),
		
		.in_wr_0_1(),
		.in_ctl_0_1(),
		.in_data_0_1(),
		
		.in_wr_0_2(),
		.in_ctl_0_2(),
		.in_data_0_2(),
		
		.in_wr_0_3(),
		.in_ctl_0_3(),
		.in_data_0_3(),
		//////////////////////////////////////////////////1
		/* .in_wr_1_0(out_wr1),
		.in_ctl_1_0(out_ctl1),
		.in_data_1_0(out_data1), */
		
		.in_wr_1_0(out_wr0),
		.in_ctl_1_0(out_ctl0),
		.in_data_1_0(out_data0),
		
		.in_wr_1_1(),
		.in_ctl_1_1(),
		.in_data_1_1(),
		
		.in_wr_1_2(),
		.in_ctl_1_2(),
		.in_data_1_2(),
		
		.in_wr_1_3(),
		.in_ctl_1_3(),
		.in_data_1_3(),
		//////////////////////////////////////////////////2
		.in_wr_2_0(),
		.in_ctl_2_0(),
		.in_data_2_0(),
		
		.in_wr_2_1(),
		.in_ctl_2_1(),
		.in_data_2_1(),
		
		.in_wr_2_2(),
		.in_ctl_2_2(),
		.in_data_2_2(),
		
		.in_wr_2_3(),
		.in_ctl_2_3(),
		.in_data_2_3(),
		//////////////////////////////////////////////////3
		.in_wr_3_0(),
		.in_ctl_3_0(),
		.in_data_3_0(),
		
		.in_wr_3_1(),
		.in_ctl_3_1(),
		.in_data_3_1(),
		
		.in_wr_3_2(),
		.in_ctl_3_2(),
		.in_data_3_2(),
		
		.in_wr_3_3(),
		.in_ctl_3_3(),
		.in_data_3_3(),
		//////////////////////////////////////////////////
		//////////////////////////////////////////////////0
		.out_wr_0_0(),
		.out_ctl_0_0(),
		.out_data_0_0(),
		
		.out_wr_0_1(),
		.out_ctl_0_1(),
		.out_data_0_1(),
		
		.out_wr_0_2(),
		.out_ctl_0_2(),
		.out_data_0_2(),
		
		.out_wr_0_3(),
		.out_ctl_0_3(),
		.out_data_0_3(),
		//////////////////////////////////////////////////1
		.out_wr_1_0(),
		.out_ctl_1_0(),
		.out_data_1_0(),
		
		.out_wr_1_1(),
		.out_ctl_1_1(),
		.out_data_1_1(),
		
		.out_wr_1_2(),
		.out_ctl_1_2(),
		.out_data_1_2(),
		
		.out_wr_1_3(),
		.out_ctl_1_3(),
		.out_data_1_3(),
		//////////////////////////////////////////////////2
		.out_wr_2_0(),
		.out_ctl_2_0(),
		.out_data_2_0(),
		
		.out_wr_2_1(),
		.out_ctl_2_1(),
		.out_data_2_1(),
		
		.out_wr_2_2(),
		.out_ctl_2_2(),
		.out_data_2_2(),
		
		.out_wr_2_3(),
		.out_ctl_2_3(),
		.out_data_2_3(),
		//////////////////////////////////////////////////3
		.out_wr_3_0(),
		.out_ctl_3_0(),
		.out_data_3_0(),
		
		.out_wr_3_1(),
		.out_ctl_3_1(),
		.out_data_3_1(),
		
		.out_wr_3_2(),
		.out_ctl_3_2(),
		.out_data_3_2(),
		
		.out_wr_3_3(),
		.out_ctl_3_3(),
		.out_data_3_3()
		//////////////////////////////////////////////////
		
		
	);
	

	always #10 CLOCK = ~CLOCK;
	
	//always #100 paused = ~paused;

	integer i;

	initial begin

		$dumpfile("pcap.lxt");
		//$dumpvars(0);

		// Initialize Inputs
		$display("Reading from pcap");

		// Wait 100 ns for global reset to finish
		#50; 
		rst = 1;

		// Add stimulus here
		while (~pcapfinished0 ) begin
			//$display("stream: %8d %x %d %x %x %c", i, paused, pktcount, streamvalid, stream, stream);
			#20
			i = i+1;
		end

		$finish;

	end

endmodule


