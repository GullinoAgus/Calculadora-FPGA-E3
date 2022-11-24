
module mainFSB(
    
    input wire readKey,
    input wire [3:0]pressedkey,
    input wire [15:0]ALUres,
    output reg [15:0]num1,
    output reg [15:0]num2,
    output reg [3:0]operation,
    output reg executecalc,
    output reg [15:0]info2display,
    input wire clk,
    input wire reset
);

    // States of the FSM
    localparam calculate = 2'b00;
    localparam wait4num1 = 2'b01;
    localparam wait4num2 = 2'b10;
    localparam showRes = 2'b11;

    //Possible calculator keys
    localparam equal = 4'd10;
    localparam AC = 4'd11;
    localparam plus = 4'd12;
    localparam minus = 4'd13;
    localparam mult = 4'd14;
    localparam div = 4'd15;

    //Inner variables
    reg [3:0]currKey;
    reg keyreleased = 1;
    reg [1:0]curr_state= wait4num1;
    reg [1:0]nxt_state = wait4num1;


    always @(posedge readKey) begin
        currKey = pressedkey;
    end

    always @(posedge clk) begin
        curr_state <= nxt_state;

        if (readKey) begin          // Control de tecla soltada
            keyreleased = 1'b0;
        end

        //State updater
        case (curr_state)
            wait4num1: info2display = num1; // En estado inicial se muestra el numero 1

            wait4num2: info2display = num2; // En estado de segundo numero se muestra el numero 2

            calculate:begin                 // Se manda flanco a la ALU para q calcule el resultado
                executecalc = 1;
                nxt_state = showRes;
            end
            
            showRes: info2display = ALUres; // Muestro el resultado que calculo la ALU

        endcase
        if ((!readKey) && (!keyreleased)) begin // Cuando se suelta la tecla luego de presionarla
            
            if(curr_state == wait4num1)begin    //Estado inicial esperando primer numero 
                if (currKey < equal) begin      // Si se presiono un numero se concatena al q se muestra
                    num1 = {num1[11:0], currKey};
                end

                if (currKey > AC)begin          // Si se presiono un operador se guarda y se pasa al proximo estado
                    operation = currKey;
                    nxt_state = wait4num2;
                end

                if (currKey == AC) begin        // Si se presiono AC limpio el numero 1
                    num1 = 0;
                end
            end
            if(curr_state == wait4num2)begin    // Estado de espera para ingreso de numero 2
                
                if (currKey < equal) begin      // Si se ingreso un numero se concatena
                    num2 = {num2[11:0], currKey};
                end
                
                if (currKey == equal)begin      // Si se presiona igual se manda la ALU a calcular
                    nxt_state = calculate;
                    executecalc = 0;
                end
                
                if (currKey == AC) begin        // AC borra todo
                    num2 = 0;
                end

            end

            if(curr_state == showRes)begin      // Estado donde se muestra el resultado en display
                
                if (currKey < equal) begin    // Si se ingresa otro numero se pasa al estado inicial con todo los regs limpios
                    num1 = {12'd0, currKey};
                    num2 = 0;
                    nxt_state = wait4num1;
                end
                if (currKey > AC) begin         // si se presiona una operacion, se concatena y s econtinua operando sobre resultado
                    num1 = ALUres;
                    num2 = 0;
                    operation = currKey;
                    nxt_state = wait4num2;
                end
            end
            keyreleased = 1'b1;
        end

    end

endmodule