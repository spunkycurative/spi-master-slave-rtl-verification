class monitor;
  
  // Local transaction object (to temporarily store observed output data)
  transaction tr;
  
  // Mailbox to send the observed data (dout) to the scoreboard
  mailbox #(bit [11:0]) mbx;
  
  // Virtual interface handle to connect to the DUT's pins for sampling
  virtual spi_if vif;
  
  // Constructor: Initializes the mailbox and the transaction object
  function new(mailbox #(bit[11:0]) mbx);
    this.mbx = mbx;
    tr = new(); // Initialize the transaction object
  endfunction
  
  // Main task to sample and send observed data
  task run();
    forever begin
      // 1. Synchronize to the start of the transfer by waiting for an SCLK edge
      // This ensures the monitor is looking at the bus during the activity.
      @(posedge vif.sclk); 
      
      // 2. Wait for the DUT's 'done' signal, indicating the data is ready on dout
      @(posedge vif.done);
      
      // 3. Sample the output data from the interface
      tr.dout = vif.dout;
      
      // 4. Wait for one more SCLK edge before completing the monitoring cycle.
      @(posedge vif.sclk);
      
      // 5. Display the sampled data
      $display("[MON]: observed data from DUT = %0d", tr.dout);
      
      // 6. Send the observed output value to the scoreboard for comparison
      mbx.put(tr.dout);
    end
  endtask
  
endclass
