class environment;
  
  // Component instances
  generator gen;
  driver drv;
  monitor mon;
  scoreboard sco;
  
  // Events for flow control
  event nextgd; 
  event nextgs; 
  
  // Mailboxes for inter-component communication
  mailbox #(transaction) mbxgd; // Generator -> Driver (Transaction objects)
  mailbox #(bit [11:0]) mbxds; // Driver -> Scoreboard (Expected Data Stream)
  mailbox #(bit [11:0]) mbxms; // Monitor -> Scoreboard (Monitored Data Stream)
  
  // Virtual interface handle
  virtual spi_if vif;
  
  // Constructor: Instantiates components and connects mailboxes/events
  function new(virtual spi_if vif);
    mbxgd = new();
    mbxds = new();
    mbxms = new();
    
    // 2. Instantiate components and connect mailboxes
    gen = new(mbxgd);                // gen puts transaction into mbxgd
    drv = new(mbxds, mbxgd);         // drv gets from mbxgd, puts expected data into mbxds
    mon = new(mbxms);                // mon puts observed data into mbxms
    sco = new(mbxds, mbxms);         // sco gets from mbxds and mbxms
    
    this.vif = vif;
    
    // 3. Connect virtual interfaces to driver and monitor
    drv.vif = this.vif;
    mon.vif = this.vif;
    
    // 4. Connect flow control events (crucial: they must share the same event variable)
    gen.sconext = nextgs;
    sco.sconext = nextgs;
    
    // Connect unused drvnext events (for completeness)
    gen.drvnext = nextgd;
    drv.drvnext = nextgd;
  endfunction
  
  // Task to perform pre-test actions (e.g., reset)
  task pre_test();
    $display("--- PRE-TEST: Starting Reset Sequence ---");
    drv.reset();
    $display("--- PRE-TEST: Reset Complete ---");
    // Immediately trigger the first sconext so the generator can create the first transaction
    ->nextgs; 
  endtask
  
  // Task to run all component tasks concurrently
  task test();
    $display("--- TEST: Running Component Tasks ---");
    fork
      gen.run();
      drv.run();
      mon.run();
      sco.run();
    join_any // Use join_any so we can wait for gen.done in post_test
  endtask
  
  // Task to perform post-test actions (e.g., wait for completion and finish simulation)
  task post_test();
    // Wait until the generator signals it is done (it runs 'count' times)
    wait(gen.done.triggered);
    
    $display("--- POST-TEST: Generator finished after %0d transactions. ---", gen.count);
    $finish();
  endtask
  
  // Main task to start the test environment
  task run();
    pre_test();
    test();
    post_test();
  endtask

endclass
