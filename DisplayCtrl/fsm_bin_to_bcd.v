
module fsm_bin_2bcd (clk, resetn , en , in_4bcd , out_bcd , out_shr ); 
	
    input clk, resetn , en ;

	input wire [15:0] in_4bcd;
	output reg [3:0] out_bcd;
	output reg [3:0] out_shr;	
    reg [2:1] y = 2'b00;

    // Asignacion de estados
    parameter [2:1] A = 2'b00;
    parameter [2:1] B = 2'b01;
    parameter [2:1] C = 2'b10;
	parameter [2:1] D = 2'b11;

    // Logica de proximo estado y avance de estado combinadas
    always @(negedge resetn, posedge clk)
        if (resetn == 0) y <= A;
        else
            case (y)
                A:  if (en) 
						begin
						y <= B;
						out_bcd[3:0] <= in_4bcd[15:12];
						out_shr[0] <= 0;
						out_shr[1] <= 1;
						out_shr[2] <= 1;
						out_shr[3] <= 1;
						end
					else     y <= A;
					
                B:  if (en)
						begin
						y <= C;
						out_bcd[3:0] <= in_4bcd[11:8];
						out_shr[0] <=1;
						out_shr[1] <= 0;
						out_shr[2] <= 1;
						out_shr[3] <= 1;
						end
					else y <= A;
                C:  if (en) 
						begin
						y <= D;
						out_bcd[3:0] <= in_4bcd[7:4];
						out_shr[0] <= 1;
						out_shr[1] <= 1;
						out_shr[2] <= 0;
						out_shr[3] <= 1;  
						end
					else     y <= A;					
                D:  if (en) 
					begin
						y <= A;
						out_bcd[3:0] <= in_4bcd[3:0];
						out_shr[0] <= 1;
						out_shr[1] <= 1;
						out_shr[2] <= 1;
						out_shr[3] <= 0;
					end
					
					else     y <= A; 
				default:     y <= 2'bxx;
            endcase

endmodule	

