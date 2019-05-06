`timescale 1ns/1ps

module passive_meas #(
  parameter  C_LENGTH_WIDTH = 16,
  parameter  C_ID_WIDTH = 12,
  parameter  C_COUNTER_WIDTH = 20,
  parameter  C_PD_WIDTH = 32
  )(
  input                                 [31:0]  in_time_p,
  input                                         in_enable,
    
  input                                         in_sdn_valid,
  input                   [C_LENGTH_WIDTH-1:0]  in_sdn_length,     //packets lenth value
  input                       [C_ID_WIDTH-1:0]  in_sdn_id,       //packets FLOW-ID
  
  input                                       in_set_plut_valid, //BRAM INTERFACE
  input                       [11:0]            in_set_pult_add,
  input                       [31:0]           in_set_pult_value,
    
  output                                        out_dma_fifo_valid,  //to DMA REPORT MODULE
  output                  [C_ID_WIDTH - 1 : 0]  out_dma_fifo_id,
  output             [C_COUNTER_WIDTH - 1 : 0]  out_dma_fifo_data,  //to DMA REPORT MODULE
	
  input                                         rst,  
  input                                         clk
  );
  // ------------- Regs/ wires -----------
  
  wire                                          couter_valid_sp;
  wire                   [C_COUNTER_WIDTH-1:0]  counter_data_sp;
  wire                    [C_LENGTH_WIDTH-1:0]  lenth_Data_next_sp;
  wire                        [C_ID_WIDTH-1:0]  id_data_next_sp;     

  wire                                          ready_read1_sc;
  wire                                          ready_read2_sc;
  
  wire                                          update_valid_gs;
  wire                   [C_COUNTER_WIDTH-1:0]  counter_data_gs;
  wire                        [C_ID_WIDTH-1:0]  id_next_gs;  
  

  wire                                          update2cnew_cvalid_pg;
  wire                   [C_COUNTER_WIDTH-1:0]  update2cnew_c_pg;
  
  wire                                          update2cnew_pvalid_pg;
  wire                        [C_PD_WIDTH-1:0]  update2cnew_pd_pg;
  wire                        [C_ID_WIDTH-1:0]  update2cnew_id_pg;
  
  wire                        [C_PD_WIDTH-1:0]  rand_num;
  
  wire                                          bram1_ena_sb;
  wire                                          bram1_wea_sb;
  wire                        [C_ID_WIDTH-1:0]  bram1_addr_sb;
  wire                   [C_COUNTER_WIDTH-1:0]  bram1_din_sb;
  wire                   [C_COUNTER_WIDTH-1:0]  bram1_dout_sb;
  
  wire                                          bram2_ena_sb;
  wire                                          bram2_wea_sb;
  wire                        [C_ID_WIDTH-1:0]  bram2_addr_sb;
  wire                   [C_COUNTER_WIDTH-1:0]  bram2_din_sb;
  wire                   [C_COUNTER_WIDTH-1:0]  bram2_dout_sb;

  wire                                          bram1_enb_bc;
  wire                                          bram1_web_bc;
  wire                        [C_ID_WIDTH-1:0]  bram1_addr_bc;
  wire                   [C_COUNTER_WIDTH-1:0]  bram1_din_bc;
  wire                   [C_COUNTER_WIDTH-1:0]  bram1_dout_bc;
  
  wire                                          bram2_enb_bc;
  wire                                          bram2_web_bc;
  wire                        [C_ID_WIDTH-1:0]  bram2_addr_bc;
  wire                   [C_COUNTER_WIDTH-1:0]  bram2_din_bc;
  wire                   [C_COUNTER_WIDTH-1:0]  bram2_dout_bc;
  
  scheduler scheduler_FUNC_inst(                              
        
    .in_time_p(in_time_p),  
    .in_enable(in_enable),    
      
    .in_sdn_valid(in_sdn_valid),                                                            
    .in_sdn_length(in_sdn_length),                                                   
    .in_sdn_id(in_sdn_id),                                                     
  
    .in_update_c_valid(update_valid_gs),
    .in_update_counter_data(counter_data_gs),
    .in_update_id_data(id_next_gs),                                                
    
    .out_next_valid(couter_valid_sp),                                               
    .out_next_counter(counter_data_sp),                                              
    .out_next_length(lenth_Data_next_sp),
    .out_next_id(id_data_next_sp),

    .out_ready_read_1(ready_read1_sc),  
    .out_ready_read_2(ready_read2_sc),
    
    .in_ram_dout1a(bram1_dout_sb),        //to RAM
    .in_ram_dout2a(bram2_dout_sb),
    
    .out_ram_din1a(bram1_din_sb),
    .out_ram_din2a(bram2_din_sb),
    
    .out_ram_en1a(bram1_ena_sb),
    .out_ram_en2a(bram2_ena_sb),                        
    .out_ram_we1a(bram1_wea_sb),                                               
    .out_ram_we2a(bram2_wea_sb),       
    .out_ram_regce1a(),           
    .out_ram_regce2a(),           
	
    .out_ram_addr1a(bram1_addr_sb),      
    .out_ram_addr2a(bram2_addr_sb),
	
    .rst(rst),                                                        
    .clk(clk)
  );    
    
  blk_mem_gen_0 bram1_inst(               
    .clka(clk),              
    .ena(bram1_ena_sb),              
    .wea(bram1_wea_sb),              
    .addra(bram1_addr_sb),            
    .dina(bram1_din_sb),              
    .douta(bram1_dout_sb),            
    .clkb(clk),                       
    .enb(bram1_enb_bc),         
    .web(bram1_web_bc),         
    .addrb(bram1_addr_bc),       
    .dinb(bram1_din_bc),         
    .doutb(bram1_dout_bc)       
  );   
  
  blk_mem_gen_0 bram2_inst(          
    .clka(clk),                  
    .ena(bram2_ena_sb),         
    .wea(bram2_wea_sb),         
    .addra(bram2_addr_sb),       
    .dina(bram2_din_sb),         
    .douta(bram2_dout_sb),       
    .clkb(clk),                  
    .enb(bram2_enb_bc),
    .web(bram2_web_bc),
    .addrb(bram2_addr_bc),
    .dinb(bram2_din_bc),
    .doutb(bram2_dout_bc)
  );
  

  
  probability probability_FUNC_inst(
    
    .in_next_valid(couter_valid_sp),
    .in_next_length(lenth_Data_next_sp),
    .in_next_id(id_data_next_sp),
    .in_next_counter(counter_data_sp),
	
	.in_set_plut_valid(in_set_plut_valid),
	.in_set_pult_add(in_set_pult_add),
	.in_set_pult_value(in_set_pult_value),
    
    .out_couter_update_valid(update2cnew_cvalid_pg),
    .out_counter_data_new(update2cnew_c_pg),
    .out_pd_valid(update2cnew_pvalid_pg),
    .out_pd_data(update2cnew_pd_pg),
    .out_id_data_next(update2cnew_id_pg),
	
    .clk(clk),
    .rst(rst)
  );
  
  
  gencounter gencounter_FUNC_inst(
    .in_gen_counter_valid(update2cnew_cvalid_pg),
    .in_gen_counter_value(update2cnew_c_pg),     //counter value for index ID
    .in_pd_valid(update2cnew_pvalid_pg),
    .in_pd_value(update2cnew_pd_pg),
    .in_id_value(update2cnew_id_pg),       //packets FLOW-ID
    
    .out_update_valid(update_valid_gs),
    .out_counter_data_new(counter_data_gs),
    .out_id_data_next(id_next_gs),

    .clk(clk),
    .rst(rst)
  );
  
    cutdata cutdata_FUNC_inst(                                                        
    .in_ready_read_1(ready_read1_sc),
    .in_ready_read_2(ready_read2_sc),        
    
    .in_ram_dout1b(bram1_dout_bc),                 
    .in_ram_dout2b(bram2_dout_bc),                 
    
    .out_ram_wen1b(bram1_web_bc),                  
    .out_ram_wen2b(bram2_web_bc),                  
    .out_ram_en1b(bram1_enb_bc),                   
    .out_ram_en2b(bram2_enb_bc),                   
    .out_ram_regce1b(),                            
    .out_ram_regce2b(),                            
    
    .out_ram_addr1b(bram1_addr_bc),
    .out_ram_addr2b(bram2_addr_bc),
    .out_ram_din1b(bram1_din_bc),
    .out_ram_din2b(bram2_din_bc),
    
    .out_dma_fifo_valid(out_dma_fifo_valid),
    .out_dma_fifo_id(out_dma_fifo_id),
    .out_dma_fifo_data(out_dma_fifo_data),
    .rst(rst),  
    .clk(clk)
  );
  
  
endmodule  
