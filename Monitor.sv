`define monitor_clocking monitor_interface.monitor_clocking

class monitor;
    packet pkt_to_scoreboard;
    mailbox monitor_mailbox;
    
    virtual DUT_interface monitor_interface;
    
    function new(mailbox glue_mailbox, virtual DUT_interface glue_interface);
        monitor_mailbox = glue_mailbox;
        monitor_interface = glue_interface;
    endfunction
    
    int signals_received;
    task watch;
        forever
        begin
            pkt_to_scoreboard = new;
            
            repeat(9) @(`monitor_clocking); // 1 cycle(Driver time) + 8 cycles(DUT delay)
            pkt_to_scoreboard.in_key = `monitor_clocking.in_key; // write monitor
            pkt_to_scoreboard.out_key = `monitor_clocking.out_key; // read monitor
            monitor_mailbox.put(pkt_to_scoreboard);
            
            $display("Monitor Received");
            $display("%t: in_key = %b, out_key = %d, signals received %0d", $time, pkt_to_scoreboard.in_key, pkt_to_scoreboard.out_key, signals_received);
            
            signals_received++;
        end
    endtask
endclass
