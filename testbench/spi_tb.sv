// Testbench Module for SPI Master/Slave verification
`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "environment.sv"
module tb;

  // 1. Interface Instantiation
  spi_if vif();

  // 2. Design Under Test (DUT) Instantiation
  // Assuming 'top' is the top-level module of your RTL design
  top dut(
    .clk(vif.clk),
    .rst(vif.rst),
    .newd(vif.newd),
    .din(vif.din),
    .dout(vif.dout),
    .done(vif.done)
  );

  // 3. Clock Generation
  initial begin
    vif.clk = 0;
  end

  // Generate a clock signal with a 20ns period (10ns high, 10ns low)
  always #10 vif.clk = ~vif.clk;

  // 4. Test Environment Instantiation and Execution
  environment env;

  // Connect the SCLK signal from the DUT (master side) back to the interface
  // Assuming 'm1' is the instance name of the master module inside 'top'
  assign vif.sclk = dut.m1.sclk;

  initial begin
    // Instantiate the environment, passing the interface handle
    env = new(vif);
    
    // Set up the desired number of transactions (e.g., 5 SPI transfers)
    env.gen.count = 5;
    
    // Start the test sequence
    env.run();
  end

  // 5. Waveform Dumping (for viewing simulation results)
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
  
endmodule
