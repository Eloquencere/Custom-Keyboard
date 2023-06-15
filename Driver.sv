`define driver_clocking driver_interface.driver_clocking

class driver;
    packet pkt_from_generator;
    mailbox driver_mailbox;
    
    virtual DUT_interface driver_interface;
    
    function new(mailbox glue_mailbox, virtual DUT_interface glue_interface);
        driver_mailbox = glue_mailbox;
        driver_interface = glue_interface;
    endfunction
    
    packet pkt_to_change;
    int signals_driven;
    
    task drive;
        forever
        begin
            driver_mailbox.get(pkt_from_generator);
            
            @(`driver_clocking);
            `driver_clocking.in_key <= pkt_from_generator.in_key; // write driver
            
            $display("Driver passed");
            $display("%t: in_key = %b, signals driven %0d", $time, pkt_from_generator.in_key, signals_driven);
            
            if(pkt_from_generator.key_change)
                change_key(pkt_to_change);
            else
                repeat(8) @(`driver_clocking); // 6 cycles(to calculate) + 2 cycles(to reflect)
            
            signals_driven++;
        end
    endtask
    
    task change_key(ref packet pkt_to_change);
        pkt_to_change = new();
        pkt_to_change.randomize() with {if(condition == 0) rand_key <= 12;}; // 9,10,11,12 are to increase the chances of getting 0 in in_key
        
        @(`driver_clocking);
        `driver_clocking.in_key <= pkt_to_change.in_key;
        
        if(pkt_to_change.in_key == 0)
            $display("Driver released the key");
        else
        begin
            $display("Driver changed the key");
            $display("%t: in_key = %b", $time, pkt_to_change.in_key);
        end
        
        repeat(7) @(`driver_clocking);
    endtask
endclass
