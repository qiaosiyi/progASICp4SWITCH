`timescale 1ns / 1ps

module cutdata #(
  parameter  C_LENGTH_WIDTH = 16,
  parameter  C_ID_WIDTH = 12,
  parameter  C_COUNTER_WIDTH = 20,
  parameter  C_PD_WIDTH = 32,
  parameter  ID_READ_NUMBER = 7
  )(
  
  input                                         in_ready_read_1,  
  input                                         in_ready_read_2,
  
  input                  [C_COUNTER_WIDTH-1:0]  in_ram_dout1b,
  input                  [C_COUNTER_WIDTH-1:0]  in_ram_dout2b,
  
  output reg                                    out_ram_wen1b,
  output reg                                    out_ram_wen2b,
  output reg                                    out_ram_en1b,
  output reg                                    out_ram_en2b,
  output reg                                    out_ram_regce1b,
  output reg                                    out_ram_regce2b,
  
  output reg                  [C_ID_WIDTH-1:0]  out_ram_addr1b,
  output reg                  [C_ID_WIDTH-1:0]  out_ram_addr2b,  
  output reg             [C_COUNTER_WIDTH-1:0]  out_ram_din1b,
  output reg             [C_COUNTER_WIDTH-1:0]  out_ram_din2b,
  
  output reg                                    out_dma_fifo_valid,  //to DMA REPORT MODULE
  output reg                  [C_ID_WIDTH-1:0]  out_dma_fifo_id,
  output reg             [C_COUNTER_WIDTH-1:0]  out_dma_fifo_data,  //to DMA REPORT MODULE

  input                                         rst,  
  input                                         clk
  );
  
  reg                                           f1;
  reg                                           f2;
  reg                         [C_ID_WIDTH-1:0]  num1;
  reg                         [C_ID_WIDTH-1:0]  num2;
  reg                                    [8:0]  pre_state, next_state;
  
  localparam                                    S_IDLE = 0;
  localparam                                    S_LOOKUP1 = 1;
  localparam                                    S_SENDDATA1 = 2;
  localparam                                    S_SENDDOWN1 = 3;
  localparam                                    S_CONTINUE1 = 4;
  localparam                                    S_LOOKUP2 = 5;
  localparam                                    S_SENDDATA2 = 6;
  localparam                                    S_SENDDOWN2 = 7;
  localparam                                    S_CONTINUE2 = 8;
  localparam                                    S_GETDATA1 = 10;
  localparam                                    S_GETDATA2 = 11;
  
  
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
    case(pre_state)//pre_state
      S_IDLE: begin
        if(in_ready_read_1 == 1 && f1 == 1)begin
          next_state = S_LOOKUP1;
        end  else if(in_ready_read_2 == 1 && f2 == 1) begin
          next_state = S_LOOKUP2;
        end else begin
          next_state = S_IDLE;
        end
      end
      S_LOOKUP1: begin
        next_state = S_GETDATA1;
      end
      S_GETDATA1: begin
        next_state = S_SENDDATA1;
      end
      S_SENDDATA1: begin
        next_state = S_SENDDOWN1;
      end
      S_SENDDOWN1: begin
        next_state = S_CONTINUE1;
      end
      S_CONTINUE1: begin
        if(out_ram_addr1b < ID_READ_NUMBER)begin
          next_state = S_LOOKUP1;
        end  else begin
          next_state = S_IDLE;
        end
      end
      S_LOOKUP2: begin
        next_state = S_GETDATA2;
      end
      S_GETDATA2: begin
        next_state = S_SENDDATA2;
      end
      S_SENDDATA2: begin
        next_state = S_SENDDOWN2;
      end
      S_SENDDOWN2: begin
        next_state = S_CONTINUE2;
      end
      S_CONTINUE2: begin
        if(out_ram_addr2b < ID_READ_NUMBER)begin
          next_state = S_LOOKUP2;
        end  else begin
          next_state = S_IDLE;
        end
      end
    endcase
  end  
  
//////////////=============================FSM3==========================================

  always @(posedge clk ) begin//posedge clk or  in_ready_read_1 or f1 or in_ready_read_2 or f2 or out_ram_addr1b or out_ram_addr2b or pre_state
    if(rst)begin
      out_dma_fifo_valid <= 0;
      f1 <= 1;
      f2 <= 1;
    end else begin
      case(pre_state)
        S_IDLE: begin
          if(in_ready_read_1 == 1 && f1 == 1)begin
            num1 <= num1 + 1;
            out_ram_addr1b <= num1;
            out_ram_en1b <= 1;
            out_ram_regce1b <= 1;
            f2 <= 1;
          end  else if(in_ready_read_2 == 1 && f2 == 1) begin
            num2 <= num2 + 1;
            out_ram_addr2b <= num2;
            out_ram_en2b <= 1;
            out_ram_regce2b <= 1;
            f1 <= 1;
          end else begin
            num1 <= 0;
            num2 <= 0;
            out_ram_addr1b <= 0;
            out_ram_addr2b <= 0;
            out_ram_en1b <= 0;
            out_ram_en2b <= 0;
            out_ram_regce1b <= 0;
            out_ram_regce2b <= 0;
            out_ram_wen1b <= 0;
            out_ram_wen2b <= 0;
            out_ram_din1b <= 0;
            out_ram_din2b <= 0;
            out_dma_fifo_valid <= 0;
            out_dma_fifo_data <= 0;
          end
        end
        S_LOOKUP1: begin
          //
        end
        S_GETDATA1: begin
          //
        end
        S_SENDDATA1: begin
          out_dma_fifo_valid <= 1;
          out_dma_fifo_data <= in_ram_dout1b;
          out_dma_fifo_id <= num1 - 1;
        end
        S_SENDDOWN1: begin
          out_dma_fifo_valid <= 0;
          out_ram_wen1b <= 1;
          out_ram_din1b <= 0;
        end
        S_CONTINUE1: begin
          if(out_ram_addr1b < ID_READ_NUMBER)begin
            out_ram_wen1b <= 0;
            num1 <= num1 + 1;
            out_ram_addr1b <= num1;
          end  else begin
            f1 <= 0;
            out_ram_wen1b <= 0;
            num1 <= 0;
            out_ram_addr1b <= 0;
            out_ram_en1b <= 0;
            out_ram_regce1b <= 0;
          end
        end
        S_LOOKUP2: begin
          //
        end
        S_GETDATA2: begin
          //
        end
        S_SENDDATA2: begin
          out_dma_fifo_valid <= 1;
          out_dma_fifo_data <= in_ram_dout2b;
          out_dma_fifo_id <= num2 - 1;
        end
        S_SENDDOWN2: begin
          out_dma_fifo_valid <= 0;
          out_ram_wen2b <= 1; 
          out_ram_din2b <= 0; 
        end
        S_CONTINUE2: begin
          if(out_ram_addr2b < ID_READ_NUMBER)begin
            out_ram_wen2b <= 0;
            num2 <= num2 + 1;
            out_ram_addr2b <= num2;
            //f2 <= 1;
          end  else begin
            f2 <= 0;
            out_ram_wen2b <= 0;
            num2 <= 0;
            out_ram_addr2b <= 0;
            out_ram_en2b <= 0;
            out_ram_regce2b <= 0;
          end
        end
      endcase
    end
  end
endmodule
