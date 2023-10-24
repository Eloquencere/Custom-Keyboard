`timescale 10ns / 1ps

interface DUT_interface(input clk);
    logic [8:0]in_key;
    logic [3:0]out_key;
    
    modport DUT(input in_key, clk, output out_key);
    
    clocking driver_clocking @(posedge clk);
        output in_key;
    endclocking
    
    clocking monitor_clocking @(posedge clk);
        input in_key;
        input out_key;
    endclocking
endinterface : DUT_interface