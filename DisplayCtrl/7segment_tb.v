`timescale 1ns / 10 ps

module top_tb;
	
	// internal signals 
	
	reg [15:0] num;
	wire [6:0] segments;
	wire [3:0] digit;
	wire[3:0] digit_pwr;	
	reg clk = 0; 
	integer  i;
	
	localparam DURATION = 10000;
	

				

			
	// instance fsm
	fsm_bin_2bcd uut_bin2bcd( 	.clk(clk) , 
								.resetn(1),
								.en(1) ,
								.in_4bcd(num) ,
								.out_bcd(digit) ,
								.out_shr(digit_pwr) ); 		
	
		// instantce bcd2seg				
	bcd_2seg uut_bcd2seg (
				.in_bcd(digit),
			 	.seg(segments)	
			);		
	   
			
	 initial begin
        for(i = 4660;i < 5000 ;i = i+1) //run loop for 0 to 15.
       		begin
            	num <= i;
            	#20; //wait 
        	end     
    end		
			
	always #1 clk = ~clk;
		
	initial begin
		$dumpfile("7segment_tb.vcd");
		$dumpvars(0,top_tb); 
		#(DURATION); 
		$display("finished");
		$finish;
	end
	
	
	endmodule
		