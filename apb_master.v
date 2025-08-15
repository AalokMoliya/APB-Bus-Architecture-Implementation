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
  output reg [3:0]psel,
  output reg pready
);
 
  wire [31:0] prdata0,prdata1,prdata2,prdata3;
  wire pslverr0,pslverr1,pslverr2,pslverr3;
  wire pready0,pready1,pready2,pready3;
  apb_slave slave0 (pclk,psel[0],penable,preset,paddr,pwrite,pprot,pwdata,pstrb,prdata0,pslverr0,pready0);
  apb_slave slave1 (pclk,psel[1],penable,preset,paddr,pwrite,pprot,pwdata,pstrb,prdata1,pslverr1,pready1);
  apb_slave slave2 (pclk,psel[2],penable,preset,paddr,pwrite,pprot,pwdata,pstrb,prdata2,pslverr2,pready2);
  apb_slave slave3 (pclk,psel[3],penable,preset,paddr,pwrite,pprot,pwdata,pstrb,prdata3,pslverr3,pready3); 
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
        if(|paddr) nextstate=setup;
      end
      
      setup : begin
        penable=1'b0;
        nextstate=access;
      end
      
      access:  begin
        penable=1'b1;
        if ( (paddr!=4'b0) && (pready==1'b1)) nextstate=setup;
        else if( (paddr==4'b0) && (pready==1'b1)) nextstate=idle;
        else nextstate=access;
      end
       default nextstate=idle;
    endcase
    case (paddr[31:30])
        2'b00 : begin
                psel=4'b0001;
                prdata=prdata0;
                end
        2'b01 : begin
                psel=4'b0010;
                prdata=prdata1;
                end
        2'b10 : begin
                psel=4'b0100;
                prdata=prdata2;
                end
        2'b11 : begin
                psel=4'b1000;
                prdata=prdata3;
                end
    endcase
    pready=pready0|pready1|pready2|pready3;
  end
  
endmodule


 module apb_slave( 
    input pclk,
    input psel,
    input penable,
    input preset, 
    input [31:0]paddr,
    input pwrite,
    input [2:0]pprot,
    input [31:0]pwdata,
    input [3:0]pstrb,
    output reg [31:0]prdata,
    output reg pslverr,
    output reg pready
   
  );
   reg ready=1'b0;
   wire [31:0]rdata;
   storage m1(pwrite,paddr,pwdata,pstrb,rdata);
   always @(*) begin
     if(psel & penable & pwrite) begin
            ready=1'b1;
          end
     else if(psel & penable & ~pwrite) begin
            ready=1'b1;
          end
     else if( ~penable) begin
            ready=1'b0;
          end
     if((pwrite==1'b1) && (psel==1'b1) && pwdata===32'bx) pslverr=1'b1;
     else if((pwrite==1'b0) &&(psel==1'b1)&& pwdata===32'bx) pslverr=1'b1;
     else pslverr=1'b0;
   end
   always @(posedge pclk)begin
    pready=ready;
     prdata=rdata;
   end   
 endmodule
 
 
module storage(input pwrite,input [31:0]paddr,input [31:0]pwdata,input [3:0]pstrb,output reg [31:0]prdata);
   reg [31:0]memory[0:2^32-1];
  always @(*) begin
    if(pwrite) begin
      prdata=32'b0;
      		if(pstrb==4'b0) begin
            	memory[paddr]=pwdata;
            end
            else begin
              if (pstrb[0]) memory[paddr][7:0]   = pwdata[7:0];
            	if (pstrb[1]) memory[paddr][15:8]  = pwdata[15:8];
           		if (pstrb[2]) memory[paddr][23:16] = pwdata[23:16];
            	if (pstrb[3]) memory[paddr][31:24] = pwdata[31:24];
            end
    end
    else prdata=memory[paddr];
  end
  
endmodule
