module APB(
      input h_clk,
      input h_reset,
      input valid,
      input h_write,
      input [31:0] h_addr,
      input [31:0] h_addr1,
      input [31:0] h_addr2,
      input [31:0] h_wdata1,
      input [31:0] h_wdata2,
      input [31:0] h_wdata,
      input writereg,
      input [2:0] tempsel,
      output reg p_write,
      output reg p_enable,
      output reg [2:0] p_selx,
      output reg [31:0] p_wdata,
      output reg [31:0] p_addr,
      output reg [31:0] p_rdata,
      output reg h_readyout);
  
  reg [2:0]ps,ns;  
  
  parameter [2:0] IDLE=3'd0,
                  ST_WWAIT=3'd1,
                  ST_WRITEP=3'd2,
                  ST_WRITE=3'd3,
                  ST_WENABLEP =3'd4,
                  ST_WENABLE=3'd5,
                  ST_READ=3'd6,
                  ST_RENABLE=3'd7;
  
 always @(posedge h_clk or negedge h_reset)
   if(!h_reset)begin
      p_write<=0;
      p_enable <=0;
      p_selx<=0;
      p_wdata<=0;
      p_addr<=0;
      p_rdata<=0;
      h_readyout<=1;
      ps<=IDLE;
      ns<=0;
   end
  else
    ps<=ns;
  
  always @(*)
    begin
      ns=0;
     
      case(ps)
        IDLE:  if(valid && h_write) ns=ST_WWAIT;
               else if(valid==0) ns=IDLE;
               else if(valid && ~h_write) ns=ST_READ;
        
        ST_WWAIT: if(valid) ns=ST_WRITEP;
                  else ns=ST_WRITE;
        
        ST_WRITEP: ns=ST_WENABLEP;
        
        ST_WENABLEP: if(valid && writereg) ns=ST_WRITEP;
                    else if(~valid && writereg) ns=ST_WRITE;
                    else if(~writereg) ns=ST_READ;
        
        ST_WRITE: if(valid) ns=ST_WENABLEP;
                  else ns=ST_WENABLE;
        
        ST_WENABLE: if(valid && h_write) ns=ST_WWAIT;
                    else if(valid && ~h_write) ns=ST_READ;
                    else if(~valid) ns=IDLE;
        
        ST_READ: ns=ST_RENABLE;
        
        ST_RENABLE: if(~valid) ns=IDLE;
                    else if(valid && ~h_write) ns=ST_READ;
                    else if(valid && h_write) ns=ST_WWAIT;
      endcase
    end

  always @(posedge h_clk)begin
     // p_write<=p_write;
     // p_enable<=p_enable;
     // p_selx<=p_selx;
     // p_addr<=p_addr;
     // h_readyout<=h_readyout;
     // p_wdata<=p_wdata;
     // p_rdata<=p_rdata; 
    #1;
    case(ps)
      IDLE: begin 
            p_enable<=0;
            p_selx<=tempsel;
            h_readyout<=1'b1;
            end
      
      ST_WWAIT: begin
                 h_readyout<=1'b1;
               p_selx<=0;
               p_enable<=0;
                end
      
      ST_WRITEP: begin
                p_addr<=h_addr2;
                p_wdata<=h_wdata1;
                p_enable<=0;
                p_selx<=tempsel;
                h_readyout<=1'b0;
                p_write<=1'b1;
                end
      
      ST_WRITE: begin
               p_enable<=1'b0;
                h_readyout<=1'b0;
                p_selx<=tempsel;
                p_write<=1'b1;
                p_addr<=h_addr2;
                p_wdata<=h_wdata1;
                end
      
      ST_WENABLEP: begin 
                  p_enable<=1'b1;
        if(ns==ST_READ)h_readyout<=1'b0;
        else h_readyout<=1'b1;
                   end
      
      ST_WENABLE: begin
                 p_enable<=1'b1;
                  p_write<=1'b1;
                  h_readyout<=1'b1;
                  end
      
      ST_READ: begin 
        p_write<=1'b0;
        p_addr<=h_addr1;
        p_selx<=tempsel;
        h_readyout<=1'b0;
        p_rdata<=32'bx;
        p_enable<=1'b0;
      end
      
      ST_RENABLE: begin 
        p_rdata<={$urandom}/256;
        p_enable<=1'b1;
        h_readyout <=1'b1;
        p_write<=1'b0;
        p_selx<=tempsel;
      end
    endcase
  end
endmodule