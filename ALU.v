`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/18 20:58:51
// Design Name: 
// Module Name: ALU
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

// ���㵥Ԫ
// ���룺������a 32bits��������b 32bits���������aluc 4bits����λ�� shamt 5bits
// ��������r1 32bits, ���r2 32bits������ź�equ
module ALU(
        input [31:0] a,        //OP1
        input [31:0] b,        //OP2
        input [3:0] aluop,    //controller
        input [4:0] shamt, // shift number
        output [31:0] r1,    //result1
        output [31:0] r2,   // result 2
        output reg equ);
        
        parameter Sll = 4'b0000;
        parameter Sra = 4'b0001;
        parameter Srl = 4'b0010;
        parameter Mulu = 4'b0011;
        parameter Divu = 4'b0100;
        parameter Add = 4'b0101;
        parameter Sub = 4'b0110;
        parameter And = 4'b0111;
        parameter Or = 4'b1000;
        parameter Xor = 4'b1001;
        parameter Nor = 4'b1010;
        parameter Slt = 4'b1011;
        parameter Sltu = 4'b1100;
        
        reg [31:0]result, result2; // ��¼���
        wire signed [31:0] x = a, y = b;
        always @(*) begin
            equ = x==y?1:0;
            case(aluop) 
                Sll: result = b << shamt;
                Sra: result = y >>> shamt;
                Srl:  result = b >> shamt;
                Mulu: {result2, result} = x * y;
                Divu: begin result = x / y; result2 = x % y; end
                Add: result = a + b;
                Sub: result = a - b;
                And: result = a & b;
                Or: result = a | b;
                Xor: result = a ^ b;
                Nor: result = ~(a | b);
                Slt: result = x<y?1:0;
                Sltu: result = a<b?1:0;
            endcase
        end
        assign r1 = result;
        assign r2 = result2;
endmodule
