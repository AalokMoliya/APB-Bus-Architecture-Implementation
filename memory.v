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
