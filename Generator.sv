class generator;
    rand packet master_pkt = new;
    packet pkt_to_driver;
    mailbox generator_mailbox;
    
    function new(mailbox glue_mailbox);
        generator_mailbox = glue_mailbox;
    endfunction
    
    int total_packets, packet_count;
    event generation_ended;
    
    task dispatch;
        repeat(total_packets+1)
        begin
            if(packet_count) // if packet_count == 0, all values are 0(reset condition)
                master_pkt.randomize();
            pkt_to_driver = new master_pkt;
            
            generator_mailbox.put(pkt_to_driver);
            
            if(pkt_to_driver.condition)
                $display("Generator created an invalid packet");
            else
                $display("Generator created a valid packet");
            $display("%t: in_key = %b, packet no. %0d", $time, pkt_to_driver.in_key, packet_count);

            packet_count++;
        end
        -> generation_ended;
    endtask
endclass
