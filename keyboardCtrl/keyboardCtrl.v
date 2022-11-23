
module keyboardCtrl ( CLK, keyboardfil, EnableKeyb, keyboardcol, RESET, BCDKey, KeyRead, state);

    input wire CLK, RESET;  //Q0, Q1 son las columnas que se energizaron del teclado
                                                //KeyPressed se activa cuando se presiona una tecla de la columna
    wire D0, D1, Q0, Q1, KeyPressed;
    output wire KeyRead;                 //D0, D1 son las filas del teclado para hacer polling
    output [0:2]state;

                                                //KeyRead indica al toplevel que se presiona una tecla
    output EnableKeyb;                          //EnableKeyb activa al teclado para funcionar
    output [0:3] BCDKey;                    //En este cable esta escrito el BCD a transportar
    //SB_LFOSC u_SB_HFOSC(.CLKLFPU(1), .CLKLFEN(1), .CLKLF(int_lfosc));   //Esto deberia instanciarlo la FSM

    //assign EnableKeyb = 1; //Esto deberia hacerlo el top level para activar o desactivar el teclado si lo desea
    output reg [3:0]keyboardcol;
    input wire [3:0]keyboardfil;
    
    localparam [0:2]
    POLL1 = 3'b000,
    POLL2 = 3'b001,
    POLL3 = 3'b010,
    POLL4 = 3'b011,
    SIGNAL1 = 3'b100,
    SIGNAL2 = 3'b101,
    SIGNAL3 = 3'b110,
    SIGNAL4 = 3'b111;
    // assign state = present_state;
    reg [0:2] present_state;
    always@(posedge CLK, posedge RESET)    //State register movement
        begin
            if (RESET == 1)begin
                present_state = POLL1;
            end
            else begin
                case(present_state)
                    POLL1:          if(!KeyPressed) present_state <= POLL2;
                                    else present_state <= SIGNAL1;
                    POLL2:          if(!KeyPressed) present_state <= POLL3;
                                    else present_state <= SIGNAL2;
                    POLL3:          if(!KeyPressed) present_state <= POLL4;
                                    else present_state <= SIGNAL3;
                    POLL4:          if(!KeyPressed) present_state <= POLL1;
                                    else present_state <= SIGNAL4;
                    SIGNAL1:        if(KeyPressed == 0)        present_state <= POLL2;
                    SIGNAL2:        if(KeyPressed == 0)        present_state <= POLL3;
                    SIGNAL3:        if(KeyPressed == 0)        present_state <= POLL4;
                    SIGNAL4:        if(KeyPressed == 0)        present_state <= POLL1;
                endcase
            end
        end

    assign KeyRead = present_state[0];
    assign D0 = present_state[1];
    assign D1 = present_state[2];
	
	Deco_138 decoder(.A({D0, D1}), .Y(keyboardcol));
    Encoder encoder(.I(keyboardfil), .A({Q0, Q1}), .OE(KeyPressed));
    keybToBCD keybToBCDTransformation (
        .D0(D0),
        .D1(D1),
        .Q0(Q0),
        .Q1(Q1),
        .BCDKey(BCDKey),
		.CLK(CLK)
    );

endmodule
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
    output wire OE;
    assign OE = gnd;
    integer j;
    
    always @ (I)
        begin       
            for(j=0;j<=3;j=j+1)
                if(I[j]==1)
                    begin
                        A=j;
                    end
        end
endmodule 