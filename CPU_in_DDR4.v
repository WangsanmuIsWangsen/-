`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/19 14:31:37
// Design Name: 
// Module Name: CPU_in_DDR4
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

// CPUд�뵽DDR4�������еĶ���ģ��
// ���룺ʱ���ź�clk�������ź�rst�����������ź�go����Ƶ���ź�hFreq�����Ӳ鿴��ַ��ֵ�ź�addrI�������Ϣѡ���ź�dataSel 3bits
// �����7�������ʹ���ź�an 8bits���߶�����������ź�seg 8bits��ѡ���ź�dataSel��led��ʾ 2bits�� ͣ���ź� halt
module CPU_in_DDR4(clk, rst, go, hFreq,sFreq,tFreq,lFreq, addrI,dataSel, an, seg, led, haltLed);
    input clk, rst, go, hFreq, sFreq, tFreq,lFreq, addrI;
    input [2:0] dataSel;
    output [7:0] an, seg;
    output [2:0] led;
    output haltLed;
    
    // Sel�ź�Ϊ1ʱ��led����
    assign led = dataSel;
   
    wire clk_cpu, clk_dy; // ��Ƶ֮���ʱ���ź�
    ///////////////////////////////////////////////////////
    // for debug
//    reg [31:0] df_display = 2;
//    reg [31:0] df_cpu = 2;
    ///////////////////////////////////////////////////////
    reg [31:0] df_cpu = 25_000_00; // Ĭ�ϵ�Ƶ����40Hz
    reg [31:0] df_display = 250_000; // Ƶ��Ϊ400Hz
    // CPU ��Ƶ
    Divider cpu_divider(.clk(clk), .N(df_cpu), .clk_N(clk_cpu));      
    // ��ʾ��Ƶ
    Divider m_nDivider(.clk(clk), .N(df_display), .clk_N(clk_dy)); 

    // ������CPU
    wire [31:0] ledData;
    reg [9:0] memAddr = 0;
    // ����rst������CPU�����õ���ʼ״̬
    // ��ͣ��״̬�°���go�����������
    SingleCycleCPU mCPU(.clk(clk_cpu), .rst(rst), .go(go), .sType(dataSel), .interupt(dataSel[2]), .memAddr(memAddr), .ledData(ledData), .halt(halt));

    // ��ʾģ��
    wire isHex;
    assign isHex = (dataSel==3'b000 || dataSel[2] == 1'b1)?1:0;
    // ��isHexΪ1ʱ����ʾʮ�����Ƶ�����
    // ��isHexΪ0ʱ����ʾʮ���Ƶ�����
    dynamic_display dydisplay(.clk(clk_dy), .isHex(isHex), .data(ledData), .an(an), .seg(seg));
    assign haltLed = halt; // ͣ���źŰ󶨵�led��
    
    
    always @(posedge clk_cpu) begin
        if (hFreq) df_cpu <= 2;  // the highest frequency is 200MHz
        else if (tFreq) df_cpu <= 4; //100MHz
        else if (lFreq) df_cpu <= 25_000; //4khz
        else if (sFreq) df_cpu <= 25_000_0; //400hz
        else df_cpu <= 25_000_00;  // the lowest frequency is 40Hz
    end
    
    //���������ڴ��ַ������ have problems
    reg key_lock = 0; // ��ֹ������δ���
    always @(posedge clk_dy) begin
        if (!dataSel[2] && memAddr != 0) memAddr <= 0;
        if (!key_lock && addrI) begin
            key_lock <= 1;
            memAddr <= memAddr + 1;
        end
        if (!addrI) key_lock <= 0;
    end
endmodule
