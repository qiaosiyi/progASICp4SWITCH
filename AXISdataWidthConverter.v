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
  output reg out_TLAST
);
