`timescale 1ns/1ps

module apb_master_tb;

  // Inputs
  reg pclk;
  reg preset;
  reg [31:0] paddr;
  reg pwrite;
  reg [2:0] pprot;
  reg [31:0] pwdata;
  reg [3:0] pstrb;

  // Outputs
  wire [3:0] psel;
  wire [31:0] prdata;
  wire pslverr;
  wire pready;
  wire penable;

  // Instantiate DUT
  apb_master uut(
    .pclk(pclk),
    .preset(preset),
    .paddr(paddr),
    .pwrite(pwrite),
    .pprot(pprot),
    .pwdata(pwdata),
    .pstrb(pstrb),
    .prdata(prdata),
    .pslverr(pslverr),
    .pready(pready),
    .psel(psel),
    .penable(penable)
  );

  // Clock generation
  initial begin
    pclk = 0;
    forever #5 pclk = ~pclk; // 100 MHz
  end

  // Testbench logic
  initial begin
    // Initialize
    preset = 0;
    paddr  = 0;
    pwrite = 0;
    pprot  = 3'b000;
    pwdata = 0;
    pstrb  = 4'b0000;

    // Reset pulse
    #10 preset = 1;
    #10;

    // Test Case 1: Write to Slave 0 (paddr[31:30] = 2'b00)
    paddr  = 32'h0000_0004;
    pwrite = 1;
    pwdata = 32'hDEADBEEF;
    pstrb  = 4'b1111;
    #20;

    // Test Case 2: Read from Slave 0
    paddr  = 32'h0000_0004;
    pwrite = 0;
    #20;

    // Test Case 3: Write to Slave 1 (paddr[31:30] = 2'b01)
    paddr  = 32'h4000_0008;
    pwrite = 1;
    pwdata = 32'hCAFEBABE;
    pstrb  = 4'b1111;
    #20;

    // Test Case 4: Read from Slave 1
    paddr  = 32'h4000_0008;
    pwrite = 0;
    #20;

  
    // End
    #50 $finish;
  end

  // Monitor signals
  initial begin
    $monitor("Time=%0t | PADDR=%h | PWDATA=%h | PRDATA=%h | PREADY=%b | PSEL=%b | PWRITE=%b | PENABLE=%b | PSLVERR=%b",
             $time, paddr, pwdata, prdata, pready, psel, pwrite, penable, pslverr);
  end

endmodule
