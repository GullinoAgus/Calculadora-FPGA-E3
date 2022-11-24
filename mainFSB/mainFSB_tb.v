`timescale 1ns / 1 ns


module mainFSB_tb();

    reg clk = 0;
    reg kbEN = 0;
    wire [15:0]res;
    reg [3:0]pressedkey = 0;
    wire [15:0]ALUNum1;
    wire [15:0]ALUNum2;
    wire [3:0]ALUOp;
    wire ALUclk;
    wire [15:0]Display;
    reg reset = 0;
    parameter equal = 10;
    parameter AC = 11;
    parameter plus = 12;
    parameter minus = 13;
    parameter mult = 14;
    parameter div = 15;
    
    ALU uut(.num1(ALUNum1), .num2(ALUNum2), .op(ALUOp), .res(res), .clk(clk));
    mainFSB tb(.clk(clk), .kbEN(kbEN), .pressedkey(pressedkey), .ALUNum1(ALUNum1), .ALUNum2(ALUNum2), .ALUOp(ALUOp), .ALUres(res), .Display(Display), .reset(reset));

    always #1 clk = ~clk;

    initial
        begin  
            // This system task will print out the signal values everytime they change   
            $dumpfile("mainFSB_tb.vcd");
            $dumpvars(0, mainFSB_tb);
            #5
            pressedkey = 1;
            #5
            kbEN = 1;
            #5
            kbEN = 0;
            #5
            pressedkey = plus;
            #5
            kbEN = 1;
            #5
            kbEN = 0;
            #5
            pressedkey = 1;
            #5
            kbEN = 1;
            #5
            kbEN = 0;
            #5
            pressedkey = equal;
            #5
            kbEN = 1;
            #5
            kbEN = 0;

            #15 //20 seg delay
            #5
            pressedkey = 1;
            #5
            kbEN = 1;
            #5
            kbEN = 0;
            #5
            pressedkey = minus;
            #5
            kbEN = 1;
            #5
            kbEN = 0;
            #5
            pressedkey = 1;
            #5
            kbEN = 1;
            #5
            kbEN = 0;
            #5
            pressedkey = equal;
            #5
            kbEN = 1;
            #5
            kbEN = 0;
            #15
            #5
            pressedkey = 1;
            #5
            kbEN = 1;
            #5
            kbEN = 0;
            #5
            pressedkey = 2;
            #5
            kbEN = 1;
            #5
            kbEN = 0;
            #5
            pressedkey = plus;
            #5
            kbEN = 1;
            #5
            kbEN = 0;
            #5
            pressedkey = 1;
            #5
            kbEN = 1;
            #5
            kbEN = 0;
            #5
            pressedkey = equal;
            #5
            kbEN = 1;
            #5
            kbEN = 0;
            #15
            #5
            pressedkey = 1;
            #5
            kbEN = 1;
            #5
            kbEN = 0;
            #5
            pressedkey = 2;
            #5
            kbEN = 1;
            #5
            kbEN = 0;
            #5
            pressedkey = div;
            #5
            kbEN = 1;
            #5
            kbEN = 0;
            #5
            pressedkey = 2;
            #5
            kbEN = 1;
            #5
            kbEN = 0;
            #5
            pressedkey = equal;
            #5
            kbEN = 1;
            #5
            kbEN = 0;
            #15
            $finish;       // Finish simulation  
        end  
endmodule