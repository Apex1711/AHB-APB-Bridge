module AHB_SLAVE(
     input h_clk,
     input h_reset,
     input h_write,
     input h_readyin,
     input [1:0]h_trans,
     input [31:0] h_addr,
     input [31:0] h_wdata,
     input  h_readyout,
     output [31:0] h_rdata,
     output reg [1:0] h_resp,
     output reg valid,
     output reg [31:0] h_addr1,
     output reg [31:0] h_addr2,
     output reg [31:0] h_wdata1,
     output reg [31:0] h_wdata2,
     output reg writereg,
     output reg [2:0] tempsel);
  
    reg writereg2;
  always @(posedge h_clk or negedge h_reset)begin
  if(!h_reset)begin
     h_addr1<=32'b0;
     h_addr2<=32'b0;
     h_wdata1<=32'b0;
     h_wdata2<=32'b0;
    writereg<=0;
      end
  else
    if(h_readyout)begin
     h_addr1<=h_addr;
     h_addr2<=h_addr1;
                   
     h_wdata1<=h_wdata;
      h_wdata2<=h_wdata1;end
   
    writereg2<=h_write;
      writereg<=writereg2;
       end
        
  
 always @(*) begin 
     writereg=h_write;
     valid = 1'b0;
   if(h_readyin && (h_trans ==2'b10 || h_trans==2'b11) && (h_addr >=32'h8000_0000 || h_addr <=32'h8c00_0000)) valid=1'b1;
      if(h_addr >=32'h8000_0000 && h_addr<32'h8400_0000) tempsel = 3'b001;
      else if(h_addr >=32'h400_0000 && h_addr<32'h8800_0000) tempsel = 3'b010;
      else if(h_addr >=32'h8800_0000 && h_addr<32'h8c0_0000) tempsel = 3'b100;
      end
endmodule