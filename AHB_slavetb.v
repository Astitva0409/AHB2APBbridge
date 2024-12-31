module AHB_slavetb();
reg Hclk;
  reg Hresetn;
  reg Hwrite;
  reg Hreadyin;
  reg [1:0] Htrans;
  reg [31:0] Haddr;
  reg [31:0] Hwdata;
  reg [31:0] Prdata;
  wire valid;
  wire [31:0] Haddr1;
  wire [31:0] Haddr2;
  wire [31:0] Hwdata1;
  wire [31:0] Hwdata2;
  wire [31:0] Hrdata;
  wire Hwritereg;
  wire [2:0] tempselx;
  wire [1:0] Hresp;
//instatiating the design 
AHB_slave DUT(.Hclk(Hclk),.Hresetn(Hresetn),.Hwrite(Hwrite),.Hreadyin(Hreadyin),.Htrans(Htrans),.Haddr(Haddr),.Hwdata(Hwdata),.Prdata(Prdata),.valid(valid),.Haddr1(Haddr1),.Haddr2(Haddr2),.Hwdata1(Hwdata1),.Hwdata2(Hwdata2),.Hrdata(Hrdata),.Hwritereg(Hwritereg),.tempselx(tempselx),.Hresp(Hresp));
// initiating the clock signal 
always 
begin 
 Hclk=0;
forever #5 Hclk=~Hclk;
end 
//Task initialization block 
task initialize();
begin 
Hresetn=0;
Hwrite=0;
Hreadyin=0;
Htrans=0;
Haddr=0;
Hwdata=0;
Prdata=0;
end 
endtask 
//task to apply reset 
task resetn();
begin 
Hresetn=0;
#10;
Hresetn=1;
#10; 
end
endtask
  // Task to apply stimulus
  task apply_stimulus(input [31:0] address, input [31:0] wdata, input [1:0] trans, input write, input readyin);
    begin
      @(posedge Hclk);
      Haddr = address;
      Hwdata = wdata;
      Htrans = trans;
      Hwrite = write;
      Hreadyin = readyin;
      #10;
    end
  endtask
  task print_output();
    begin
      $display("Time: %0t, Haddr1: %h, Haddr2: %h, Hwdata1: %h, Hwdata2: %h, valid: %b, tempselx: %b, Hresp: %b", 
               $time, Haddr1, Haddr2, Hwdata1, Hwdata2, valid, tempselx, Hresp);
    end
  endtask

  initial begin
    // Initialize the testbench
    initialize();

    // Apply reset
    resetn();

    // Apply test stimulus and check results
    apply_stimulus(32'h8000_0000, 32'h1234_5678, 2'b10, 1, 1);
    #10 print_output();

    apply_stimulus(32'h8400_0000, 32'h8765_4321, 2'b10, 1, 1);
    #10 print_output();

    apply_stimulus(32'h8800_0000, 32'hAABB_CCDD, 2'b10, 1, 0);
    #10 print_output();

    apply_stimulus(32'h8C00_0000, 32'hDDCC_BBAA, 2'b10, 1, 1);
    #10 print_output();

    // Finish the simulation
    $finish;
  end
