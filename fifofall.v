`timescale 1ns/1ps

module fifofall #(
  parameter C_WIDTH = 28,
  parameter C_MAX_DEPTH_BITS = 2,
  parameter C_NEARLY_FULL = 2 ** C_MAX_DEPTH_BITS - 1
  )(

  input                          [C_WIDTH-1:0]  din,     // Data in
  input                                         wr_en,   // Write enable
  input                                         rd_en,   // Read the next word

  output                         [C_WIDTH-1:0]  dout,    // Data out
  output                                        full,
  output                                        nearly_full,
  output                                        empty,

  input                                         rst,
  input                                         clk
  );

  localparam L_MAX_DEPTH = 2 ** C_MAX_DEPTH_BITS;
  localparam L_SEL_DIN   = 0;
  localparam L_SEL_QUEUE = 1;
  localparam L_SEL_KEEP  = 2;

  reg                            [C_WIDTH-1:0]  queue  [L_MAX_DEPTH - 1 : 0];
  reg               [C_MAX_DEPTH_BITS - 1 : 0]  rd_ptr;
  wire              [C_MAX_DEPTH_BITS - 1 : 0]  rd_ptr_plus1 = rd_ptr + 1;
  reg               [C_MAX_DEPTH_BITS - 1 : 0]  wr_ptr;
  reg                   [C_MAX_DEPTH_BITS : 0]  depth;

  reg                            [C_WIDTH-1:0]  queue_rd;
  reg                            [C_WIDTH-1:0]  din_d1;
  reg                            [C_WIDTH-1:0]  dout_d1;
  reg                                    [1:0]  dout_sel;
   
  wire rd_en1;
  assign rd_en1 = ( empty == 1 ) ? 0 : rd_en;

  // Sample the data
  always @(posedge clk) begin
    if (wr_en)
      queue[wr_ptr] <= din;
    queue_rd <= queue[rd_ptr_plus1];
    din_d1 <= din;
    dout_d1 <= dout;
    if (rd_en1 && wr_en && (rd_ptr_plus1==wr_ptr)) begin
      dout_sel <= L_SEL_DIN;
    end else if(rd_en1) begin
      dout_sel <= L_SEL_QUEUE;
    end else if(wr_en && (rd_ptr==wr_ptr)) begin
      dout_sel <= L_SEL_DIN;
    end else begin
      dout_sel <= L_SEL_KEEP;
    end
  end

  always @(posedge clk) begin
    if (rst) begin
      rd_ptr <= 'h0;
      wr_ptr <= 'h0;
      depth <= 'h0;
    end else begin
      if (wr_en) wr_ptr <= wr_ptr + 'h1;
      if (rd_en1) rd_ptr <= rd_ptr_plus1;
      if (wr_en & ~rd_en1) depth <=
                                    // synthesis translate_off
                                    //#1
                                    // synthesis translate_on
                                    depth + 'h1;
      if (~wr_en & rd_en1) depth <=
                                    // synthesis translate_off
                                    // #1
                                    // synthesis translate_on
                                    depth - 'h1;
    end
  end

  assign dout = (dout_sel == L_SEL_QUEUE) ? queue_rd : ((dout_sel == L_SEL_DIN) ? din_d1 : dout_d1);
  assign full = depth == L_MAX_DEPTH;
  assign nearly_full = depth >= C_NEARLY_FULL;
  assign empty = depth == 'h0;

  // synthesis translate_off
  always @(posedge clk) begin
    if (wr_en && depth == L_MAX_DEPTH && !rd_en1)
      $display($time, " ERROR: Attempt to write to full FIFO: %m");
    if (rd_en1 && depth == 'h0)
      $display($time, " ERROR: Attempt to read an empty FIFO: %m");
  end
  // synthesis translate_on

endmodule // small_fifo


/* vim:set shiftwidth=3 softtabstop=3 expandtab: */
