
module mainFSB(
    
    input wire kbEN,
    input wire [3:0]pressedkey,
    input wire [15:0]ALUres,
    output wire [15:0]ALUNum1,
    output wire [15:0]ALUNum2,
    output wire [3:0]ALUOp,
    output wire [15:0]Display,
    input wire clk,
    input wire reset,
    output wire [5:0]state

);
    reg [3:0]operation = 4'b0000;
    reg [15:0]num1 = 16'b000000000000;
    reg [15:0]num2 = 16'b000000000000;
    reg [15:0]res = 16'b000000000000;
    reg [3:0]currKey = 4'b0000;
    reg [15:0]info2display;
    reg [3:0]counter = 0;
    reg [2:0]curr_state = wait4num1;

    assign Display = info2display;      // 4 BCD digits that go to the display
    assign ALUNum1 = num1;               // number 2 ALU
    assign ALUNum2 = num2;              // number 2 ALU
    assign ALUOp = operation;           // operation 4 ALU
    assign state = currKey;             // Testing

    // States of the FSM
    parameter wait4num1 = 3'b000;
    parameter wait4num2 = 3'b001;
    parameter showRes = 3'b010;

    parameter equal = 10;
    parameter AC = 11;
    parameter plus = 12;
    parameter minus = 13;
    parameter mult = 14;
    parameter div = 15;

    always @(posedge kbEN) begin
        if (reset == 0) begin

            currKey = pressedkey;
            case (curr_state)
                showRes: begin
                    case (currKey)
                        1, 2, 3, 4, 5, 6, 7, 8, 9, 0: begin
                            num1 = 0;
                            num2 = 0;
                            num1 <= {num1, currKey};
                            curr_state <= wait4num1;
                        end
                    endcase
                end
                wait4num2: begin
                    case (currKey)
                        equal: begin
                            curr_state <= showRes;                        
                            end
                        AC: begin
                            if (!num2) begin
                                num2 = 0;
                                num1 = 0;
                            end
                            num2 = 0;
                            end
                            
                        1, 2, 3, 4, 5, 6, 7, 8, 9, 0:
                            num2 <= {num2, currKey};
                        
                    endcase
                end
                wait4num1:begin
                    
                    case (currKey)
                        plus, minus, mult, div: begin
                            operation <= currKey;
                            curr_state <= wait4num2;
                        end
                        AC: begin
                            num1 <= 0;
                        end
                        1, 2, 3, 4, 5, 6, 7, 8, 9, 0: begin
                            num1 <= {num1, currKey};
                        end
                    endcase
                end
            endcase
        end
    end

    always @(posedge clk, posedge reset) begin
        if (reset == 1)begin
            num1 = 0;
            num2 = 0;
            curr_state = wait4num1;
        end
        else begin
            case (curr_state)
                    wait4num1:
                        info2display = num1;
                    wait4num2:
                        info2display = num2;
                    showRes:
                        info2display = ALUres;
            endcase
        end
    end
endmodule