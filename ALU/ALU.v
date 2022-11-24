
module ALU(
    input[15:0] num1, num2,     //Num 1 and 2 BCD
    input[3:0] op,              //Operand
    input exe,                  //Signal to do the operation
    output reg [15:0] res,       //Output BCD result
);

localparam nan = 16'hFBAB;  //Not a number param

localparam plus = 4'd12;
localparam minus = 4'd13;
localparam mult = 4'd14;
localparam div = 4'd15;

wire[13:0] num1Bin, num2Bin;
integer i, binResult;
assign num1Bin = fromBCDtoBin(num1); //assign make connections between inputs and outputs
assign num2Bin = fromBCDtoBin(num2);

always @(posedge exe)
    begin
        if ((op == div) && (num2 == 0)) begin
            res = nan;
        end
        else begin
        case (op)
            plus: binResult = num1Bin + num2Bin;
            minus: binResult = num1Bin - num2Bin;
            mult: binResult = num1Bin * num2Bin;
            div: binResult = num1Bin / num2Bin;
            default: binResult = num1Bin + num2Bin;
        endcase
        res = 0;
        for (i = 0; i < 14; i = i+1) 
            begin					//Iterate once for each bit in input number
                if (res[3:0] >= 5) res[3:0] = res[3:0] + 3;		//If any BCD digit is >= 5, add three
                if (res[7:4] >= 5) res[7:4] = res[7:4] + 3;
                if (res[11:8] >= 5) res[11:8] = res[11:8] + 3;
                if (res[15:12] >= 5) res[15:12] = res[15:12] + 3;
                res = {res[14:0], binResult[13-i]};				//Shift one bit, and shift in proper bit from input 
            end
        end
    end

function [13:0] fromBCDtoBin (input [15:0] BCDnum);
    begin
        fromBCDtoBin = (BCDnum[15:12] * 10'd1000) + (BCDnum[11:8] * 7'd100) + (BCDnum[7:4] * 4'd10) + BCDnum[3:0];
    end
endfunction

endmodule