`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/10 09:24:35
// Design Name: 
// Module Name: dynamic_display
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


module dynamic_display#(parameter N = 32)(
    input clk,
    input isHex,
    input [N-1:0] data,
    output [7:0] an,
    output [7:0] seg
    );
    reg [2:0]choices;
    initial choices <= 0;

    //display result at the same time
    always @(negedge clk) begin
        if (choices != 3'b111) 
            choices <= choices+1;
        else 
            choices <= 0;
    end
    // 选择显示的数码管
    choice ch(clk, choices, an);
    //显示BCD码
    BCD_decoder bcd(clk, choices, isHex, data, seg);

endmodule
