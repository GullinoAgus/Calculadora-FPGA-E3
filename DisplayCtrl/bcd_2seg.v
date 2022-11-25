
module bcd_2seg (in_bcd,seg);
	
	
	input wire [3:0] in_bcd;
	output reg [0:6] seg; 
	
	// At input change 
    always @(in_bcd)
    begin
        case (in_bcd) 
            0 : seg <= ~7'b1000000;  // g f e d c b a Active Low
            1 : seg <= ~7'b1111001;
            2 : seg <= ~7'b0100100;
            3 : seg <= ~7'b0110000;
            4 : seg <= ~7'b0011001;
            5 : seg <= ~7'b0010010;
            6 : seg <= ~7'b0000010;
            7 : seg <= ~7'b1111000;
            8 : seg <= ~7'b0000000;
            9 : seg <= ~7'b0010000;
            10: seg <= ~7'b0001000; //A
            11: seg <= ~7'b1001000; //n
            12: seg <= ~7'b1000110; //C
            13: seg <= ~7'b0100001; //d
            14: seg <= ~7'b0000110; //E
            15: seg <= ~7'b1111111; //F
            
            default : seg <= 7'b1111111;    // Default off
        endcase
    end
    
endmodule