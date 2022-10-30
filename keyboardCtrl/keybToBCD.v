module keybToBCD (D0,D1,Q0,Q1,BCDKey,CLK);

    input wire D0,D1,Q0,Q1,CLK;
    output reg [0:3] BCDKey;
	
	always@(posedge CLK)
	begin
	    if (D0 == 1'b0 && D1 == 1'b0 && Q0 == 1'b0 && Q1 == 1'b0) begin
	        BCDKey = 4'b0000;
	    end
	    else if (D0 == 0 && D1 == 0 && Q0 == 0 && Q1 == 1) begin
	        BCDKey = 4'b0001;
	    end
	    else if (D0 == 0 && D1 == 0 && Q0 == 1 && Q1 == 0) begin
	        BCDKey = 4'b0010;
	    end
	    else if (D0 == 0 && D1 == 0 && Q0 == 1 && Q1 == 1) begin
	        BCDKey = 4'b0011;
	    end
	    else if (D0 == 0 && D1 == 1 && Q0 == 0 && Q1 == 0) begin
	        BCDKey = 4'b0100;
	    end
	    else if (D0 == 0 && D1 == 1 && Q0 == 0 && Q1 == 1) begin
	        BCDKey = 4'b0101;
	    end
	    else if (D0 == 0 && D1 == 1 && Q0 == 1 && Q1 == 0) begin
	        BCDKey = 4'b0110;
	    end
	    else if (D0 == 0 && D1 == 1 && Q0 == 1 && Q1 == 1) begin
	        BCDKey = 4'b0111;
	    end
	    else if (D0 == 1 && D1 == 0 && Q0 == 0 && Q1 == 0) begin
	        BCDKey = 4'b1000;
	    end
	    else if (D0 == 1 && D1 == 0 && Q0 == 0 && Q1 == 1) begin
	        BCDKey = 4'b1001;
	    end
	    else if (D0 == 1 && D1 == 0 && Q0 == 1 && Q1 == 0) begin
	        BCDKey = 4'b1010;
	    end
	    else if (D0 == 1 && D1 == 0 && Q0 == 1 && Q1 == 1) begin
	        BCDKey = 4'b1011;
	    end
	    else if (D0 == 1 && D1 == 1 && Q0 == 0 && Q1 == 0) begin
	        BCDKey = 4'b1100;
	    end
	    else if (D0 == 1 && D1 == 1 && Q0 == 0 && Q1 == 1) begin
	        BCDKey = 4'b1101;
	    end
	    else if (D0 == 1 && D1 == 1 && Q0 == 1 && Q1 == 0) begin
	        BCDKey = 4'b1110;
	    end
	    else begin
	        BCDKey = 4'b1111;
	    end
	end
endmodule