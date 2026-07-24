module spi_assertions(spi_if vif);
  
  property p_reset_assertion;
    @(posedge vif.rst)
    ##1 (vif.cs && !vif.sclk);
endproperty
  
  assert property(p_reset_assertion)
    else
      $error("Reset values incorrect");
    
   property p_cs_active;
     @(posedge vif.sclk)
     disable iff(vif.rst)
     $rose(vif.newd) |=> (!vif.cs);
endproperty
    
    assert property(p_cs_active)
      else
        $error("cs did not go low after newd");
      
        
         property p_mosi_known;
           @(posedge vif.sclk)
            disable iff(vif.rst)
            !vif.cs |-> !$isunknown(vif.mosi);
          endproperty
          
          assert property(p_mosi_known)
            else
              $error("MOSI contains X or Z");
        
        property p_done_high_after_transfer;
          @(posedge vif.sclk)
          disable iff(vif.rst)
          $fell(vif.cs) |-> ##[12:14](vif.done);
          
        endproperty
    
        assert property(p_done_high_after_transfer)
          else
            $error("Done not asserted after transfer");
            
            property p_done_low;
              @(posedge vif.sclk)
              disable iff(vif.rst)
              (!vif.cs) |-> (!vif.done);
              
            endproperty
            
            assert property(p_done_low)
              else
                $error("Done asserted before transfer completed");
              
           property p_done_one_pulse_high;
             @(posedge vif.sclk)
             disable iff(vif.rst)
             $rose(vif.done) |=> (!vif.done);
           endproperty
              
              assert property(p_done_one_pulse_high)
                else
                  $error("Done stayed for more than one clock cycle");
    
endmodule
