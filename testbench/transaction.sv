class transaction;
  
  // Random variables that will be driven to the DUT
  rand bit newd;
  rand bit [11:0] din;
  
  // Output variable to capture response from the DUT (or predicted value)
  bit [11:0] dout;
  
  // Copy function for cloning transaction objects, essential for scoreboarding
  function transaction copy();
    
    copy = new(); // Create a new object instance
    
    // Deep copy all members
    copy.newd = this.newd;
    copy.din = this.din;
    copy.dout = this.dout;
    
  endfunction
  
endclass
