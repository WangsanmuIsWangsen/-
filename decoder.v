`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/25 11:07:23
// Design Name: 
// Module Name: decoder
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


module decoder(code_i, code_o);
    input [3:0] code_i;
    output reg [7:0] code_o;
    
    always @(*) begin
        case(code_i)
            0: code_o = 8'b11000000;
            1: code_o = 8'b11111001;
            2: code_o = 8'b10100100;
            3: code_o = 8'b10110000;
            4: code_o = 8'b10011001;
            5: code_o = 8'b10010010;
            6: code_o = 8'b10000010;
            7: code_o = 8'b11111000;
            8: code_o = 8'b10000000;
            9: code_o = 8'b10011000;
            10:code_o = 8'b10001000;
            11:code_o = 8'b10000011;
            12:code_o = 8'b11000110;
            13:code_o = 8'b10100001;
            14:code_o = 8'b10000110;
            15:code_o = 8'b10001110;
        endcase
    end
        
endmodule
