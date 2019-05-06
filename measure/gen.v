`timescale 1ns / 1ps

module gencounter #(
  parameter  C_LENGTH_WIDTH = 16,
  parameter  C_ID_WIDTH = 12,
  parameter  C_COUNTER_WIDTH = 20,
  parameter  C_PD_WIDTH = 32
  )(
    
  input                                         in_gen_counter_valid,
  input                  [C_COUNTER_WIDTH-1:0]  in_gen_counter_value,     //counter value for index ID
  input                                         in_pd_valid,
  input                       [C_PD_WIDTH-1:0]  in_pd_value,
  input                       [C_ID_WIDTH-1:0]  in_id_value,       //packets FLOW-ID
  
  output reg                                    out_update_valid,
  output reg             [C_COUNTER_WIDTH-1:0]  out_counter_data_new,
  output reg                  [C_ID_WIDTH-1:0]  out_id_data_next,    //if any valid signals include 1,couter_update_valid 2,in_pd_valid. "out_id_data_next"should be valid too.

  input                                         clk,
  input                                         rst
  );
  
  reg                                   [31:0]  random;
  
  always @(posedge clk) begin
    if(rst) begin
      out_update_valid <= 0;
      out_counter_data_new <= 0;
      out_id_data_next <= 0;
    end else begin
      if(in_gen_counter_valid)begin
        out_counter_data_new <= in_gen_counter_value;   //update every packet lenth, when counter value is small.
        out_id_data_next <= in_id_value;
        out_update_valid <= 1;
      end else if(in_pd_valid) begin
        if(random <= in_pd_value) begin  
          out_counter_data_new <= in_gen_counter_value + 1; //update a new counter value
          out_id_data_next <= in_id_value;
          out_update_valid <= 1;
        end else begin
          out_counter_data_new <= in_gen_counter_value;   // it needs not to update the counter number
          out_id_data_next <= in_id_value;
          out_update_valid <= 1;
        end
      end else begin
        out_update_valid <= 0;
      end
    end
  
  end
  
  always@(posedge clk)
  begin
    if(rst)
      random <= 32'b1100_1010_1111_0000_1010_1110_0010_0101;
    else begin
      random[0] <= random[31];
      random[1] <= random[0];
      random[2] <= random[1];
      random[3] <= random[2];
      random[4] <= random[3] ^ random[31];
      random[5] <= random[4];
      random[6] <= random[5];
      random[7] <= random[6];
      random[8] <= random[7];
      random[9] <= random[8] ^ random[31];
      random[10] <= random[9] ^ random[31];
      random[11] <= random[10] ^ random[31];
      random[12] <= random[11];
      random[13] <= random[12];
      random[14] <= random[13] ^ random[31];
      random[15] <= random[14];
      random[16] <= random[15] ^ random[31];
      random[17] <= random[16] ^ random[31];
      random[18] <= random[17] ^ random[31];
      random[19] <= random[18] ^ random[31];
      random[20] <= random[19] ^ random[31];
      random[21] <= random[20] ^ random[31];
      random[22] <= random[21] ^ random[31];
      random[23] <= random[22] ^ random[31];
      random[24] <= random[23] ^ random[31];
      random[25] <= random[24] ^ random[31];
      random[26] <= random[25];
      random[27] <= random[26];
      random[28] <= random[27];
      random[29] <= random[28];
      random[30] <= random[29];
      random[31] <= random[30];  
    end  
  end 
endmodule
