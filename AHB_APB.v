module AHB_APB(
     input h_clk,
     input h_reset,
     input h_write,
     input h_readyin,
     input [1:0]h_trans,
     input [31:0] h_addr,
     input [31:0] h_wdata,
      output p_write,
      output p_enable,
      output [2:0] p_selx,
      output [31:0] p_wdata,
      output [31:0] p_addr,
      output  [31:0] p_rdata,
      output  h_readyout);
      
      wire [2:0] tempsel;
      wire [31:0] h_rdata;
      wire [1:0] h_resp;
     wire valid;
      wire [31:0] h_addr1;
      wire [31:0] h_addr2;
      wire [31:0] h_wdata1;
      wire [31:0] h_wdata2;
     wire writereg;
      assign h_rdata=p_rdata;
      
      AHB_SLAVE  uut1(h_clk,h_reset,h_write,h_readyin,h_trans,h_addr,h_wdata,h_readyout,h_rdata,h_resp,valid,h_addr1,h_addr2,h_wdata1,h_wdata2,writereg,tempsel);
      APB uut2(h_clk,h_reset,valid,h_write,h_addr,h_addr1,h_addr2,h_wdata1,h_wdata2,h_wdata,writereg,tempsel,p_write,p_enable,p_selx,p_wdata,p_addr,p_rdata,h_readyout);
    endmodule