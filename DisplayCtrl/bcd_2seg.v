
module bcd_2seg (in_bcd,seg);
	
	
	input wire [3:0] in_bcd;
	output reg [0:6] seg; 
	
	
	
	//actuo siempre que cambie el numero 
    always @(in_bcd)
    begin
        case (in_bcd) 
            0 : seg <= ~7'b1000000;  // g f e d c b a 
            1 : seg <= ~7'b1111001;
            2 : seg <= ~7'b0100100;
            3 : seg <= ~7'b0110000;
            4 : seg <= ~7'b0011001;
            5 : seg <= ~7'b0010010;
            6 : seg <= ~7'b0000010;
            7 : seg <= ~7'b1111000;
            8 : seg <= ~7'b0000000;
            9 : seg <= ~7'b0010000;
            10: seg <= ~7'b0001000;
            11: seg <= ~7'b0000011;
            12: seg <= ~7'b1000110;
            13: seg <= ~7'b0100001;
            14: seg <= ~7'b0000110;
            15: seg <= ~7'b0001110;
            // si es A B C D E F apago display
            default : seg <= 7'b1111111; 
        endcase
    end
    
endmodule