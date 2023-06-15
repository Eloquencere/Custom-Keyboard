`include "environment.sv"

program test(DUT_interface vintrf);
    initial
    begin
        environment env = new(vintrf);
        env.gen.total_packets = 20;
        env.run;
    end
endprogram
