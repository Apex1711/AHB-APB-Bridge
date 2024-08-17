module tb;
  reg  h_clk;
  reg h_reset;
  reg h_write;
  reg h_readyin;
  reg [2:0] h_tempsel;
  reg [1:0]h_trans;
  reg [31:0]h_addr;
  reg [31:0]h_wdata;
  wire p_write;
  wire p_enable;
  wire [2:0] p_selx;
  wire [31:0] p_wdata;
  wire [31:0] p_addr;
  wire [31:0] p_rdata;
  wire h_readyout;
  integer i;
  
  AHB_APB  uut(h_clk,h_reset,h_write,h_readyin,h_trans,h_addr,h_wdata,p_write,p_enable,p_selx,p_wdata,p_addr,p_rdata,h_readyout);
   
  task t_rst(); begin
      h_reset=1'b1;
      h_clk=1'b0;
      h_write=1'b0;
      h_readyin=1'b0;
      h_trans=2'b0;
      h_addr=32'b0;
    h_wdata=32'b0; end
  endtask
  task read_write();
    begin
      @(posedge h_clk)if(h_readyout)begin #1 h_addr=32'h8009_fe67;
    h_readyin=1'b1;
    h_trans=2'b10;
      h_write=1'b1;end
    @(posedge h_clk)if(h_readyout)begin #1 h_wdata={$random};
      h_readyin=1'b0;
      h_addr=32'h8234_fba7;
      h_write=1'b0;end
    @(posedge h_clk)if(h_readyout)begin #1 h_addr=32'h8034_0c47;
      h_readyin=1'b1;
      h_write=1'b1;
      h_readyin=1'b1;end
    h_wdata={$random};
    for(i=0;i<4;i=i+1)begin @(posedge h_clk)if(h_readyout)begin
      h_readyin=1'b1;
    h_addr=32'h8010_a077;
      h_write=1'b0;end end
    @(posedge h_clk) h_trans=2'd0;
    end
  endtask
  task burst_read();
    begin
      @(posedge h_clk) if(h_readyout)begin
    #1 h_write=1'b0;
    h_tempsel={$random}/8;
    h_trans=2'd2;
    h_readyin=1;
    h_addr=32'h8000_0001; end
    for(i=0;i<6;i=i+1)begin
    @(posedge h_clk) if(h_readyout)begin
          #1 h_addr=h_addr+1;
           h_trans=2'd2;
           h_write=1'b0;
           h_tempsel={$random}/8;
            end end
    @(posedge h_clk)
    h_trans=2'd0;
    end
  endtask
  
  task burst_write();
begin
  @(posedge h_clk) if(h_readyout)begin
    #1 h_write=1'b1;
    h_tempsel={$random}/8;
    h_trans=2'd2;
    h_readyin=1;
    h_addr=32'h8000_0001; end
  @(posedge h_clk) if(h_readyout)begin
    #1 h_addr=h_addr+1'b1;
    h_write=1'b1;
    h_tempsel={$random}/8;
    h_wdata=($random)%256;
    h_trans=2'd3; 
    end

  for(i=0;i<4;i=i+1)begin
    @(posedge h_clk) if(h_readyout)begin
          #1 h_addr=h_addr+1;
           h_write=1'b1;
           h_tempsel={$random}/8;
           h_wdata={$random};
      h_trans=2'd3; 
    end end
  @(posedge h_clk)
  #1 h_wdata={$random};
      h_trans=2'd0;
end
endtask
  
  task single_read();
    begin
      h_readyin=1'b1;
    h_tempsel=3'd5;
    h_trans=2'b10;
    h_addr=32'h8006_09f3;
    h_write=1'b0;
    @ (posedge h_clk)#1
      h_addr=32'hx;
      h_write=1'b0;
      h_trans=2'bx;
      h_readyin=1'bx;
    end
  endtask
  
  task single_write();
    begin
    h_readyin=1'b1;
    h_trans=2'b10;
    h_addr=32'h8006_09f3;
    h_write=1'b1;
      @ (posedge h_clk)#1 h_wdata={$random}; 
      h_addr=32'hx;
      h_write=1'bx;
      h_trans=2'bx;
      h_readyin=1'bx;
    end
  endtask
  
  always #3 h_clk=~h_clk;
  
  initial begin
    t_rst();
    #1 h_reset=1'b0;
    #1 h_reset=1'b1; 
    //#3 single_write();
    //#3 single_read();
    //#3 burst_write();
    //#3 burst_read();
    #3 read_write();
    #40 $finish;
  end
   
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
  end
endmodule