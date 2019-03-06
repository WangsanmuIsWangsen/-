`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/25 11:12:09
// Design Name: 
// Module Name: choice
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


module choice(clk, num, choice);
    input clk;
    input [2:0] num;
    output reg [7:0] choice;
    
    always @(negedge clk) begin
        case(num)
            0: choice = 8'b11111110;
            1: choice = 8'b11111101;
            2: choice = 8'b11111011;
            3: choice = 8'b11110111;
            4: choice = 8'b11101111;
            5: choice = 8'b11011111;
            6: choice = 8'b10111111;
            7: choice = 8'b01111111;
        endcase
    end
endmodule                           
