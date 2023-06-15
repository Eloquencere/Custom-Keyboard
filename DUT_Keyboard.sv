`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.03.2023 20:58:58
// Design Name: 
// Module Name: Keyboard
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


`define TotalColumns 3
`define TotalRows 3
`define TotalKeys `TotalRows * `TotalColumns

module Keyboard(in_key, clk, out_key);
    input clk;
    input [(`TotalKeys - 1):0]in_key;
    output logic [`TotalColumns:0]out_key;
    
    logic [(`TotalRows-1):0]row, asyncRowReg, syncRowReg;
    logic [(`TotalColumns-1):0]column, ColumnReg;
    
    Keypad mat1(in_key, column, row);
    FSM state (clk, row, column, ColumnReg, asyncRowReg);
    Synchroniser sync(asyncRowReg, syncRowReg, clk);
    Decoder dec(syncRowReg, ColumnReg, out_key);
endmodule

module Keypad(in_key, column, row);
    input [(`TotalKeys - 1):0]in_key;
    input [(`TotalColumns-1):0]column;
    output logic [(`TotalRows-1):0]row;
    
    integer RowNum;
    always_comb
        for (RowNum = 0; RowNum < `TotalRows; RowNum = RowNum+1)
            row[RowNum] = | (in_key[(RowNum * `TotalColumns)+: `TotalColumns] & column[(`TotalColumns-1):0]);
endmodule

parameter Sensitive = 2'b00, Shift = 2'b01, Hold = 2'b10;
reg [1:0]State = Sensitive;

module FSM(clk, row, column, ColumnReg, RowReg);
    input clk;
    input [(`TotalRows-1):0]row;
    output reg [(`TotalColumns-1):0]column, ColumnReg;
    output reg [(`TotalRows-1):0]RowReg;
    
    always @ (posedge clk)
        case(State)
            Sensitive:
            begin
                if(row != 0) 
                begin
                    column = 1'b1;
                    State = Shift; // if the key was pressed initiate search
                end
                else 
                begin
                    column = {`TotalColumns{1'b1}};
                    State = Sensitive; // if no key was pressed remain sensitive
                end
            end
            Shift: 
            begin
                if(row != 0)
                    State = Hold; // if the row was found hold the column line active
                else
                begin
                    if(column[(`TotalColumns-1)] == 1)
                    begin
                        column = {`TotalColumns{1'b1}};
                        State = Sensitive; // if the correct row is not found after all shifts return to being sensitive
                    end
                    else 
                    begin
                        column = column << 1;
                        State = Shift; // else keep shifting
                    end
                end
            end
            Hold: 
            begin
                ColumnReg <= column;
                RowReg <= row;
                if(row != 0)
                    State = Hold;  // if the row(key) is active hold the column line active
                else 
                begin
                    column = {`TotalColumns{1'b1}};
                    State = Sensitive; // if the key has been removed return to being sensitive
                end
            end
        endcase
endmodule

module Synchroniser(asyncRowReg, syncRowReg, clk);
    input [(`TotalRows-1):0]asyncRowReg;
    input clk;
    output logic [(`TotalRows-1):0]syncRowReg;
    int count;
    always @(posedge clk)
    begin
        if(count == (`TotalColumns - 1))
            syncRowReg = asyncRowReg;
        else if (State == Sensitive)
            count = 0;
        else
            count++;
    end
endmodule

module Decoder(syncRowReg, ColumnReg, out_key);
    input [(`TotalRows-1):0]syncRowReg;
    input [(`TotalColumns-1):0]ColumnReg;
    output logic [`TotalColumns:0]out_key;
    
    always @(*)
        case({syncRowReg,ColumnReg})
            'b001_001: out_key = 0;
            'b001_010: out_key = 1;
            'b001_100: out_key = 2;
            'b010_001: out_key = 3;
            'b010_010: out_key = 4;
            'b010_100: out_key = 5;
            'b100_001: out_key = 6;
            'b100_010: out_key = 7;
            'b100_100: out_key = 8;
        endcase
endmodule
