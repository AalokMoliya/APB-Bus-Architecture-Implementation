// Code your testbench here
// or browse Examples
/*`timescale 1ns / 1ps

module apb_master_tb;
    
    // Testbench signals
    reg pclk, preset, penable, pwrite;
    reg [31:0] paddr, pwdata;
    reg [3:0] pstrb, psel;
    reg [2:0] pprot;
    wire [31:0] prdata;
    wire pslverr,pready;
  
    
    
    // Instantiate APB Master
    apb_master uut (
        .pclk(pclk),
        .penable(penable),
        .preset(preset),
        .paddr(paddr),
        .pwrite(pwrite),
        .pprot(pprot),
        .pwdata(pwdata),
        .pstrb(pstrb),
        .prdata(prdata),
        .pslverr(pslverr),
        .psel(psel),
        .pready(pready)
    );
    
    // Clock generation
    always #5 pclk = ~pclk;
    
    initial begin
        // Initialize signals
        pclk = 0;
        preset = 0;
        penable = 0;
        pwrite = 0;
        paddr = 32'h0;
        pwdata = 32'h0;
        pstrb = 4'hF;
        pprot = 3'b000;
        psel = 4'b0000;
      $display($time,"psel=%b,penable=%b,preset=%b,pwrite=%b,paddr=%h,pwdata=%h,prdata=%h,pstrb=%b,pready=%b,pslverr=%b",psel,penable,preset,pwrite,paddr,pwdata,prdata,pstrb,pready,pslverr);
        
        // Apply reset
        #10 preset = 1;
        #10;
        
        // Write operation to Slave 0
        psel = 4'b0001;
        pwrite = 1;
        paddr = 32'h10;
        pwdata = 32'hA5A5A5A5;
        penable = 1;
        #20;
      $display($time,"psel=%b,penable=%b,preset=%b,pwrite=%b,paddr=%h,pwdata=%h,prdata=%h,pstrb=%b,pready=%b,pslverr=%b",psel,penable,preset,pwrite,paddr,pwdata,prdata,pstrb,pready,pslverr);
        
        // Read operation from Slave 0
        pwrite = 0;
        #20;
        
        // Check error condition (incorrect write check)
       psel = 4'b0010;
        pwrite = 1;
        paddr = 32'h20;
        pwdata = 32'h12345678;
        pstrb = 4'b0001;
        #20;
      $display($time,"psel=%b,penable=%b,preset=%b,pwrite=%b,paddr=%h,pwdata=%h,prdata=%h,pstrb=%b,pready=%b,pslverr=%b",psel,penable,preset,pwrite,paddr,pwdata,prdata,pstrb,pready,pslverr);
        
        // Read operation to check data integrity
        pwrite = 0;
        #20;
      
      $display($time,"psel=%b,penable=%b,preset=%b,pwrite=%b,paddr=%h,pwdata=%h,prdata=%h,pstrb=%b,pready=%b,pslverr=%b",psel,penable,preset,pwrite,paddr,pwdata,prdata,pstrb,pready,pslverr);
      pwrite = 0;
      paddr=32'h00000010;
        #20;
        
        // Monitor signals for waveform
      
      $display($time,"psel=%b,penable=%b,preset=%b,pwrite=%b,paddr=%h,pwdata=%h,prdata=%h,pstrb=%b,pready=%b,pslverr=%b",psel,penable,preset,pwrite,paddr,pwdata,prdata,pstrb,pready,pslverr);
        // End simulation
      #40
      pwrite=0;
      psel=4'b0001;
      paddr=32'h00000040;
      $display($time,"psel=%b,penable=%b,preset=%b,pwrite=%b,paddr=%h,pwdata=%h,prdata=%h,pstrb=%b,pready=%b,pslverr=%b",psel,penable,preset,pwrite,paddr,pwdata,prdata,pstrb,pready,pslverr);
      
        #100;
        $stop;
    end
    
endmodule



*/

`timescale 1ns/1ps

module apb_master_tb;

  // Inputs
  reg pclk;
  reg penable;
  reg preset;
  reg [31:0] paddr;
  reg pwrite;
  reg [2:0] pprot;
  reg [31:0] pwdata;
  reg [3:0] pstrb;
  reg [3:0] psel;

  // Outputs
  wire [31:0] prdata;
  wire pslverr;
  wire pready;

  // Instantiate the APB Master
  apb_master uut (
    .pclk(pclk),
    .penable(penable),
    .preset(preset),
    .paddr(paddr),
    .pwrite(pwrite),
    .pprot(pprot),
    .pwdata(pwdata),
    .pstrb(pstrb),
    .prdata(prdata),
    .pslverr(pslverr),
    .pready(pready),
    .psel(psel)
  );

  // Clock generation
  initial begin
    pclk = 0;
    forever #5 pclk = ~pclk; // 10ns clock period
  end

  // Testbench logic
  initial begin
    // Initialize inputs
    preset = 0;
    penable = 0;
    paddr = 32'h00000000;
    pwrite = 0;
    pprot = 3'b000;
    pwdata = 32'h00000000;
    pstrb = 4'b0000;
    psel = 4'b0000;

    // Apply reset
    #10;
    preset = 1;
    #10;

    // Test Case 1: Write to Slave 0
    psel = 4'b0001; // Select Slave 0
    paddr = 32'h00000004; // Address 4
    pwrite = 1; // Write operation
    pwdata = 32'hDEADBEEF; // Data to write
    pstrb = 4'b1111; // Write all 4 bytes
    #10;
    penable = 1; // Enable the transfer
    #20;
    penable = 0;
    psel = 4'b0000;

    // Test Case 2: Read from Slave 0
    #10;
    psel = 4'b0001; // Select Slave 0
    paddr = 32'h00000004; // Address 4
    pwrite = 0; // Read operation
    #10;
    penable = 1; // Enable the transfer
    #20;
    penable = 0;
    psel = 4'b0000;

    // Test Case 3: Write to Slave 1
    #10;
    psel = 4'b0010; // Select Slave 1
    paddr = 32'h00000008; // Address 8
    pwrite = 1; // Write operation
    pwdata = 32'hCAFEBABE; // Data to write
    pstrb = 4'b1111; // Write all 4 bytes
    #10;
    penable = 1; // Enable the transfer
    #20;
    penable = 0;
    psel = 4'b0000;

    // Test Case 4: Read from Slave 1
    #10;
    psel = 4'b0010; // Select Slave 1
    paddr = 32'h00000008; // Address 8
    pwrite = 0; // Read operation
    #10;
    penable = 1; // Enable the transfer
    #20;
    penable = 0;
    psel = 4'b0000;

    // Test Case 5: Write to Slave 2 with partial strobe
    #10;
    psel = 4'b0100; // Select Slave 2
    paddr = 32'h0000000C; // Address 12
    pwrite = 1; // Write operation
    pwdata = 32'h12345678; // Data to write
    pstrb = 4'b1010; // Write only bytes 1 and 3
    #10;
    penable = 1; // Enable the transfer
    #20;
    penable = 0;
    psel = 4'b0000;

    // Test Case 6: Read from Slave 2
    #10;
    psel = 4'b0100; // Select Slave 2
    paddr = 32'h0000000C; // Address 12
    pwrite = 0; // Read operation
    #10;
    penable = 1; // Enable the transfer
    #20;
    penable = 0;
    psel = 4'b0000;

    // Test Case 7: Write to Slave 3
    #10;
    psel = 4'b1000; // Select Slave 3
    paddr = 32'h00000010; // Address 16
    pwrite = 1; // Write operation
    pwdata = 32'hABCDEF12; // Data to write
    pstrb = 4'b1111; // Write all 4 bytes
    #10;
    penable = 1; // Enable the transfer
    #20;
    penable = 0;
    psel = 4'b0000;

    // Test Case 8: Read from Slave 3
    #10;
    psel = 4'b1000; // Select Slave 3
    paddr = 32'h00000010; // Address 16
    pwrite = 0; // Read operation
    #10;
    penable = 1; // Enable the transfer
    #20;
    penable = 0;
    psel = 4'b0000;

    // End simulation
    #100;
    $finish;
  end

  // Monitor signals
  initial begin
    $monitor("Time: %0t | PADDR: %h | PWDATA: %h | PRDATA: %h | PREADY: %b | PSEL: %b | PWRITE: %b | PENABLE: %b | pslverr : %b",
             $time, paddr, pwdata, prdata, pready, psel, pwrite, penable,pslverr);
  end

endmodule
