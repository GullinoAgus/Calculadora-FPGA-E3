
module mainFSB(
    
    input wire kbEN,
    input wire pressedkey[0:4],
    input wire ALUres[0:15],
    output wire ALUNum1[0:15],
    output wire ALUNum2[0:15],
    output wire ALUOp[0:15],
    output wire Display[0:15],
    input wire clk

);
    reg operation[0:3] = 4'b0000;
    reg num1[0:15] = 16'b000000000000;
    reg num2[0:15] = 16'b000000000000;
    reg res[0:15] = 16'b000000000000;
    reg currKey[0:3] = 4'b0000;

    reg curr_state[0:2];
    reg fut_state[0:2];

    parameter wait4num1 = 3'b000;
    parameter wait4num2 = 3'b001;
    parameter wait4equal = 3'b010;
    parameter showRes = 3'b011;

    parameter equal = 4'b1010;
    parameter AC = 4'b1011;
    parameter plus = 4'b1100;
    parameter minus = 4'b1101;
    parameter mult = 4'b1110;
    parameter div = 4'b1111;

    always @(negedge kbEN) begin
        currKey = kbEN;
        case (curr_state)
            wait4equal: 
                if (currKey == equal) begin
                    curr_state <= showRes;
                    Display <= res; 
                end
            wait4num2:
                case (currKey)
                    : 
                    default: 
                endcase
            default: 
        endcase
    end

endmodule