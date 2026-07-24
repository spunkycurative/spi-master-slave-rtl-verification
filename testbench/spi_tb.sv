module tb;

  spi_if vif();
  top dut(vif.clk,vif.rst,vif.newd,vif.din,vif.dout,vif.done);
  
  initial begin
    vif.clk<=0;
  end
  
  always #10 vif.clk=~vif.clk;
  
  environment env;
  spi_assertions asrt(vif);
  
  assign vif.sclk = dut.m1.sclk;
  assign vif.cs   = dut.m1.cs;
  assign vif.mosi = dut.m1.mosi;
  
  initial begin
    env=new(vif);
    env.gen.count=20;
    env.run();
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
  
  
endmodule
