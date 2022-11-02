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
    output  wire        gpio_47         // Display kbColnum1
);

    wire         [15:0]num1;
    wire         [15:0]num2;
    wire         [3:0]op;
    wire         int_osc;
    reg [27:0]  frequency_counter_i;

//----------------------------------------------------------------------------
//                                                                          --
//                       Internal Oscillator                                --
//                                                                          --
//----------------------------------------------------------------------------
    SB_LFOSC  u_SB_LFOSC(.CLKLFPU(1), .CLKLFEN(1), .CLKLF(int_osc));


//----------------------------------------------------------------------------
//                                                                          --
//                       Counter                                            --
//                                                                          --
//----------------------------------------------------------------------------
    always @(posedge int_osc) begin
	    frequency_counter_i <= frequency_counter_i + 1'b1;
    end

//----------------------------------------------------------------------------
//                                                                          --
//                       Instantiate RGB primitive                          --
//                                                                          --
//----------------------------------------------------------------------------
    SB_RGBA_DRV RGB_DRIVER (
      .RGBLEDEN (1'b1),
      .RGB0PWM  (frequency_counter_i[25]&frequency_counter_i[24]),
      .RGB1PWM  (frequency_counter_i[25]&~frequency_counter_i[24]),
      .RGB2PWM  (~frequency_counter_i[25]&frequency_counter_i[24]),
      .CURREN   (1'b1),
      .RGB0     (led_green),		//Actual Hardware connection
      .RGB1     (led_blue),
      .RGB2     (led_red)
    );
    defparam RGB_DRIVER.RGB0_CURRENT = "0b000001";
    defparam RGB_DRIVER.RGB1_CURRENT = "0b000001";
    defparam RGB_DRIVER.RGB2_CURRENT = "0b000001";

endmodule
