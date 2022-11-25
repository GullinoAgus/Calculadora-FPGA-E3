
module mainFSB(
    
    input wire readKey,
    input wire [3:0]pressedkey,
    input wire [15:0]ALUres,
    output reg [15:0]num1,
    output reg [15:0]num2,
    output reg [3:0]operation,
    output reg executecalc,
    output reg [15:0]info2display,
    input wire clk,
    input wire reset
);

    // States of the FSM
    localparam calculate = 2'b00;
    localparam wait4num1 = 2'b01;
    localparam wait4num2 = 2'b10;
    localparam showRes = 2'b11;

    //Possible calculator keys
    localparam equal = 4'd10;
    localparam AC = 4'd11;
    localparam plus = 4'd12;
    localparam minus = 4'd13;
    localparam mult = 4'd14;
    localparam div = 4'd15;

    //Inner variables
    reg [3:0]currKey;
    reg keyreleased = 1;
    reg [1:0]curr_state= wait4num1;
    reg [1:0]nxt_state = wait4num1;


    always @(posedge readKey) begin
        currKey = pressedkey;
    end

    always @(posedge clk) begin
        curr_state <= nxt_state;

        if (readKey) begin          // Control de tecla soltada
            keyreleased = 1'b0;
        end

        //State updater
        case (curr_state)
            wait4num1: info2display = num1; // At initial state it shows this register

            wait4num2: info2display = num2; // Second state showing second operand

            calculate:begin                 // Edge to activate ALU
                executecalc = 1;
                nxt_state = showRes;
            end
            
            showRes: info2display = ALUres; // State showing result from ALU

        endcase
        if ((!readKey) && (!keyreleased)) begin // Key press latch
            
            if(curr_state == wait4num1)begin    // Initial State 
                if (currKey < equal) begin      // Each number pressed gets concatenated into num1 register
                    num1 = {num1[11:0], currKey};
                end

                if (currKey > AC)begin          // Any operator pressed, save operation
                    operation = currKey;
                    nxt_state = wait4num2;
                end

                if (currKey == AC) begin        // Clear button pressed
                    num1 = 0;
                end
            end
            if(curr_state == wait4num2)begin    // Second operand state
                
                if (currKey < equal) begin      // new number gets concatenated
                    num2 = {num2[11:0], currKey};
                end
                
                if (currKey == equal)begin      // If equal is pressed, calculate the result and show it
                    nxt_state = calculate;
                    executecalc = 0;
                end
                
                if (currKey == AC) begin        // clear key pressed
                    num2 = 0;
                end

            end

            if(curr_state == showRes)begin      // State showing the result
                
                if (currKey < equal) begin    // If another number is pressed, go to initial state
                    num1 = {12'd0, currKey};
                    num2 = 0;
                    nxt_state = wait4num1;
                end
                
                if (currKey == AC) begin      // if clear is pressed go to initial state
                    num1 = 0;
                    num2 = 0;
                    nxt_state = wait4num1;
                end

                if (currKey > AC) begin         // Operate over the result
                    num1 = ALUres;
                    num2 = 0;
                    operation = currKey;
                    nxt_state = wait4num2;
                end
            end
            keyreleased = 1'b1;                 // release latch from key
        end

    end

endmodule