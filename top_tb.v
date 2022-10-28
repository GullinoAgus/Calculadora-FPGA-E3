`timescale 1ns / 10 ps

module top_tb();

    reg clk;
    reg num1[0:15];
    reg num2[0:15];
    reg op;

    wire isValid;
    wire res[0:15];

    ALU uut(.num1(num1), .num2(num2), .op(op), .res(res), .isValid(isValid));

    always #1 clk = ~clk;

    initial 
        begin  
            // This system task will print out the signal values everytime they change   
            $dumpfile("top_tb.vcd");
            $dumpvars(0, top_tb);

            // Also called stimulus, we simply assign different values to the variables  
            // after some simulation "delay"
            num1 = 16'b1;
            num2 = 16'b1;
            op = 0; //Sum
            #20 //20 seg delay

            #5 clk = 0;         // Assign clk to 0 at time 5ns  

            #20 
            $finish;       // Finish simulation  
        end  
endmodule