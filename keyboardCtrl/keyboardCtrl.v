
module keyboardCtrl ( 
    input wire clk, reset,
    input wire [3:0] keyboardfil, //Col
    output reg [3:0] keyboardcol, //Fil
    output reg [3:0] BCDKey, //This is not a BCDKey, is equivalent key in keyboard, from 0 to D, # and *
    output reg KeyRead //Flag that indicate that any key was pressed
);

    wire D0, D1, Q0, Q1; //D for rows and Q for columns
    wire KeyPressed;  //High when any key is was pressed from keyboard
    
    reg [1:0]colnum = 2'b00;
    assign D0 = colnum[0];
    assign D1 = colnum[1];

    //Modulos for sweep keyboard
	Deco_138 decoder(.A({D0, D1}), .Y(keyboardcol));
    Encoder encoder(.I(keyboardfil), .A({Q0, Q1}), .OE(KeyPressed));

    always @ (posedge clk, posedge reset)    
        begin
            if (reset == 1)begin
                colnum = 0;
            end
            else begin
                if(!KeyPressed) colnum = colnum + 1; //State register movement
                case ({D0, D1, Q0, Q1})
                    4'b0000:begin
                        BCDKey = 1;
                    end
                    4'b0100:begin
                        BCDKey = 2;
                    end
                    4'b1000:begin
                        BCDKey = 3;
                    end
                    4'b1100:begin
                        BCDKey = 12;
                    end
                    4'b0001:begin
                        BCDKey = 4;
                    end
                    4'b0101:begin
                        BCDKey = 5;
                    end
                    4'b1001:begin
                        BCDKey = 6;
                    end
                    4'b1101:begin
                        BCDKey = 13;
                    end
                    4'b0010:begin
                        BCDKey = 7;
                    end
                    4'b0110:begin
                        BCDKey = 8;
                    end
                    4'b1010:begin
                        BCDKey = 9;
                    end 
                    4'b1110:begin
                        BCDKey = 14;
                    end
                    4'b0011:begin
                        BCDKey = 11;                
                    end
                    4'b0111:begin
                        BCDKey = 0;
                    end
                    4'b1011:begin
                        BCDKey = 10;
                    end
                    4'b1111:begin
                        BCDKey = 15;
                    end
                    default: BCDKey = 0;
                endcase
                KeyRead <= KeyPressed;
            end
        end 
endmodule
