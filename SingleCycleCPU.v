`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/18 23:34:03
// Design Name: 
// Module Name: SingleCycleCPU
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

// 单周期CPU数据通路
// 输入：时钟信号clk，重置信号rst，继续运行信号go，输出信息选择信号sType 2bits，中断信号interupt，读取内存地址memAddr
// 输出：数据ledData 32bits，停机信号halt
module SingleCycleCPU(clk, rst, go, sType, interupt, memAddr, ledData, halt);
    input clk, rst, go;
    input [2:0] sType;
    input interupt; 
    input [9:0] memAddr;
    output [31:0] ledData;
    output halt;
    // PC register
    wire pc_enable;
    wire [31:0] pc_in, pc_out;
    reg nohalt = 1;
    PC_reg m_pc_reg(.clk(clk), .en(pc_enable), .rst(rst), .Din(pc_in), .Dout(pc_out));
    assign pc_enable = nohalt;  // PC使能信号为no halt
    assign halt = !nohalt; // 停机信号
    
     //HI LO Register
    // wire hi_enable;
    // wire [31:0] hi_in,hi_out;
    // assign hi_enable = multu;
    // assign hi_in = result2;
    // PC_reg hi_reg(.clk(clk), .en(hi_enable), .rst(rst), .Din(hi_in), .Dout(hi_out));
    
    // wire lo_enable;
    // wire [31:0] lo_in,lo_out;
    // assign lo_enable = multu;
    // assign lo_in = result;
    // PC_reg lo_reg(.clk(clk), .en(lo_enable), .rst(rst), .Din(lo_in), .Dout(lo_out));
    
    // Instruction ROM
    wire [31:0] ins;
    ROM m_rom(.addr(pc_out[11:2]), .Dout(ins));

    // Controller
    wire [3:0] alu_op;
    wire memToReg, memWrite, alu_src, regWrite, syscall, signedExt, regDst, beq, bne, jr, jmp, jal, shift, lb ,bgtz;
    Controller m_controller(ins[31:26], ins[5:0], alu_op, memToReg, memWrite, alu_src, 
        regWrite, syscall, signedExt, regDst, beq, bne, jr, jmp, jal, shift, lb, bgtz);
   
    
    // Register Files
    wire [4:0] ra1, ra2, rina;
    wire [31:0] regDin, rd1, rd2;
    wire [1:0]choose;
    //wire [31:0] OFRAM;//output_from_RAM
    wire [31:0] lbWord;
    Regfile m_regfile(.clk(clk), .we(regWrite&&nohalt), .ra1(ra1), .ra2(ra2), .rina(rina), .Din(regDin), .rd1(rd1), .rd2(rd2));
    assign ra1 = syscall?5'b00010:ins[25:21]; // 寄存器1的编号
    assign ra2 = syscall?5'b00100:ins[20:16]; // 寄存器2的编号
    // 寄存器的写回
    assign choose=result[1:0];
    assign rina = jal?5'b11111:(regDst?ins[15:11]:ins[20:16]); // 写入寄存器的编号
    //assign OFRAM = memToReg?mem_Dout:(jal?tPc:result);//从RAM出来的数据，已经过JAL选择
    //assign lhalfWord_U = {16'h0000,choose?OFRAM[31:16]:OFRAM[15:0]}  ; //加载半字
    //assign regDin = sltiu?result:(lhu?lhalfWord_U:OFRAM);// 写入寄存器的数据
    assign lbWord[7:0]=choose[1]?(choose[0]?mem_Dout[31:24]:mem_Dout[23:16]):(choose[0]?mem_Dout[15:8]:mem_Dout[7:0]);
    assign lbWord=$signed(lbWord<<24)>>>24;  //符号拓展
    assign regDin = jal?tPc:(memToReg?(lb?lbWord:mem_Dout):result);  // 写入寄存器的数据
    
    // ALU 
    wire [31:0] alu_b;
    wire [4:0] shamt;
    wire [31:0] result, result2;
    wire equ;
    ALU m_alu(.a(rd1), .b(alu_b), .aluop(alu_op), .shamt(shamt), .r1(result), .r2(result2), .equ(equ)); 
    assign alu_b = alu_src?(signedExt?signedImme:unsignedImme):rd2; // 第二个运算因子的来源
    assign shamt = shift? rd1[4:0] : ins[10:6]; // srav need rd1
    
    wire bigger;
    assign bigger=(result==0)?1:0;
    
    // RAM
    wire [3:0] sel;
    wire ld;
    wire [9:0] lmemAddr;
    wire [31:0] mem_Din, mem_Dout;
    RAM m_ram(.clk(clk), .rst(rst), .we(memWrite), .sel(sel), .ld(ld), .addr(lmemAddr), .Din(mem_Din), .Dout(mem_Dout));
    assign ld = interupt?1:memToReg; // interupt for template
    assign lmemAddr = interupt?memAddr:result[11:2];
    assign mem_Din = rd2; // may need to modify when add extended instructions
    assign sel = 4'b1111; // may need to modify when add extended instructions
    
    // Immediate value
    wire [31:0] signedImme = $signed(ins << 16) >>> 16; // 有符号扩展
    wire [31:0] unsignedImme = {16'h0000, ins[15:0]}; // 无符号扩展
    
    // Jump conditions
    wire uncj1 = (jmp&&~jal&&~jr) || jal; // 第一类无条件跳转指令
    wire uncj2 = jr; // 第二类无条件跳转指令
    wire cjS = (bne && ~equ) || (beq && equ)||(bgtz&&bigger&&~equ); // 条件分支成功
    
    // Jump target PC
    wire [31:0] tPc = pc_out + 4; // PC + 4
    wire [31:0] cj1Pc = {tPc[31:28], ins[25:0], 2'b00}; // 第一类无条件跳转指令的目标PC
    wire [31:0] cj2Pc = rd1; // 第二类jr的跳转目标PC
    wire [31:0] cjSPc = tPc + (signedImme << 2); // 条件分支的跳转目标PC
    
    // 下一个时钟上升沿来临时的PC的值
    assign pc_in = uncj1?cj1Pc:(uncj2?cj2Pc:(cjS?cjSPc:tPc));
    
    // 统计周期数
    // 统计无条件分支和有条件分支
    reg [31:0] cycles, cbNum, uncbNum;
    /////////////////////////////////////////////////////////////////////
    // init statistics variables
    // need to change the way to init
    initial begin
        cycles <= 0;
        cbNum <= 0;
        uncbNum <= 0;
    end
    /////////////////////////////////////////////////////////////////////
    always @(posedge clk or posedge rst) begin 
        if (rst) begin
            cycles <= 0;
            cbNum <= 0;
            uncbNum <= 0;
        end
        else begin
            if (nohalt) begin
                cycles <= cycles + 1;
                if (jmp) uncbNum <= uncbNum + 1;
                if (cjS) cbNum <= cbNum + 1;
            end
        end
    end

    // halt信号的产生 挂机信号，按下Go键继续运行
    // 添加中断来 观察内存情况
    // 该中断时非常简单的中断，没有保护PC等现场，也没有中断优先级判定
    // nohalt signal has problem
    /*reg in_int = 0; // 用来保存中断状态
    reg isSys = 0; // 用来检测停机是否由系统调用产生
        always @(posedge clk or posedge rst or posedge go) begin 
            if (rst || go)  begin nohalt <= 1; isSys <= 0; end
            else begin
                if (rd1 != 32'h00000022 && syscall) begin nohalt <= 0; isSys <= 1; end
                else  nohalt <= nohalt?1:0;      
                if (interupt) begin
                    nohalt <= 0;      
                    in_int <= 1;
                end else if (in_int) begin
                    in_int <= 0;
                    if (!isSys) nohalt <= 1;
                end
            end
        end*/
        always @(posedge clk or posedge rst or posedge go) begin 
                if (rst || go) 
                 begin
                 if(rd1==32'h0000000a&&syscall)
                 nohalt<=0;
                 else
                  nohalt <= 1;
                 end
                else begin
                    if (rd1 != 32'h00000022 && syscall) begin nohalt <= 0;  end
                    else  nohalt <= nohalt?1:0;      
                end
            end
        
    // led显示数据
    reg [31:0] reg_ledData, sysOutData;
    assign ledData = reg_ledData; // 把led输出信息绑定到寄存器的输出端口上
    always @(posedge clk or posedge rst) begin
        if (rst) begin
             reg_ledData <= 0;
             sysOutData <= 0;
             
        end
        else begin
            if (rd1 == 32'h00000022 && syscall) sysOutData <= rd2;
            case(sType)
                3'b000: reg_ledData <= sysOutData; // 正常输出信息
                3'b001: reg_ledData <= cycles; // 输出周期数
                3'b010: reg_ledData <= uncbNum; // 输出无条件分支数
                3'b011: reg_ledData <= cbNum; // 输出条件分支成功数
                default: reg_ledData <= mem_Dout; // 输出内存中的数据
            endcase
        end
    end
   

endmodule
