`timescale 1ns / 1 ns


module mainFSB_tb();

    reg clk = 0;
    reg kbEN = 0;
    reg [15:0]res;
    reg [3:0]pressedkey = 0;

    wire [15:0]ALUNum1;
    wire [15:0]ALUNum2;
    wire [3:0]ALUOp;
    wire ALUclk;
    wire [15:0]Display;

    parameter equal = 4'b1010;
    parameter AC = 4'b1011;
    parameter plus = 4'b1100;
    parameter minus = 4'b1101;
    parameter mult = 4'b1110;
    parameter div = 4'b1111;
    // ALU uut(.num1(num1), .num2(num2), .op(op), .res(res), .isValid(isValid));
    
    mainFSB tb(.clk(clk), .kbEN(kbEN), .pressedkey(pressedkey), .ALUNum1(ALUNum1), .ALUNum2(ALUNum2), .ALUOp(ALUOp), .ALUres(res), .Display(Display));

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


            #5 //20 seg delay


            $finish;       // Finish simulation  
        end  
endmodule