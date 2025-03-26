 module apb_slave(
   // input [31:0]memory[0:31],
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
   reg [31:0]rdata;
   storage m1(pwrite,paddr,pwdata,pstrb,rdata);
   always @(*) begin
     if(psel & penable & pwrite) begin
            ready=1'b1;
          /*  if(pstrb==4'b0) begin
            	memory[paddr]=pwdata;
            end
            else begin
              if (pstrb[0]) memory[paddr][7:0]   = pwdata[7:0];
            	if (pstrb[1]) memory[paddr][15:8]  = pwdata[15:8];
           		if (pstrb[2]) memory[paddr][23:16] = pwdata[23:16];
            	if (pstrb[3]) memory[paddr][31:24] = pwdata[31:24];
            end*/
          end
     else if(psel & penable & ~pwrite) begin
            ready=1'b1;
            //prdata=memory[paddr];
          end
     else if(psel & ~penable) begin
            ready=1'b0;
          end
     if((pwrite==1'b1) && (psel==1'b1)) pslverr=1'b1;
     else if((pwrite==1'b0) &&(psel==1'b1)) pslverr=1'b1;
     else pslverr=1'b0;
   end
   always @(posedge pclk)begin
    pready=ready;
     prdata=rdata;
   end
          
 endmodule
