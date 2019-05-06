`timescale 1ns / 1ps

module scheduler #(
  parameter C_LENGTH_WIDTH = 16,
  parameter C_ID_WIDTH = 12,
  parameter C_COUNTER_WIDTH = 20,
  parameter C_PD_WIDTH = 32,
  parameter C_TIME_C_COUNTER_WIDTH = 11
  )(
  
  input                                 [31:0]  in_time_p,
  input                                         in_enable,
    
  input                                         in_sdn_valid,        
  input                   [C_LENGTH_WIDTH-1:0]  in_sdn_length,     //packets lenth value
  input                       [C_ID_WIDTH-1:0]  in_sdn_id,       //packets FLOW-ID
    
  input                                         in_update_c_valid,    
  input                  [C_COUNTER_WIDTH-1:0]  in_update_counter_data,
  input                       [C_ID_WIDTH-1:0]  in_update_id_data,
    
  output reg                                    out_next_valid,    //to 4
  output reg             [C_COUNTER_WIDTH-1:0]  out_next_counter,
  output reg              [C_LENGTH_WIDTH-1:0]  out_next_length,
  output reg                  [C_ID_WIDTH-1:0]  out_next_id,    //if any valid signals include 1,couter_update_valid 2,Pd_valid. "out_next_id"should be valid too.
    
  output reg                                    out_ready_read_1,    //to junwei
  output reg                                    out_ready_read_2,     //to 6
      
  input                  [C_COUNTER_WIDTH-1:0]  in_ram_dout1a,    //to from 7
  input                  [C_COUNTER_WIDTH-1:0]  in_ram_dout2a,
    
  output reg             [C_COUNTER_WIDTH-1:0]  out_ram_din1a,
  output reg             [C_COUNTER_WIDTH-1:0]  out_ram_din2a,
    
  output reg                                    out_ram_en1a,
  output reg                                    out_ram_en2a,
  output reg                                    out_ram_we1a,
  output reg                                    out_ram_we2a,
  output reg                                    out_ram_regce1a,
  output reg                                    out_ram_regce2a,
    
  output reg                  [C_ID_WIDTH-1:0]  out_ram_addr1a,
  output reg                  [C_ID_WIDTH-1:0]  out_ram_addr2a,
  
  input                                         rst,  
  input                                         clk
);

  localparam                                    S_IDLE = 0;
  localparam                                    S_ENABLE1A = 1;
  localparam                                    S_LOOKUP1A = 2;
  localparam                                    S_NEWCOUNT1 = 3;
  localparam                                    S_UPDATE1A = 4;
  localparam                                    S_UPDATE1ADOWN = 5;
  localparam                                    S_ENABLE2A = 6;
  localparam                                    S_LOOKUP2A = 7;
  localparam                                    S_NEWCOUNT2 = 8;
  localparam                                    S_UPDATE2A = 9;
  localparam                                    S_UPDATE2ADOWN = 10;
  
  reg                                    [8:0]  pre_state, next_state;
  reg                                 [32-1:0]  time_counter;
  reg                                   [31:0]  timepbefor;
  
  wire                    [C_LENGTH_WIDTH-1:0]  fifo_out_lenth;
  wire                        [C_ID_WIDTH-1:0]  fifo_out_id;
  wire                                          fifo_empty;
  reg                                           fifo_rd_en;
  
  reg                                           ready_write_1;
  reg                                           ready_write_2;

  ///////////////////////////////////////////////////////////////////////////////////////////////
  always @ (posedge clk) begin
    if(rst) begin
      time_counter  <=  0;
    end else begin
      if(time_counter == 2*timepbefor - 1)begin
        time_counter <= 0;
      end else begin
        time_counter <= time_counter + 1;    
      end
    end
  end
  ///////////////////////////////////////////////////////////////////////////////////////////////
  
  always @ (posedge clk) begin
    if(rst)begin
      timepbefor <= 500; //transmit period default time value.
    end else begin
      if(in_time_p < 500)begin
        timepbefor <= 500;
      end else begin
        if(ready_write_1)begin
          timepbefor <= in_time_p;
        end
      end
    end
  end
  
  ///////////////////////////////////////////////////////////////////////////////////////////////
  
  always @ (posedge clk) begin
    if(rst) begin
      out_ready_read_1 <= 0;
      out_ready_read_2 <= 0;
      ready_write_1 <= 0;
      ready_write_2 <= 0;
    end else begin
      if(in_enable)begin
        if(time_counter >= 10 && time_counter <= timepbefor - 10) begin
          out_ready_read_2 <= 1;
          ready_write_2 <= 0;
          out_ready_read_1 <= 0;
          ready_write_1 <= 1;
        end else if(time_counter >= timepbefor + 10 && time_counter <= 2*timepbefor - 1) begin    
          out_ready_read_2 <= 0;
          ready_write_2 <= 1;
          out_ready_read_1 <= 1;
          ready_write_1 <= 0;  
        end else begin
          out_ready_read_2 <= 0;
          ready_write_2 <= 0;
          out_ready_read_1 <= 0;
          ready_write_1 <= 0;  
        end
      end
    end
  end
  
  ////////////////////////////////////////////Outputs TO JUNWEI///////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////
  
  fifofall #(
      .C_MAX_DEPTH_BITS(4)
      )fifofall_IN_inst
      (// Outputs
      .dout              ({fifo_out_lenth, fifo_out_id}),
      .full              (),
      .nearly_full          (),
      .empty            (fifo_empty),
      // Inputs
      .din              ({in_sdn_length, in_sdn_id}),
      .wr_en            (in_sdn_valid),
      .rd_en            (fifo_rd_en),
      
      .rst            (rst),
      .clk              (clk));

//////////////===============================FSM1========================================

  always @ (posedge clk) begin
    if (rst) begin
      pre_state <= S_IDLE;
    end else begin
      pre_state <= next_state;
    end
  end

//////////////================================FSM2=======================================

  always @ (*) begin
    case(pre_state)
      S_IDLE: begin
        if(!fifo_empty && ready_write_1 && in_enable)
          next_state = S_ENABLE1A;
        else if (!fifo_empty && ready_write_2 && in_enable)
          next_state = S_ENABLE2A;
        else
          next_state = S_IDLE;
      end
      S_ENABLE1A: begin
        next_state = S_LOOKUP1A;
      end
      S_LOOKUP1A: begin
        next_state = S_NEWCOUNT1;
      end
      S_NEWCOUNT1: begin
        next_state = S_UPDATE1A;
      end
      S_UPDATE1A: begin
        if(in_update_c_valid)
          next_state = S_UPDATE1ADOWN;
        else
          next_state = S_UPDATE1A;
      end
      S_UPDATE1ADOWN: begin
        if(!fifo_empty && ready_write_1)
          next_state = S_ENABLE1A;
        else
          next_state = S_IDLE;
      end
      S_ENABLE2A: begin
        next_state = S_LOOKUP2A;
      end
      S_LOOKUP2A: begin
        next_state = S_NEWCOUNT2;
      end
      S_NEWCOUNT2: begin
        next_state = S_UPDATE2A;
      end
      S_UPDATE2A: begin
        if(in_update_c_valid)
          next_state = S_UPDATE2ADOWN;
        else
          next_state = S_UPDATE2A;
      end
      S_UPDATE2ADOWN: begin
        if(!fifo_empty && ready_write_2)
          next_state = S_ENABLE2A;
        else
          next_state = S_IDLE;
      end
    endcase
  end

//////////////=============================FSM3==========================================

  always @(posedge clk) begin
    if(rst) begin
      out_next_valid <= 0;
      out_ram_din1a <= 0;
      out_ram_din2a <= 0;
      out_ram_en1a <= 0;
      out_ram_en2a <= 0;
      out_ram_regce1a <= 0;
      out_ram_regce2a <= 0;
      out_ram_we1a <= 0;
      out_ram_we2a <= 0;
      out_ram_addr1a <= 0;
      out_ram_addr2a <= 0;
      fifo_rd_en <= 0;
    end else begin
      case(pre_state)
        S_IDLE: begin
          if(!fifo_empty && ready_write_1 && in_enable) begin
            out_ram_en1a <= 1;
            out_ram_regce1a <= 1;
            out_ram_addr1a <= fifo_out_id;
          end else if (!fifo_empty && ready_write_2 && in_enable) begin
            out_ram_en2a <= 1;
            out_ram_regce2a <= 1;
            out_ram_addr2a <= fifo_out_id;
          end else begin
            out_ram_en1a <= 0;
            out_ram_en2a <= 0;
            out_ram_regce1a <= 0;
            out_ram_regce2a <= 0;
            out_ram_addr1a <= 0;
            out_ram_addr2a <= 0;
          end
        end
        S_ENABLE1A: begin
        end
        S_LOOKUP1A: begin
        end
        S_NEWCOUNT1: begin
          out_next_valid <= 1;
          out_next_counter <= in_ram_dout1a;
          out_next_length <= fifo_out_lenth;
          out_next_id <= fifo_out_id;
          fifo_rd_en <= 1;
        end
        S_UPDATE1A: begin
          if(in_update_c_valid)begin
            out_ram_we1a <= 1;
            out_ram_addr1a <= in_update_id_data;
            out_ram_din1a <= in_update_counter_data;
            fifo_rd_en <= 0;
            out_next_valid <= 0;
          end  else begin
            fifo_rd_en <= 0;
            out_next_valid <= 0;
          end
        end
        S_UPDATE1ADOWN: begin
          if(!fifo_empty && ready_write_1) begin
            out_ram_addr1a <= fifo_out_id;
            out_ram_we1a <= 0;
          end else begin
            out_ram_we1a <= 0;
            out_ram_en1a <= 0;
          end
        end
        S_ENABLE2A: begin
        end
        S_LOOKUP2A: begin
        end
        S_NEWCOUNT2: begin
          out_next_valid <= 1;     // for calc module
          out_next_counter <= in_ram_dout2a; 
          out_next_length <= fifo_out_lenth;
          out_next_id <= fifo_out_id;
          fifo_rd_en <= 1;  
        end
        S_UPDATE2A: begin
          if(in_update_c_valid)begin
            out_ram_we2a <= 1;
            out_ram_addr2a <= in_update_id_data;
            out_ram_din2a <= in_update_counter_data;
            fifo_rd_en <= 0;
            out_next_valid <= 0;
          end  else begin
            fifo_rd_en <= 0;
            out_next_valid <= 0;
          end
        end
        S_UPDATE2ADOWN: begin
          if(!fifo_empty && ready_write_2) begin
            out_ram_addr2a <= fifo_out_id;
            out_ram_we2a <= 0;
          end else begin
            out_ram_we2a <= 0;
            out_ram_en2a <= 0;
          end
        end
      endcase
    end
  end
  
endmodule
