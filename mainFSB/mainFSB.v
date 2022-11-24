
module mainFSB(
    input wire kbEN,
    input wire [3:0]pressedkey,
    input wire [15:0]ALUres,
    input wire clk,
    input wire reset,
    output wire [15:0]ALUNum1,
    output wire [15:0]ALUNum2,
    output wire [3:0]ALUOp,
    output wire [15:0]Display,
    output wire [5:0]state
);

    // States of the FSM
    localparam wait4num1 = 2'b00;
    localparam wait4num2 = 2'b01;
    localparam showRes = 2'b11;

    //Posible calculator operations
    localparam equal = 4'd10;
    localparam AC = 4'd11;
    localparam plus = 4'd12;
    localparam minus = 4'd13;
    localparam mult = 4'd14;
    localparam div = 4'd15;

    //Inner temporal variables
    reg [3:0]operation = 4'b0000; //Current operation
    reg [15:0]num1 = 16'b000000000000;  
    reg [15:0]num2 = 16'b000000000000;
    reg [15:0]res = 16'b000000000000;
    reg [3:0]currKey = 4'b0000; 
    reg [15:0]info2display;
    reg [3:0]counter = 0;
    reg [1:0]curr_state = wait4num1;

    assign Display = info2display;      // 4 BCD digits that go to the display
    assign ALUNum1 = num1;               // number 2 ALU
    assign ALUNum2 = num2;              // number 2 ALU
    assign ALUOp = operation;           // operation 4 ALU

    always @ (posedge kbEN, posedge reset) 
        begin
            if (reset == 1)
                begin
                    num1 = 0;
                    num2 = 0;
                    curr_state = wait4num1;
                end
            else
                begin

                    currKey[3:0] = pressedkey[3:0];

                    if (curr_state == showRes)
                        begin
                            case (currKey)
                                1, 2, 3, 4, 5, 6, 7, 8, 9, 0: 
                                    begin
                                        num1 = {11'b0, currKey};
                                        num2 = 0;
                                        curr_state = wait4num1;
                                    end
                            endcase

                            if(currKey[3:0] < equal)
                                begin
                                    num1 = 0;
                                    num2 = 0;
                                    num2 <= {num2[11:0], currKey[3:0]};
                                    curr_state <= wait4num1;

                                end
                        end
                    else if (curr_state == wait4num2) begin
                            // case (currKey)
                            //     equal: begin
                            //         curr_state = showRes;                        
                            //         end
                            //     AC: begin
                            //         if (!num2) begin
                            //             num2 = 0;
                            //             num1 = 0;
                            //         end
                            //         num2 = 0;
                            //         end
                                    
                            //     1, 2, 3, 4, 5, 6, 7, 8, 9, 0:
                            //         num2 = {num2[11:0], currKey};
                                
                            // endcase
                        if(currKey[3:0] < 4'd10)begin
                            num2 <= {num2[11:0], currKey[3:0]};

                        end
                        else if (currKey[3:0] == 4'd11) begin
                            if (!num2) begin
                                num2 = 0;
                                num1 = 0;
                            end
                            num2 = 0;

                        end
                        else if (currKey[3:0] == 4'd10) begin
                            curr_state <= showRes;
                        end
                        else if (currKey[3:0] >= 4'd12) counter = counter;
                        else counter = counter;
                    end
                    else if (curr_state == wait4num1) begin
                        
                        // case (currKey)
                        //     4'd0, 4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd6, 4'd7, 4'd8, 4'd9: begin
                        //         num1 = {num1[11:0], currKey};
                        //         counter = counter+1;
                        //     end
                        //     4'd12, 4'd13, 4'd14, 4'd15: begin
                        //         operation = currKey;
                        //         curr_state = wait4num2;
                        //     end
                        //     AC: begin
                        //         num1 = 16'd0;
                        //     end
                            
                        //     default: counter = counter+1;
                        // endcase
                        if(currKey[3:0] < 4'd10)begin
                            num1 <= {num1[11:0], currKey[3:0]};
                        end
                        else if (currKey[3:0] == 4'd11) begin
                            num1 <= 16'd0;

                        end
                        else if (currKey[3:0] >= 4'd12) begin
                            operation <= currKey[3:0];
                            curr_state <= wait4num2;

                        end
                        else counter = counter;
                end
            end
        end

    always @(posedge clk)

        case (curr_state)
                wait4num1: info2display = num1;
                wait4num2: info2display = num2;
                showRes: info2display = ALUres;
        endcase
            
        
endmodule