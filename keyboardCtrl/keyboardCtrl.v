
module keyboardCtrl ( CLK, keyboardfil, KeyPressed, EnableKeyb, keyboardcol, RESET, BCDKey, KeyRead);

    input wire CLK, KeyPressed, RESET;  //Q0, Q1 son las columnas que se energizaron del teclado
                                                //KeyPressed se activa cuando se presiona una tecla de la columna
    wire D0, D1, Q0, Q1;
    output wire KeyRead;                 //D0, D1 son las filas del teclado para hacer polling
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

    reg [0:2] present_state = POLL1, next_state;
    always@(posedge CLK)    //State register movement
        begin
            if (RESET == 1)begin
                present_state = POLL1;
            end
            else begin
                present_state = next_state;
            end
        end

    always@(present_state, KeyPressed) //Next state logic
        begin
            case(present_state)
            POLL1:          if(KeyPressed == 0)        next_state = POLL2;
                            else                next_state = SIGNAL1;
            POLL2:          if(KeyPressed == 0)        next_state = POLL3;
                            else                next_state = SIGNAL2;
            POLL3:          if(KeyPressed == 0)        next_state = POLL4;
                            else                next_state = SIGNAL3;
            POLL4:          if(KeyPressed == 0)        next_state = POLL1;
                            else                next_state = SIGNAL4;
            SIGNAL1:        if(KeyPressed == 0)        next_state = POLL1;
            SIGNAL2:        if(KeyPressed == 0)        next_state = POLL2;
            SIGNAL3:        if(KeyPressed == 0)        next_state = POLL3;
            SIGNAL4:        if(KeyPressed == 0)        next_state = POLL4;
            default: next_state = POLL1;
            endcase
        end
    assign KeyRead = present_state[0];
    assign D0 = present_state[1];
    assign D1 = present_state[2];
    // always@(present_state)  //Output Logic
    //     begin
    //         case(present_state)
	//             POLL1:  
	// 			begin
	// 				D0 = 0; D1 = 0; KeyRead = 0;
	// 			end
	//             SIGNAL1:
	// 			begin
	// 				D0 = 0; D1 = 0; KeyRead = 1;
	// 			end
	//             POLL2:
	// 			begin
	// 				D0 = 0; D1 = 1; KeyRead = 0;
	// 			end
	//             SIGNAL2:
	// 			begin
	// 				D0 = 0; D1 = 1; KeyRead = 1; 
	// 			end
	//             SIGNAL3:
	// 			begin
	// 				D0 = 1; D1 = 0; KeyRead = 1;
	// 			end
	//             POLL4: 
	// 			begin
	// 				D0 = 1; D1 = 1; KeyRead = 0; 
	// 			end
	//             SIGNAL4:
	// 			begin
	// 				D0 = 1; D1 = 1; KeyRead = 1;
	// 			end
    //         endcase
    //     end
	
	Deco_138 decoder(.A({D0, D1}), .Y(keyboardcol));
    Encoder encoder(.I(keyboardfil), .A({Q0, Q1}));
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
                    0: Y= 4'b0001;
                    1: Y= 4'b0010;
                    2: Y= 4'b0100;
                    3: Y= 4'b1000;
                    default: Y= 4'b1111;
            endcase
        end
endmodule 
 module Encoder(I, A);
    
    input wire [3:0] I;
    output reg [1:0] A;
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