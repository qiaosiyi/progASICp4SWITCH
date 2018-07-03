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
	reg paused = 0;
	reg rst=0;
	wire available;
	wire [7:0] pktcount;
	wire streamvalid;
	wire [7:0] stream;
	wire pcapfinished;
	wire newpkt;
	
	wire out_wr;
	wire [CTRL_WIDTH-1:0] out_ctl;
	wire [DATA_WIDTH-1:0] out_data;

	// Instantiate the Unit Under Test (UUT)
	PcapParser #(
		.pcap_filename( "tcp-4846-connect-disconnect.pcap" )
	) pcap (
		.CLOCK(CLOCK),
		.pause(paused),
		.available(available),
		.datavalid(streamvalid),
		.data(stream),
		.pktcount(pktcount),
		.newpkt(newpkt),
		.pcapfinished(pcapfinished)
	);
	
	c8to512 #(
		
	) c8to512_0(
		.clk(CLOCK),
		.rst(rst),
		.data_in(stream),
		.datavalid(available),
		.newpkt(newpkt),
		.out_wr(out_wr),
		.out_ctl(out_ctl),
		.out_data(out_data)
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
		#10; 
		rst = 1;

		// Add stimulus here
		while (~pcapfinished ) begin
			//$display("stream: %8d %x %d %x %x %c", i, paused, pktcount, streamvalid, stream, stream);
			#20
			i = i+1;
		end

		$finish;

	end

endmodule


