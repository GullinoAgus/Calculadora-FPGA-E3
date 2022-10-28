
module ALU(num1, num2, op, res, isValid);

output reg isValid; //Indica cuando es valido el resultado
output reg[0:15] res;

input wire[0:15] num1; //Num 1 BCD
input wire[0:15] num2; //Num 2 BCD
input wire[0:1] op;          //Operando

wire[0:13] num1Bin;
wire[0:13] num2Bin;
integer i;

assign num1Bin = (num1[0:3] * 10'd1000) + (num1[4:7] * 7'd100) + (num1[8:11] * 4'd10) + num1[12:15];
assign num2Bin = (num2[0:3] * 10'd1000) + (num2[4:7] * 7'd100) + (num2[8:11] * 4'd10) + num2[12:15];

always @ (num1, num2, op)
    begin
        res = 0;
        isValid = 0;

        case (op)
            2'b00: res = num1Bin + num2Bin;
            2'b01: res = num1Bin - num2Bin;
        endcase

        for (i = 0; i < 14; i = i+1) 
            begin					//Iterate once for each bit in input number
                if (res[0:3] >= 5) res[0:3] = res[0:3] + 3;		//If any BCD digit is >= 5, add three
                if (res[4:7] >= 5) res[4:7] = res[4:7] + 3;
                if (res[8:11] >= 5) res[8:11] = res[8:11] + 3;
                if (res[12:15] >= 5) res[12:15] = res[12:15] + 3;
                res = {res[0:14], res[13-i]};				//Shift one bit, and shift in proper bit from input 
            end
        
        isValid = 1;
    end
endmodule