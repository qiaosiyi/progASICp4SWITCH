`timescale 1ns/1ps
`define TEST
module axis512to256#(
  parameter C_WIDTH_TDATA = 512,
  parameter C_WIDTH_TKEEP = C_WIDTH_TDATA / 8
)(
  input in_TVALID,
  output in_TREADY,
  input [C_WIDTH_TDATA-1:0] in_TDATA,
  input [C_WIDTH_TKEEP-1:0] in_TKEEP,
  input in_TLAST,
  output reg out_TVALID,
  input out_TREADY,
  output reg [C_WIDTH_TDATA/2-1:0] out_TDATA,
  output reg [C_WIDTH_TKEEP/2-1:0] out_TKEEP,
  output reg out_TLAST, 
  input rst,
  input clk
);
  
localparam S_IDLE = 0;
localparam S_TRANSA = 1;
localparam S_TRANSB = 2;
localparam S_LASTA = 3;
localparam S_LASTB = 4;
  
  reg [8:0] pre_state, next_state;
  
  reg in_buf_fifo_rd_en;
  wire [C_WIDTH_TDATA-1:0] in_buf_fifo_dout_TDATA;
  wire 
