
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

    assign Display = info2display;
    assign ALUNum1 = num1;
    assign ALUNum2 = num2;
    assign ALUOp = operation;
    assign state = counter;
    parameter wait4num1 = 3'b000;
    parameter wait4num2 = 3'b001;
    parameter wait4equal = 3'b010;
    parameter showRes = 3'b011;

    parameter equal = 4'b0101;
    parameter AC = 4'b1101;
    parameter plus = 4'b0011;
    parameter minus = 4'b1011;
    parameter mult = 4'b0111;
    parameter div = 4'b1111;

    always @(posedge kbEN) begin
        if (reset == 0) begin

            currKey = pressedkey;
            case (curr_state)
                showRes: begin
                    case (currKey)
                        4'b1000, 4'b0100, 4'b1100, 4'b0010, 4'b1010, 4'b0110, 4'b1110, 4'b0001, 4'b1001, 4'b0000: begin
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
                            
                        4'b1000, 4'b0100, 4'b1100, 4'b0010, 4'b1010, 4'b0110, 4'b1110, 4'b0001, 4'b1001, 4'b0000:
                            num2 <= {num2, currKey};
                        
                    endcase
                    
                end
                wait4num1:begin
                    
                    case (currKey)
                        plus, minus, div, mult: begin
                            operation <= currKey;
                            curr_state <= wait4num2;
                            
                        end
                        AC:
                            num1 <= 0;
                        4'b1000, 4'b0100, 4'b1100, 4'b0010, 4'b1010, 4'b0110, 4'b1110, 4'b0001, 4'b1001, 4'b0000: begin
                            counter = counter + 1;
                            num1 <= {currKey, num1};
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