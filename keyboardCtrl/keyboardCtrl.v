
module keyboardCtrl ( 
    input wire CLK,
    input wire RESET,
    input wire [3:0] keyboardfil,
    output reg KeyPressed,           //High value when any key was pressed in the keyboard
    output reg [3:0] keyboardcol,
    output reg [3:0] onBoardEquivalentKey
);
                                                
    wire C0, C1, R0, R1;                      
    reg [1:0] colnum;           //Current listening column

    assign R0 = colnum[0];
    assign R1 = colnum[1];

	Deco_138 decoder(.A({R0, R1}), .Y(keyboardcol));
    Encoder encoder(.I(keyboardfil), .A({C0, C1}), .OE(KeyPressed));

    always @ (posedge CLK, posedge RESET)    //State register movement
        begin
            if (RESET == 1)
                begin
                    colnum = 0;
                end
            else 
                begin
                    if(!KeyPressed)
                    begin
                        colnum = colnum + 1; //Shifting column as a multiplexor
                    end

                    case ({C0, C1, R0, R1})
                        4'b0000:begin
                            onBoardEquivalentKey = 1;
                        end
                        4'b0100:begin
                            onBoardEquivalentKey = 2;
                        end
                        4'b1000:begin
                            onBoardEquivalentKey = 3;
                        end
                        4'b1100:begin
                            onBoardEquivalentKey = 12;
                        end
                        4'b0001:begin
                            onBoardEquivalentKey = 4;
                        end
                        4'b0101:begin
                            onBoardEquivalentKey = 5;
                        end
                        4'b1001:begin
                            onBoardEquivalentKey = 6;
                        end
                        4'b1101:begin
                            onBoardEquivalentKey = 13;
                        end
                        4'b0010:begin
                            onBoardEquivalentKey = 7;
                        end
                        4'b0110:begin
                            onBoardEquivalentKey = 8;
                        end
                        4'b1010:begin
                            onBoardEquivalentKey = 9;
                        end 
                        4'b1110:begin
                            onBoardEquivalentKey = 14;
                        end
                        4'b0011:begin
                            onBoardEquivalentKey = 11;
                        end
                        4'b0111:begin
                            onBoardEquivalentKey = 0;
                        end
                        4'b1011:begin
                            onBoardEquivalentKey = 10;
                        end
                        4'b1111:begin
                            onBoardEquivalentKey = 15;
                        end
                        default: begin
                            onBoardEquivalentKey = 0;
                        end
                    endcase
                end
        end
endmodule
