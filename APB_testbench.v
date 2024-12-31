module APB_testbench();

// Declare testbench signals
reg Hclk;
reg Hresetn;
reg valid;
reg Hwrite;
reg Hwritereg;
reg [31:0] Hwdata;
reg [31:0] Haddr;
reg [31:0] Haddr1;
reg [31:0] Haddr2;
reg [31:0] Hwdata1;
reg [31:0] Hwdata2;
reg [31:0] Prdata;
reg [2:0] tempselx;
wire Pwrite;
wire Penable;
wire Hreadyout;
wire [2:0] Pselx;
wire [31:0] Paddr;
wire [31:0] Pwdata;

// Instantiate the APB controller
APB_controller uut (
    .Hclk(Hclk),
    .Hresetn(Hresetn),
    .valid(valid),
    .Haddr1(Haddr1),
    .Haddr2(Haddr2),
    .Hwdata1(Hwdata1),
    .Hwdata2(Hwdata2),
    .Prdata(Prdata),
    .Hwrite(Hwrite),
    .Haddr(Haddr),
    .Hwdata(Hwdata),
    .Hwritereg(Hwritereg),
    .tempselx(tempselx),
    .Pwrite(Pwrite),
    .Penable(Penable),
    .Pselx(Pselx),
    .Paddr(Paddr),
    .Pwdata(Pwdata),
    .Hreadyout(Hreadyout)
);

// Clock generation
initial
begin
Hclk=0;
forever #10 Hclk = ~Hclk;
end 

// Task to apply reset
task apply_reset;
begin
 @(negedge Hclk);
    Hresetn = 0;
   @(negedge Hclk);
    #10 Hresetn = 1;
end
endtask

initial 
begin 
apply_reset;
Hwrite=1'b1;
valid=1'b1;
Haddr=32'h8100_0000;
Haddr1=32'h8200_0000;
Haddr2=32'h8300_0000;
Hwdata='d32;
Hwdata1='d45;
Hwdata2='d52;
Prdata='d543;
Hwritereg=1'b1;
tempselx=3'b001;
#100
Hwrite=1'b0;
valid=1'b0;
#200 $finish; 
end


// Monitor changes in signals
initial begin
    $monitor("Time: %0t | PRESENT_STATE: %b | NEXT_STATE: %b | Paddr: %h | Pwdata: %h | Pwrite: %b | Pselx: %b | Penable: %b | Hreadyout: %b | valid: %b | Hwrite: %b", 
             $time, uut.PRESENT_STATE, uut.NEXT_STATE, Paddr, Pwdata, Pwrite, Pselx, Penable, Hreadyout, valid, Hwrite);
end 
endmodule
