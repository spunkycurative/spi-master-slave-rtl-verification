class scoreboard;
  
  // Mailbox to receive expected data from the Driver (DS = Driver Stream)
  mailbox #(bit [11:0]) mbxds;
  
  // Mailbox to receive observed data from the Monitor (MS = Monitor Stream)
  mailbox #(bit [11:0]) mbxms;
  
  // Local variables to hold the data items for comparison
  bit [11:0] ds; // Data from Driver (Expected Input/Output)
  bit [11:0] ms; // Data from Monitor (Actual Output)
  
  // Event to signal the generator to produce the next transaction (flow control)
  event sconext;
  
  // Constructor: Initializes the mailboxes
  function new(mailbox #(bit [11:0]) mbxds, mailbox #(bit [11:0]) mbxms);
    this.mbxds = mbxds;
    this.mbxms = mbxms;
  endfunction
  
  // Main task to run the checking logic
  task run();
    forever begin
      // 1. Wait for and get the EXPECTED input data from the driver
      mbxds.get(ds);
      
      // 2. Wait for and get the ACTUAL output data from the monitor
      
      mbxms.get(ms);
      
      $display("[SCO]: DRV (Expected) = %0d, MON (Actual) = %0d", ds, ms);
      
      // 3. Compare the expected data (ds) with the actual data (ms)
      if(ds == ms) begin
        $display("[SCO]: SUCCESS: Data matched for transfer %0d.", ds);
      end else begin
        
        $error("[SCO]: FAILURE: Data MISMATCHED. Expected %0d, but got %0d.", ds, ms);
      end
        
      $display("---------------------");
      
      // 4. Signal the generator to create the next transaction (Flow Control)
      ->sconext;
    end
  endtask
  
endclass
