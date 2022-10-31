
module bcd_2seg (in_bcd,seg);
	
	
	input wire [3:0] in_bcd;
	output reg [6:0] seg; 
	
	
	
	//actuo siempre que cambie el numero 
    always @(in_bcd)
    begin
        case (in_bcd) 
            0 : seg <= 7'b0000001;  // a b c d e f g 
            1 : seg <= 7'b1001111;
            2 : seg <= 7'b0010010;
            3 : seg <= 7'b0000110;
            4 : seg <= 7'b1001100;
            5 : seg <= 7'b0100100;
            6 : seg <= 7'b0100000;
            7 : seg <= 7'b0001111;
            8 : seg <= 7'b0000000;
            9 : seg <= 7'b0000100;
            // si es A B C D E F apago display
            default : seg <= 7'b1111111; 
        endcase
    end
    
endmodule