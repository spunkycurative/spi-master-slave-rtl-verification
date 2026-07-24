class driver;
  
  virtual spi_if vif;
  transaction tr;
  mailbox #(transaction) mbx;
  mailbox #(bit [11:0]) mbxds;
  event drvnext;
  
  bit [11:0] din;
  
  function new (mailbox #(bit [11:0]) mbxds, mailbox #(transaction) mbx);
    this.mbx=mbx;
    this.mbxds=mbxds;
  endfunction
  
  task reset();
    vif.rst<=1'b1;
    vif.newd<=1'b0;
    vif.din<=1'b0; 
    repeat(10)@(posedge vif.clk);
    vif.rst<=1'b0;
    repeat(5) @(posedge vif.clk);
    
  endtask
  
  task run();
    
    forever begin
      mbx.get(tr);
      @(negedge vif.sclk);
      vif.newd<=1'b1;
      vif.din<=tr.din;
      
      mbxds.put(tr.din);
      
      @(posedge vif.sclk);
      
      @(negedge vif.sclk);
      vif.newd<=1'b0;
      
      @(posedge vif.done);
      $display("[DRV]:data sent to dac=%0d",tr.din);
      //@(posedge vif.sclk);
      
    end
     endtask
endclass
