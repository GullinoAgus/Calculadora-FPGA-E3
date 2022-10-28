`timescale 1ns / 10 ps

module top_tb();

    reg clk;
    reg[0:15] num1;
    reg[0:15] num2;
    reg[0:1] op;

    wire isValid;
    wire[0:15] res;

    ALU uut(.num1(num1), .num2(num2), .op(op), .res(res), .isValid(isValid));

    always #1 clk = ~clk;

    initial
        begin  
            // This system task will print out the signal values everytime they change   
            $dumpfile("top_tb.vcd");
            $dumpvars(0, top_tb);

            // Also called stimulus, we simply assign different values to the variables  
            // after some simulation "delay"
            num1 = 16'b101;
            num2 = 16'b1;
            op = 0; //Sum
            #20 //20 seg delay


            $finish;       // Finish simulation  
        end  
endmodule