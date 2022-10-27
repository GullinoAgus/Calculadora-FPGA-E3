`timescale 1ns/1ns


module top_tb(
    
);
    reg clk;


    always #1 clk = ~clk;

    initial begin  
        // This system task will print out the signal values everytime they change   
        $dumpfile("top_tb.vcd");
        $dumpvars(0, top_tb);

        // Also called stimulus, we simply assign different values to the variables  
        // after some simulation "delay"  
  
        #5 clk = 0;         // Assign clk to 0 at time 5ns  

        #20 $finish;       // Finish simulation at time 85ns  
        end  
endmodule