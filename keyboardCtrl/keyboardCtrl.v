
module keyboardCtrl ( CLK, Q0, Q1, OUT, Enable, D0, D1, RESET );

    input wire CLK, Q0, Q1, OUT, RESET; //Q0, Q1 son las columnas que se energizaron del teclado
                                        //OUT se activa cuando se presiona una tecla de la columna
    output wire Enable, D0, D1;     //Enable activa al teclado para funcionar
                                    //D0, D1 son las filas del teclado para hacer polling

    //SB_LFOSC u_SB_HFOSC(.CLKLFPU(1), .CLKLFEN(1), .CLKLF(int_lfosc));   //Esto deberia instanciarlo la FSM

    parameter [0:1]
    POLL1 = 2'b00,
    POLL2 = 2'b01,
    SIGNAL = 2'b10;

    reg [0:1] present_state, next_state;

    always@(posedge CLK)    //State register movement
        begin
            if (RESET == 1)
                present_state = POLL1;
            else
                present_state = next_state;
        end

    always@(present_state, OUT) //Next state logic
        begin
            case(present_state)
            POLL1:          if(OUT == 0)        next_state = POLL2;
                            else                next_state = SIGNAL;
            POLL2:          if(OUT == 0)        next_state = POLL1;
                            else                next_state = SIGNAL;
            SIGNAL:         if(OUT == 0)        next_state = POLL1;
            endcase
        end
    
    always@(present_state)  //Output Logic
                            //Tengo que pensar acá como verga voy a hacer para transformar las filas en BCD
        begin
           case(present_state)
           POLL1:           

           POLL2:

           SIGNAL:

           endcase
        end
endmodule