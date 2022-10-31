`timescale 1ns/1ns

module top_tb();

    reg clk = 0;
    reg[15:0] num1 = 0, num2 = 0;
    reg[3:0] op = 0;
    
    wire[15:0] res;

    ALU uut(.num1(num1), .num2(num2), .op(op), .clk(clk), .res(res));

    always 
        begin
            #1
            clk = ~clk;
        end

    initial
        begin  
            // This system task will print out the signal values everytime they change   
            $dumpfile("top_tb.vcd");
            $dumpvars(0, top_tb);

            num1 = 16'b0000000000010100; //14
            num2 = 16'b0000000000000111; //7
            op = 4'b1111; // /
            #20 //20 nseg delay

            num1 = 16'b0000000000010110; //16
            num2 = 16'b0000000000000111; //7
            op = 4'b1111; // /
            #20 //20 nseg delay

            num1 = 16'b0000000000010000; //10
            num2 = 16'b0000000000010000; //10
            op = 4'b1110; //*
            #20 //20 nseg delay

        
            num1 = 16'b0000000000000010; //2
            num2 = 16'b0001000000000000; //1000
            op = 4'b1110; //*
            #20 //20 nseg delay

            num1 = 16'b1001100110011001; //9999
            num2 = 16'b1001100110011001; //9999
            op = 4'b1101; //-
            #20 //20 nseg delay

            num1 = 16'b1001100110011001; //9999
            num2 = 16'b1000100110011001; //8999
            op = 4'b1101; //-
            #20 //20 nseg delay

            // Also called stimulus, we simply assign different values to the variables  
            // after some simulation "delay"
            num1 = 16'b0101000000000000; //5000
            num2 = 16'b0100000000000000; //4000
            op = 4'b1100; //+
            #20 //20 nseg delay

            num1 = 16'b0000000000001000; //8
            num2 = 16'b0000000000000000; //0
            op = 4'b1111; // /
            #20 //20 nseg delay

            $finish;       // Finish simulation  
        end  
endmodule