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
    input  wire        gpio_2,         // col0
    input  wire        gpio_46,        // col1
    input  wire        gpio_47,        // col2
    input  wire        gpio_45,        // col3
    output  wire        gpio_48,        // row0
    output  wire        gpio_3,        // row1
    output  wire        gpio_4,        // row2
    output  wire        gpio_44,        // row3
    input  wire        gpio_12,        // reset
    output  wire        gpio_6,         // Reset
    output  wire        gpio_9,       // Test
    output  wire        gpio_11,        // Test
    output  wire        gpio_18,       // Test
    output  wire        gpio_19,       // Test
    output  wire        gpio_13,        // Test
    output  wire        gpio_21,        // Test

);

    wire         [15:0]num1;
    wire         [15:0]num2;
    wire         [3:0]op;
    wire         [15:0]res;
    wire         clk;
    wire         [3:0]kbcol;
    wire         [3:0]kbrow;
    wire         [3:0]pressedKey;
    wire         reset = gpio_12;
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
    assign diplayselect[1] = gpio_32;
    assign diplayselect[2] = gpio_27;
    assign diplayselect[3] = gpio_26;
    wire [3:0]digit;
    assign kbrow[0] = gpio_2;
    assign kbrow[1] = gpio_46;
    assign kbrow[2] = gpio_47;
    assign kbrow[3] = gpio_45;
    assign kbcol[0] = gpio_48;
    assign kbcol[1] = gpio_3;
    assign kbcol[2] = gpio_4;
    assign kbcol[3] = gpio_44;

    // Test wires
    wire [0:6]test;
    assign test[0] = gpio_6;
    assign test[1] = gpio_9;
    assign test[2] = gpio_11;
    assign test[3] = gpio_18;
    assign test[4] = gpio_19;
    assign test[5] = gpio_13;
    assign test[6] = gpio_21;

//----------------------------------------------------------------------------
//                                                                          --
//                       Internal Oscillator                                --
//                                                                          --
//----------------------------------------------------------------------------
SB_LFOSC  u_SB_LFOSC(.CLKLFPU(1), .CLKLFEN(1), .CLKLF(clk));

//----------------------------------------------------------------------------
//                                                                          --
//                       Module Instantiation                               --
//                                                                          --
//----------------------------------------------------------------------------

assign test[6] = readKey;
wire clkkb;
Clock_divider divider(clk, clkkb);
keyboardCtrl kbctrl(.CLK(clkkb),
                    .keyboardfil(kbrow),
                    .keyboardcol(kbcol),
                    .RESET(reset),
                    .BCDKey(pressedKey),
                    .KeyRead(readKey));

fsm_bin_2bcd uut_bin2bcd( .clk(clk) ,
								.resetn(~reset),
								.en(1) ,
								.in_4bcd(display) ,
								.out_bcd(digit) ,
								.out_shr(diplayselect) );

// 		// instantce bcd2seg
bcd_2seg uut_bcd2seg (
				.in_bcd(digit),
			 	.seg(displaysticks));
ALU u_alu(
    .num1(num1), .num2(num2),     //Num 1 and 2 BCD
    .op(op),              //Operand
    .clk(clk),
    .res(res));       //Output BCD result);
mainFSB fsb(.kbEN(readKey),
    .pressedkey(pressedKey),
    .ALUres(res),
    .ALUNum1(num1),
    .ALUNum2(num2),
    .ALUOp(op),
    .Display(display),
    .clk(clk),
    .reset(reset),
    .state(test[0:5]));


endmodule
