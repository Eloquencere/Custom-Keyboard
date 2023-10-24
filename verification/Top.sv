`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Sriranga
// 
// Create Date: 08.06.2023 14:28:50
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "Test.sv"

module TestBench_Top;
    bit clk = 1;
    
    initial forever #20 clk = ~clk;
    
    DUT_interface intrf(clk);
    test tst(intrf);
    Keyboard DUT(.in_key(intrf.in_key), .clk(intrf.clk), .out_key(intrf.out_key));
endmodule