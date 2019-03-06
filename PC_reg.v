`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/18 17:13:15
// Design Name: 
// Module Name: PC_reg
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
 // PC计数器，用来保存PC的值
// 输入：时钟信号clk，使能信号en，重置信号rst，数据Din 32bits，
// 输出：数据Dout 32bits
module PC_reg(clk, en, rst, Din, Dout);
    input clk, en, rst;
    input [31:0] Din;
    output reg [31:0] Dout;

    initial Dout = 0;
    
    always @(posedge clk or posedge rst) begin // 时钟上升沿触发，异步清零
        if (rst) Dout <= 32'h00000000;
        else begin 
            if (en) Dout <= Din;
        end
    end
endmodule
