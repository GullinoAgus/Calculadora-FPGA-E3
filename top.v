//----------------------------------------------------------------------------
//                                                                          --
//                         Module Declaration                               --
//                                                                          --
//----------------------------------------------------------------------------
module top
(
    // outputs
    output  wire        gpio_28,        // Display a
    output  wire        gpio_38,        // Display b
    output  wire        gpio_42,        // Display c
    output  wire        gpio_36,        // Display d
    output  wire        gpio_43,        // Display e
    output  wire        gpio_34,        // Display f
    output  wire        gpio_37,        // Display g
    output  wire        gpio_31,        // Display DP
    output  wire        gpio_35,        // Display DS1
    output  wire        gpio_32,        // Display DS2
    output  wire        gpio_27,        // Display DS3
    output  wire        gpio_26,        // Display DS4
    output  wire        gpio_2,         // Display kbEN
    output  wire        gpio_46,        // Display kbColnum0
    output  wire        gpio_47,        // Display kbColnum1
    output  wire        gpio_45,        // Display kbRow0
    input  wire        gpio_48,        // Display kbRow1
    input  wire        gpio_3,        // Display kbRow1
    input  wire        gpio_4,        // Display kbRow1
    input  wire        gpio_44,        // Display kbRow1
    input  wire        gpio_5,         // Reset
    output  wire        gpio_12,         // Salida de Clock
    output  wire        gpio_9,         // Salida de Clock
    output  wire        gpio_11,         // Salida de Clock
    output  wire        gpio_18         // Salida de Clock

);

    wire         [15:0]num1;
    wire         [15:0]num2;
    wire         [3:0]op;
    wire         [15:0]res;
    wire         clk;
    wire         [3:0]kbcol;
    wire         [3:0]kbrow;
    wire         [3:0]pressedKey;
    wire         reset = gpio_5;
    wire         [15:0]display;
    wire         [7:0]displaysticks;
    wire         [3:0]diplayselect;
    wire         readKey;

    assign displaysticks[0] = gpio_28;
    assign displaysticks[1] = gpio_38;
    assign displaysticks[2] = gpio_42;
    assign displaysticks[3] = gpio_36;
    assign displaysticks[4] = gpio_43;
    assign displaysticks[5] = gpio_34;
    assign displaysticks[6] = gpio_37;
    assign displaysticks[7] = gpio_31;
    assign diplayselect[0] = gpio_35;
    assign diplayselect[0] = gpio_32;
    assign diplayselect[0] = gpio_27;
    assign diplayselect[0] = gpio_26;
    assign kbcol[0] = gpio_2;
    assign kbcol[1] = gpio_46;
    assign kbcol[2] = gpio_47;
    assign kbcol[3] = gpio_45;
    assign kbrow[0] = gpio_48;
    assign kbrow[1] = gpio_3;
    assign kbrow[2] = gpio_4;
    assign kbrow[3] = gpio_44;

    // Test wires

 
//----------------------------------------------------------------------------
//                                                                          --
//                       Internal Oscillator                                --
//                                                                          --
//----------------------------------------------------------------------------
 SB_LFOSC  u_SB_LFOSC(.CLKLFPU(1), .CLKLFEN(1), .CLKLF(clk));
    assign gpio_12 = clk;

//----------------------------------------------------------------------------
//                                                                          --
//                       Module Instantiation                               --
//                                                                          --
//----------------------------------------------------------------------------
mainFSB fsb(.kbEN(readKey),
    .pressedkey(pressedKey),
    .ALUres(res),
    .ALUNum1(num1),
    .ALUNum2(num2),
    .ALUOp(op),
    .Display(display),
    .clk(clk));
keyboardCtrl kbctrl(.CLK(clk),
                    .keyboardfil(kbrow), 
                    .EnableKeyb(supply), 
                    .keyboardcol(kbcol), 
                    .RESET(reset), 
                    .BCDKey(pressedKey), 
                    .KeyRead(readKey),
                    .state({gpio_9, gpio_11, gpio_18}));

wire [3:0]digit;
wire [3:0]digit_pwr;
fsm_bin_2bcd uut_bin2bcd( 	.clk(clk) , 
								.resetn(~reset),
								.en(1) ,
								.in_4bcd(display) ,
								.out_bcd(digit) ,
								.out_shr(digit_pwr) ); 		

		// instantce bcd2seg				
bcd_2seg uut_bcd2seg (
				.in_bcd(digit),
			 	.seg(displaysticks));		
ALU u_alu(    
    .num1(num1), .num2(num2),     //Num 1 and 2 BCD
    .op(op),              //Operand
    .clk(clk),             
    .res(res));       //Output BCD result);


endmodule
