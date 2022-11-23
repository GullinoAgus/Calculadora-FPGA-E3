module Deco_138 ( A, Y);

    input wire [1:0] A;
    output reg [3:0] Y;
    
    always @ (A)
        begin
            case (A)
                    0: Y= 4'bzzz1;
                    1: Y= 4'bzz1z;
                    2: Y= 4'bz1zz;
                    3: Y= 4'b1zzz;
                    default: Y= 4'bzzzz;
            endcase
        end
endmodule 
module Encoder(I, A, OE);
    
    input wire [3:0] I;
    output reg [1:0] A;
	output reg OE;
    integer j;
    
    always @ (I)
        begin       
            casez (I)
				4'bzzz1: begin
					A = 2'b00;
					OE = 1;
				end 
				4'bzz1z: begin
					A = 2'b01;
					OE = 1;
				end 
				4'bz1zz: begin
					A = 2'b10;
					OE = 1;
				end 
				4'b1zzz: begin
					A = 2'b11;
					OE = 1;
				end 
				default: begin
					A = 2'b00;
					OE = 0;
				end 
			endcase
        end
endmodule 