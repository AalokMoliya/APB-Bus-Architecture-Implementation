module apb_master(
  input pclk, 
  input preset,
  input [31:0]paddr,
  input pwrite,
  input [2:0]pprot,
  input [31:0]pwdata,
  input [3:0]pstrb,
  output  reg[31:0]prdata,
  output pslverr,
  output reg penable,
  input [3:0]psel,
  output reg pready
);
 
  wire [31:0] prdata0,prdata1,prdata2,prdata3;
  wire pslverr0,pslverr1,pslverr2,pslverr3;
  wire prady0,pready1,pready2,pready3;
  apb_slave slave0 (pclk,psel[0],penable,preset,paddr,pwrite,pprot,pwdata,pstrb,prdata0,pslverr1,pready0);
  apb_slave slave1 (pclk,psel[1],penable,preset,paddr,pwrite,pprot,pwdata,pstrb,prdata1,pslverr2,pready1);
  apb_slave slave2 (pclk,psel[2],penable,preset,paddr,pwrite,pprot,pwdata,pstrb,prdata2,pslverr3,pready2);
  apb_slave slave3 (pclk,psel[3],penable,preset,paddr,pwrite,pprot,pwdata,pstrb,prdata3,pslverr4,pready3); 
  assign pslverr=pslverr0|pslverr1|pslverr2|pslverr3;
  reg [1:0]state,nextstate;
  parameter idle=2'b0,setup=2'd1,access=2'd2;
  
  always@(posedge pclk)begin
      if(~preset) state=idle;
      else state=nextstate;
  end
  
  always @(*) begin
    case (state)
      idle : begin
        penable=1'b0;
        if(|psel) nextstate=setup;
      end
      
      setup : begin
        penable=1'b0;
        nextstate=access;
      end
      
      access:  begin
        penable=1'b1;
        if ( (psel!=4'b0) && (pready==1'b1)) nextstate=setup;
        else if( (psel==4'b0) && (pready==1'b1)) nextstate=idle;
        else nextstate=access;
      end
    endcase
    case (psel)
        4'b0001 : prdata=prdata0;
        4'b0010 : prdata=prdata1;
        4'b0100 : prdata=prdata2;
        4'b1000 : prdata=prdata3;
      		endcase 
    pready=pready0|pready1|pready2|pready3;
  end
  
endmodule
