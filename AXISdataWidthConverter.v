`timescale 1ns/1ps
`define TEST
module axis2wtow#(
  parameter C_WIDTH_TDATA = 512,
  parameter C_WIDTH_TKEEP = C_WIDTH_TDATA / 8
)(
  input                                                              in_TVALID,
  output                                                             in_TREADY,
  input                                          [C_WIDTH_TDATA-1:0] in_TDATA,
  input                                          [C_WIDTH_TKEEP-1:0] in_TKEEP,
  input                                                              in_TLAST,

  output reg                                                         out_TVALID,
  input                                                              out_TREADY,
  output reg                                   [C_WIDTH_TDATA/2-1:0] out_TDATA,
  output reg                                   [C_WIDTH_TKEEP/2-1:0] out_TKEEP,
  output reg                                                         out_TLAST,

  input                                                              clk_line_rst,
  input                                                              clk_line
);
  
localparam                                                           S_IDLE = 0;
localparam                                                           S_TRANSA = 1;
localparam                                                           S_TRANSB = 2;
localparam                                                           S_LASTA = 3;
localparam                                                           S_LASTB = 4;
  
reg                                                                  in_buffer_fifo_rd_en;
wire                                             [C_WIDTH_TDATA-1:0] in_buffer_fifo_dout_TDATA;
wire                                             [C_WIDTH_TKEEP-1:0] in_buffer_fifo_dout_TKEEP;
wire                                                                 in_buffer_fifo_dout_TLAST;
wire                                                                 in_buffer_fifo_empty;
wire                                                                 in_buffer_fifo_nearly_full;

reg                                              [C_WIDTH_TDATA-1:0] out_buf_TDATA;
reg                                              [C_WIDTH_TKEEP-1:0] out_buf_TKEEP;
reg                                                                  last_done;
reg                                                           [8:0]  pre_state, next_state;

assign in_TREADY = !in_buffer_fifo_nearly_full;
  
fallthroughfifo
#( .C_WIDTH( C_WIDTH_TDATA + C_WIDTH_TKEEP + 1 ))
in_buffer_fifo_inst
(
  //input
  .din({ in_TDATA, in_TKEEP, in_TLAST }),
  .wr_en(in_TVALID),
  .rd_en(in_buffer_fifo_rd_en),
  //input
  //output
  .dout({ in_buffer_fifo_dout_TDATA, in_buffer_fifo_dout_TKEEP, in_buffer_fifo_dout_TLAST }),
  .full(),
  .nearly_full(in_buffer_fifo_nearly_full),
  .empty(in_buffer_fifo_empty),
  //output
  .rst(clk_line_rst),
  .clk(clk_line)
);  
  
/////////////////FSM 1
always @ (posedge clk_line) begin
  if (clk_line_rst) begin
    pre_state <= S_IDLE;
  end else begin
    pre_state <= next_state;
  end
end
/////////////////FSM 1

/////////////////FSM 2, include 5 stages:" .0. .1. .2. .3. .4. ".
always @ (*) begin
  case(pre_state)

    S_IDLE: begin  //waiting for action, doing nothing .0.
      if(!in_buffer_fifo_empty && !in_buffer_fifo_dout_TLAST && out_TREADY) begin
        next_state = S_TRANSA;
      end else if(!in_buffer_fifo_empty && in_buffer_fifo_dout_TLAST && out_TREADY)begin
        next_state = S_LASTA;
      end else begin
        next_state = S_IDLE; 
      end
    end

    S_TRANSA: begin // TRANS step A, send the first 256 bits of this frame .1.
      if(out_TREADY)begin
        next_state = S_TRANSB;
      end else begin
        next_state = S_TRANSA; //fifo empty or ~tready
      end
    end

    S_TRANSB: begin // TRANS step B, send the second 256 bits of this frame .2.
      if( !in_buffer_fifo_empty && !in_buffer_fifo_dout_TLAST && out_TREADY )begin
        next_state = S_TRANSA;
      end  else if(!in_buffer_fifo_empty && in_buffer_fifo_dout_TLAST && out_TREADY)begin
        next_state = S_LASTA;
      end else begin
        next_state = S_TRANSB; 
      end
    end

    S_LASTA: begin //finishing the frame, need to valid TLAST signal, last frame size==256bits. .3.
      if( out_TREADY ) begin
        next_state = S_LASTB;
      end else begin
        next_state = S_LASTA; 
      end
    end

    S_LASTB: begin // last2 B.last frame size==512bits .5.
      if( !in_buffer_fifo_empty && !in_buffer_fifo_dout_TLAST && out_TREADY ) begin
        next_state = S_TRANSA;
      end else if(!in_buffer_fifo_empty && in_buffer_fifo_dout_TLAST && out_TREADY)begin
        next_state = S_LASTA; //next data is also a last frame, and need be sent.
      end else if (!out_TREADY) begin
        next_state = S_LASTB; // ~tready. just waiting for valid tready.
      end else begin
        next_state = S_IDLE;
      end
    end
  endcase
end
/////////////////FSM 2  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
