class generator;
  
  // Local transaction object used for randomization
  transaction tr;
  
  // Mailbox to communicate randomized transactions to the driver
  mailbox #(transaction) mbx;
  
  // Event to signal the environment that the generation task is complete
  event done;
  
  // Variable to control how many transactions to generate
  int count = 0;
  
  // Event: Signal driver to proceed (though not used in this specific run task, 
  // it's good practice for advanced sequencing).
  event drvnext; 
  
  // Event: Block generation until the scoreboard has processed the last transaction.
  // This is a form of flow control to prevent the mailbox from overflowing
  // or generating faster than the downstream components can handle.
  event sconext;
  
  // Constructor: Initializes the mailbox and the transaction object
  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
    tr = new();
  endfunction
  
  // Main task to run the generation
  task run();
    repeat(count) begin
      // 1. Randomize the transaction data
      assert(tr.randomize()) else
        $error("randomization failed");
        
      // 2. Put a COPY of the randomized transaction into the mailbox
      // The .copy() is crucial: it prevents the driver/scoreboard from modifying the 
      // same object that the generator is about to randomize again in the next loop iteration.
      mbx.put(tr.copy());
      
      $display("[GEN]: Generating new transaction. din=%0d", tr.din);
      
      // 3. Wait for the scoreboard to signal that it is ready for the next transaction
      // This is the flow control mechanism.
      @(sconext);
    end
    
    // Signal to the environment that the test is finished
    ->done;
  endtask
  
endclass
