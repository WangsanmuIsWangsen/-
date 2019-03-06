// RAM用来保存数据
// 输入：时钟信号clk，写使能信号we, 重置信号rst，指令地址Addr 10bits, 数据Din 32bit
// 输出：数据Dout 32bits
module RAM(clk, rst, we, sel, ld, addr, Din, Dout);
    input clk, rst;
    input [9:0] addr;
    input we;
    input [3:0] sel;
    input ld;
    input [31:0] Din;
    output  [31:0] Dout;
    
    integer i; // 用于清零循环
    reg [31:0] Datas[0:1023]; // 用来保存数据的寄存器
   
    always @(posedge clk or posedge rst) begin 
        if (rst) begin
           
        end
        else begin
            if (we) begin
                case(sel)
                4'b0001: Datas[addr][7:0] <= Din[7:0];
                4'b0010: Datas[addr][15:8] <= Din[15:8];
                4'b0100: Datas[addr][23:16] <= Din[23:16];
                4'b1000: Datas[addr][31:24] <= Din[31:24];
                4'b0011: Datas[addr][15:0] <= Din[15:0];
                4'b1100: Datas[addr][31:16] <= Din[31:16];
                4'b1111: Datas[addr] <= Din;
                endcase
            end
        end
    end
    
    assign Dout = ld?Datas[addr]:32'h????????;
endmodule

