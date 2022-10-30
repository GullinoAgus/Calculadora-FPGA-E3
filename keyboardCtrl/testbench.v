//-----------------------------------------------------------------------------
//
// Title       : testbench
// Design      : TP2_E3_2022
// Author      : Damian
// Company     : ITBA
//
//-----------------------------------------------------------------------------
//
// File        : D:\Programas\ActiveHDLDesigns\TP2_E3_2022\TP2_E3_2022\src\testbench.v
// Generated   : Sat Oct 29 18:42:17 2022
// From        : interface description file
// By          : Itf2Vhdl ver. 1.22
//
//-----------------------------------------------------------------------------
//
// Description : 
//
//-----------------------------------------------------------------------------
`timescale 1 ns / 1 ps

//{{ Section below this comment is automatically maintained
//   and may be overwritten
//{module {testbench}}
module testbench ();

//}} End of automatically maintained section

// -- Enter your statements here -- //


reg CLK, Q0, Q1, KeyPressed, RESET;

wire EnableKeyb, D0, D1, KeyRead;
wire [0:3] BCDKey;

//Las entradas son registros y las salidas son wire
keyboardCtrl keyb_tb (CLK, Q0, Q1, KeyPressed, EnableKeyb, D0, D1, RESET, BCDKey, KeyRead);

initial
	begin
		CLK = 0;
		Q0 = 0;
		Q1 = 0;
		KeyPressed = 0;
		#00ns RESET = 1;
		#10ns RESET = 0;
	end

always
	begin
		#1ns CLK = ~CLK;
	end
	
always
	begin
		#28ns Q0 = 1;
		#00ns Q1 = 0;
		#00ns KeyPressed = 1;
		#05ns KeyPressed = 0;
		#10ns Q0 = 0;
		#00ns Q1 = 0;
		
		#15ns Q0 = 0;
		#00ns Q1 = 0;
		#00ns KeyPressed = 1;
		#05ns KeyPressed = 0;
		#10ns Q0 = 0;
		#00ns Q1 = 0;
		
		
		#32ns Q0 = 1;
		#00ns Q1 = 1;
		#00ns KeyPressed = 1;
		#05ns KeyPressed = 0;
		#10ns Q0 = 0;
		#00ns Q1 = 0;
		
		
		#21ns Q0 = 1;
		#00ns Q1 = 1;
		#00ns KeyPressed = 1;
		#05ns KeyPressed = 0;
		#10ns Q0 = 0;
		#00ns Q1 = 0;
		
		
		#06ns Q0 = 1;
		#00ns Q1 = 0;
		#00ns KeyPressed = 1;
		#05ns KeyPressed = 0;
		#10ns Q0 = 0;
		#00ns Q1 = 0;
	end	
	
endmodule