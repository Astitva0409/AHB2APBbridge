module Top_tb();
reg Hclk,Hresetn;
wire Hreadyout,Hwrite,Hreadyin;
wire [31:0] Hrdata,Haddr,Hwdata,Paddr,Pwdata,Paddrout,Pwdataout,Prdata;
wire [1:0] Hresp,Htrans;
wire Penable,Pwrite,Pwriteout,Penableout;
wire [2:0] Pselx,Pselxout;

AHB_Master 
ahb(Hclk,Hresetn,Hreadyout,Hrdata,Haddr,Hwdata,Hwrite,Hreadyin,Htrans);

Bridge_top 
bridge(Hclk,Hresetn,Hwrite,Hreadyin,Hwdata,Haddr,Htrans,Prdata,Penable,Pwrite,Pselx,Paddr,Pwdata,Hreadyout,
Hresp,Hrdata);

APB_Interface 
apb(Pwrite,Pselx,Penable,Paddr,Pwdata,Pwriteout,Pselxout,Penableout,Paddrout,Pwdataout,Prdata);

initial
begin
Hclk=1'b0;
 forever #10 Hclk=~Hclk;
end

task reset();
begin
 @(negedge Hclk)
 Hresetn=1'b0;
 @(negedge Hclk)
 Hresetn=1'b1;
end
endtask
initial 
begin
 reset;
 //ahb.single_write();
//ahb.burst_write();
//ahb.single_read();
ahb.wrap_write();
end 
endmodule 
