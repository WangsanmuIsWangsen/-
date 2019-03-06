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

// �Ĵ�����
// ����ʱ���ź�clk��дʹ���ź�we���Ĵ���1�ı��ra1 5bits���Ĵ���2�ı��ra2 5bits��д�Ĵ����ı��rina 5bits��д������Din 32bits
// ����Ĵ���1������rd1 32bits������Ĵ���2������rd2 32bits
module Regfile(clk, we, ra1, ra2, rina, Din, rd1, rd2);
    input clk, we;
    input [4:0] ra1, ra2, rina;
    input [31:0] Din;
    output [31:0] rd1, rd2;
    
    integer i;
    reg [31:0] state[0:31]; // �Ĵ����ѵĴ洢����
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
