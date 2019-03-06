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

// CPU写入到DDR4开发板中的顶层模块
// 输入：时钟信号clk，重置信号rst，继续运行信号go。高频率信号hFreq，增加查看地址的值信号addrI，输出信息选择信号dataSel 3bits
// 输出：7段数码管使能信号an 8bits，七段数码管数据信号seg 8bits，选择信号dataSel的led显示 2bits， 停机信号 halt
module CPU_in_DDR4(clk, rst, go, hFreq,sFreq,tFreq,lFreq, addrI,dataSel, an, seg, led, haltLed);
    input clk, rst, go, hFreq, sFreq, tFreq,lFreq, addrI;
    input [2:0] dataSel;
    output [7:0] an, seg;
    output [2:0] led;
    output haltLed;
    
    // Sel信号为1时，led亮起
    assign led = dataSel;
   
    wire clk_cpu, clk_dy; // 分频之后的时钟信号
    ///////////////////////////////////////////////////////
    // for debug
//    reg [31:0] df_display = 2;
//    reg [31:0] df_cpu = 2;
    ///////////////////////////////////////////////////////
    reg [31:0] df_cpu = 25_000_00; // 默认的频率是40Hz
    reg [31:0] df_display = 250_000; // 频率为400Hz
    // CPU 分频
    Divider cpu_divider(.clk(clk), .N(df_cpu), .clk_N(clk_cpu));      
    // 显示分频
    Divider m_nDivider(.clk(clk), .N(df_display), .clk_N(clk_dy)); 

    // 单周期CPU
    wire [31:0] ledData;
    reg [9:0] memAddr = 0;
    // 按下rst键整个CPU都重置到初始状态
    // 在停机状态下按下go将会继续运行
    SingleCycleCPU mCPU(.clk(clk_cpu), .rst(rst), .go(go), .sType(dataSel), .interupt(dataSel[2]), .memAddr(memAddr), .ledData(ledData), .halt(halt));

    // 显示模块
    wire isHex;
    assign isHex = (dataSel==3'b000 || dataSel[2] == 1'b1)?1:0;
    // 当isHex为1时，显示十六进制的数据
    // 当isHex为0时，显示十进制的数据
    dynamic_display dydisplay(.clk(clk_dy), .isHex(isHex), .data(ledData), .an(an), .seg(seg));
    assign haltLed = halt; // 停机信号绑定到led上
    
    
    always @(posedge clk_cpu) begin
        if (hFreq) df_cpu <= 2;  // the highest frequency is 200MHz
        else if (tFreq) df_cpu <= 4; //100MHz
        else if (lFreq) df_cpu <= 25_000; //4khz
        else if (sFreq) df_cpu <= 25_000_0; //400hz
        else df_cpu <= 25_000_00;  // the lowest frequency is 40Hz
    end
    
    //按键进行内存地址的增加 have problems
    reg key_lock = 0; // 防止按键多次触发
    always @(posedge clk_dy) begin
        if (!dataSel[2] && memAddr != 0) memAddr <= 0;
        if (!key_lock && addrI) begin
            key_lock <= 1;
            memAddr <= memAddr + 1;
        end
        if (!addrI) key_lock <= 0;
    end
endmodule
