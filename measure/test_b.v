`timescale 1ns / 1ps

module tbNET #(
  parameter  C_LENTH_WIDTH = 16,
  parameter  C_ID_WIDTH = 16,
  parameter  C_COUNTER_WIDTH = 20,
  parameter  C_PD_WIDTH = 32
  )();
  reg                                           clk;
  
  reg                                           valid;
  reg                      [C_LENTH_WIDTH-1:0]  lenth_Data;     //packets lenth value
  reg                         [C_ID_WIDTH-1:0]  ID_Data;       //packets FLOW-ID
  
  toptop toptop(
    .clk(clk),
    .pass()  
  );
  integer outfiles;
  initial begin
    valid = 0;
    ID_Data = 4;
    lenth_Data = 0;
	

  end
  
  always begin
    clk = 1; #5;//100MHz
    clk = 0; #5;
  end
  
  always begin
    #90;
    valid = 1;
    lenth_Data = 64; //Only send 64 miniest packets in 10 Gbps: 10clks delay for 1 packet.
    #10;
    valid = 0;  
  end
endmodule
