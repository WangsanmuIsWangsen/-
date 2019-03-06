`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/18 20:09:35
// Design Name: 
// Module Name: Regfile
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

// 寄存器堆
// 输入时钟信号clk，写使能信号we，寄存器1的编号ra1 5bits，寄存器2的编号ra2 5bits，写寄存器的编号rina 5bits，写入数据Din 32bits
// 输出寄存器1的数据rd1 32bits，输出寄存器2的数据rd2 32bits
module Regfile(clk, we, ra1, ra2, rina, Din, rd1, rd2);
    input clk, we;
    input [4:0] ra1, ra2, rina;
    input [31:0] Din;
    output [31:0] rd1, rd2;
    
    integer i;
    reg [31:0] state[0:31]; // 寄存器堆的存储部件
    initial begin
        for(i = 0; i < 32; i = i+1) begin
            state[i] <= 0;
        end
    end
    
    always @(posedge clk) begin
        if (we && rina != 0)
            state[rina] = Din;
    end
    assign rd1 = state[ra1];
    assign rd2 = state[ra2];
endmodule
