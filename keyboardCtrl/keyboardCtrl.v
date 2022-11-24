
module keyboardCtrl ( CLK, keyboardfil, keyboardcol, RESET, BCDKey, KeyRead);

    input wire CLK, RESET;  //Q0, Q1 son las columnas que se energizaron del teclado
                                                //KeyPressed se activa cuando se presiona una tecla de la columna
    wire D0, D1, Q0, Q1; 
    wire KeyPressed;
    output reg KeyRead;                 //KeyRead indica al toplevel que se presiona una tecla
    output [3:0] BCDKey;                 //En este cable esta escrito el BCD a transportar
    
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
                KeyRead = KeyPressed;
            end
            
        end 
        
    assign D0 = colnum[0];
    assign D1 = colnum[1];
	assign BCDKey[0] = D0;
	assign BCDKey[1] = D1;
	assign BCDKey[2] = Q0;
	assign BCDKey[3] = Q1;
	Deco_138 decoder(.A({D0, D1}), .Y(keyboardcol));
    Encoder encoder(.I(keyboardfil), .A({Q0, Q1}), .OE(KeyPressed));


endmodule
