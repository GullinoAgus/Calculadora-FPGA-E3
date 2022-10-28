
module ALU(num1, num2, op, res, isValid);

output wire res[0:15]; //Resultado
output wire isValid; //Indica cuando es valido el resultado

input wire num1[0:15]; //Num 1 BCD
input wire num2[0:15]; //Num 2 BCD
input wire op;          //Operando

wire num1Bin[0:13];
wire num2Bin[0:13];

integer i;

assign num1Bin = (num1[0:3] * 10'd1000) + (num1[4:7] * 7'd100) + (num1[8:11] * 4'd10) + num1[12:15];
assign num2Bin = (num2[0:3] * 10'd1000) + (num2[4:7] * 7'd100) + (num2[8:11] * 4'd10) + num2[12:15];

always @ (num1, num2, op)
    begin

        isValid = 0;

        case (op)
            0: res = num1Bin + num2Bin;
            1: res = num1Bin - num2Bin;
        endcase

        for (i = 0; i < 14; i = i+1) 
            begin					//Iterate once for each bit in input number
                if (res[3:0] >= 5) res[3:0] = res[3:0] + 3;		//If any BCD digit is >= 5, add three
                if (res[7:4] >= 5) res[7:4] = res[7:4] + 3;
                if (res[11:8] >= 5) res[11:8] = res[11:8] + 3;
                if (res[15:12] >= 5) res[15:12] = res[15:12] + 3;
                res = {res[14:0], res[13-i]};				//Shift one bit, and shift in proper bit from input 
            end
        
        isValid = 1;
    end
endmodule