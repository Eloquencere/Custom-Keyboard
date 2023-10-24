class scoreboard;
    packet pkt_from_monitor;
    mailbox scoreboard_mailbox;
    
    function new(mailbox glue_mailbox);
        scoreboard_mailbox = glue_mailbox;
    endfunction
    
    int prev_out_key;
    int packets_evaluated, packets_mismatched;
    task evaluate;
        forever
        begin
            scoreboard_mailbox.get(pkt_from_monitor);
            
            $display("Scoreboard Received packet no. %0d", packets_evaluated);
            
            if( (1<<(pkt_from_monitor.out_key)) == pkt_from_monitor.in_key)
                $display("DUT responded as expected");
            else if((pkt_from_monitor.in_key == 0) && (pkt_from_monitor.out_key === prev_out_key))
                $display("No key is pressed");
            else
            begin
                $display("DUT failed this test");
                packets_mismatched++;
            end
            
            prev_out_key = pkt_from_monitor.out_key;
            
            packets_evaluated++;
        end
    endtask
endclass