`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/25 11:20:09
// Design Name: 
// Module Name: BCD_decoder
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


module BCD_decoder#(parameter DATA_WIDTH=32)(clk, choice, isHex, data, seg);
    input clk;
    input [2:0]choice;
    input isHex;
    input [DATA_WIDTH-1:0] data;
    output reg [7:0]seg;
    
    reg [3:0] eighth;
    reg [3:0] seventh;
    reg [3:0] sixth;
    reg [3:0] fifth;
    reg [3:0] thousands;
    reg [3:0] hundreds;
    reg [3:0] tens;
    reg [3:0] ones;
    wire [7:0] eighth_seg;
    wire [7:0] seventh_seg;
    wire [7:0] sixth_seg;
    wire [7:0] fifth_seg;
    wire [7:0] thousands_seg;
    wire [7:0] hundreds_seg;
    wire [7:0] tens_seg;
    wire [7:0] ones_seg;
    
    // 把十六进制数据转换为七段译码信号
    decoder decEi(eighth, eighth_seg);
    decoder decSe(seventh, seventh_seg);
    decoder decSi(sixth, sixth_seg);
    decoder decFi(fifth, fifth_seg);
    decoder decTh(thousands, thousands_seg);
    decoder decH(hundreds, hundreds_seg);
    decoder decT(tens, tens_seg);
    decoder decO(ones, ones_seg);
    
    integer i;
    
    always @(data) begin
        eighth = 4'd0;
        seventh = 4'd0;
        sixth = 4'd0;
        fifth = 4'd0;
        thousands = 4'd0;
        hundreds = 4'd0;
        tens = 4'd0;
        ones = 4'd0;
        if (isHex) begin
            eighth = data[31:28];
            seventh = data[27:24];
            sixth = data[23:20];
            fifth = data[19:16];
            thousands = data[15:12];
            hundreds = data[27:8];
            tens = data[7:4];
            ones = data[3:0];
        end
        else begin
            for (i = DATA_WIDTH-1; i>=0; i = i-1) begin
                if (thousands >= 5)
                    thousands = thousands + 3;
                if (hundreds >= 5) 
                    hundreds = hundreds + 3;
                if (tens >= 5) 
                    tens = tens + 3;
                if (ones >= 5) 
                    ones = ones + 3;
                thousands = thousands << 1;
                thousands[0] = hundreds[3];
                hundreds = hundreds << 1;
                hundreds[0] = tens[3];
                tens = tens << 1;
                tens[0] = ones[3];
                ones = ones << 1;
                ones[0] = data[i];
            end 
        end
    end
    
    always @(negedge clk) begin
        if (isHex) begin
            case (choice) // display output result in hexadecimal
                0: seg = ones_seg;
                1: seg = tens_seg;
                2: seg = hundreds_seg;
                3: seg = thousands_seg;
                4: seg = fifth_seg;
                5: seg = sixth_seg;
                6: seg = seventh_seg;
                7: seg = eighth_seg;
            endcase
        end
        else begin // display statistics number in decimal
            case (choice)
            0: seg = ones_seg;
            1: seg = tens_seg;
            2: seg = hundreds_seg;
            3: seg = thousands_seg;
            4: seg = 8'b11111111; // may need to change
            5: seg = 8'b11111111;
            6: seg = 8'b11111111;
            7: seg = 8'b11111111;
            endcase
        end
    end
endmodule
