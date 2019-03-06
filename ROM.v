`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/18 18:25:27
// Design Name: 
// Module Name: IrRAM
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

// 用来保存指令的ROM
// 输入：使能信号en，地址addr 10bits
// 输出：数据Dout 32bits
module ROM(addr, Dout);
    input [9:0] addr;
    output  [31:0] Dout;
    
    integer i;
    reg [31:0] Datas[0:1023]; // 用来保存数据的寄存器
    /////////////////////////////////////////////////////////////////////
    // need to change the way to load the data
    initial begin
        $readmemh("E:/FPGAtest/ins.txt", Datas);
        //$display("The fisrt instruction is %h\n", Datas[0]);
    end
    /////////////////////////////////////////////////////////////////////
    assign Dout = Datas[addr];
endmodule
