
module keyboardCtrl ( CLK, keyboardfil, EnableKeyb, keyboardcol, RESET, BCDKey, KeyRead, state);

    input wire CLK, RESET;  //Q0, Q1 son las columnas que se energizaron del teclado
                                                //KeyPressed se activa cuando se presiona una tecla de la columna
    wire D0, D1, Q0, Q1; 
    reg KeyPressed;
    output wire KeyRead;                 //D0, D1 son las filas del teclado para hacer polling
    output wire [0:1]state;

                                                //KeyRead indica al toplevel que se presiona una tecla
    output EnableKeyb;                          //EnableKeyb activa al teclado para funcionar
    output [0:3] BCDKey;                    //En este cable esta escrito el BCD a transportar
    //SB_LFOSC u_SB_HFOSC(.CLKLFPU(1), .CLKLFEN(1), .CLKLF(int_lfosc));   //Esto deberia instanciarlo la FSM

    //assign EnableKeyb = 1; //Esto deberia hacerlo el top level para activar o desactivar el teclado si lo desea
    output reg [3:0]keyboardcol;
    input wire [3:0]keyboardfil;
    reg [0:1]colnum = 2'b00;

    assign state = colnum;

    always@(posedge CLK, posedge RESET)    //State register movement
        begin
            if (RESET == 1)begin
                colnum = 0;
                KeyPressed = 0;
            end
            else begin
                if(!KeyPressed) colnum = colnum + 1;
                KeyPressed = |keyboardfil;
            end
            
        end
        
    assign KeyRead = KeyPressed;
    assign D0 = colnum[0];
    assign D1 = colnum[1];
	
	Deco_138 decoder(.A({D0, D1}), .Y(keyboardcol));
    Encoder encoder(.I(keyboardfil), .A({Q0, Q1}));
    // keybToBCD keybToBCDTransformation (
    //     .D0(D0),
    //     .D1(D1),
    //     .Q0(Q0),
    //     .Q1(Q1),
    //     .BCDKey(BCDKey),
	// 	.CLK(CLK)
    // );

endmodule
