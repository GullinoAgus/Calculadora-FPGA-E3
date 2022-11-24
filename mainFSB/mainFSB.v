
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

    localparam equal = 4'd10;
    localparam AC = 4'd11;
    localparam plus = 4'd12;
    localparam minus = 4'd13;
    localparam mult = 4'd14;
    localparam div = 4'd15;

    reg [3:0]currKey;
    reg keyreleased = 1;

    reg [1:0]curr_state= wait4num1;
    reg [1:0]nxt_state = wait4num1;


    always @(posedge readKey) begin

        currKey = pressedkey;

    end

    always @(posedge clk) begin

        curr_state <= nxt_state;
        if (readKey) begin
            keyreleased = 1'b0;
        end
        case (curr_state)
            wait4num1: info2display = num1;
            wait4num2: info2display = num2;
            calculate:begin 
                executecalc = 1;
                nxt_state = showRes;
            end
            showRes: info2display = ALUres;

        endcase
        if ((!readKey) && (!keyreleased)) begin
            if(curr_state == wait4num1)begin
                if (currKey < 4'b1010) begin
                    
                    num1 = {num1[11:0], currKey};
                end
                if (currKey > 4'b1011)begin
                    operation = currKey;
                    nxt_state = wait4num2;
                end
                if (currKey == 4'b1011) begin
                    num1 = 0;
                end
            end
            if(curr_state == wait4num2)begin
                if (currKey < 4'b1010) begin
                    
                    num2 = {num2[11:0], currKey};
                end
                if (currKey == 4'b1010)begin
                    nxt_state = calculate;
                    executecalc = 0;
                end
                if (currKey == 4'b1011) begin
                    num2 = 0;
                end
            end
            if(curr_state == showRes)begin
                if (executecalc) begin
                    executecalc = 0;
                end
                if (currKey < 4'b1010) begin
                    num1 = {12'b000000000000, currKey};
                    num2 = 0;
                    nxt_state = wait4num1;
                end
            end
            keyreleased = 1'b1;
        end
    end

endmodule