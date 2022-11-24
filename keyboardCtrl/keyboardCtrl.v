
module keyboardCtrl ( CLK, keyboardfil, keyboardcol, RESET, BCDKey, KeyRead);

    input wire CLK, RESET;  //Q0, Q1 son las columnas que se energizaron del teclado
                                                //KeyPressed se activa cuando se presiona una tecla de la columna
    wire D0, D1, Q0, Q1; 
    wire KeyPressed;
    output reg KeyRead;                 //KeyRead indica al toplevel que se presiona una tecla
    output reg [3:0] BCDKey;                 //En este cable esta escrito el BCD a transportar
    
    output reg [3:0]keyboardcol;
    input wire [3:0]keyboardfil;
    reg [1:0]colnum = 2'b00;

    always@(posedge CLK, posedge RESET)    //State register movement
        begin
            if (RESET == 1)begin
                colnum = 0;
            end
            else begin
                if(!KeyPressed) colnum = colnum + 1;
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
                        BCDKey = 11;                KeyRead <= KeyPressed;

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
        
    assign D0 = colnum[0];
    assign D1 = colnum[1];

	Deco_138 decoder(.A({D0, D1}), .Y(keyboardcol));
    Encoder encoder(.I(keyboardfil), .A({Q0, Q1}), .OE(KeyPressed));


endmodule
