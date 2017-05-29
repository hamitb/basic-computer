`timescale 1ns / 1ps
module Computer(
input Reset, 
input Clk
);


wire [2:0] Status; // processor status signal 0:p_reset, 1:fetch, 2:execute, 3:memop

//
//Write your code below
wire [23:0] MemAddr;
wire [31:0] fromMemData;
wire [31:0] toMemData;
wire MemLength;
wire MemRd;
wire MemWr;
wire MemEnable;
wire MemRdy;

//           23          i-31        31                                            i
Processor P(MemAddr, fromMemData, toMemData, MemLength, MemRd, MemWr, MemEnable, MemRdy, Status, Reset, Clk);
//                                                       o                    o
Memory M(MemAddr, MemLength, MemRd, MemWr, MemEnable, MemRdy, toMemData, fromMemData);

endmodule