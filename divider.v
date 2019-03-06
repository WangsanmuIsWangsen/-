`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/25 18:35:29
// Design Name: 
// Module Name: divider
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


module Divider(
    input clk,
    input [31:0] N,
    output reg clk_N
    );
    reg [31:0] i = 0;
    initial clk_N = 0;
    
    always @(posedge clk) begin
        if(i == N /2 - 1) begin 
            clk_N <= ~clk_N;
            i <= 0;
        end
        else i <= i + 1;
    end
endmodule
