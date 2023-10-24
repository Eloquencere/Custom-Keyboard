`include "Environment.sv"

program test(DUT_interface vintrf);
    initial
    begin
        automatic environment env = new(vintrf);
        env.gen.total_packets = 20;
        env.run;
    end
endprogram