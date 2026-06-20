module lab2_tn2_binary (
	input [0:0]KEY, 
	input [1:0]SW,
	output [9:0]LEDR
) ;
// 1. State declaration (one-hot encoding)
parameter
A = 4'b0000,
B = 4'b0001,
C = 4'b0010,
D = 4'b0011,
E = 4'b0100,
F = 4'b0101,
G = 4'b0110,
H = 4'b0111,
I = 4'b1000;

logic [3:0] present_state , next_state ;
// 2. State register
always_ff @ ( posedge KEY[0] , posedge SW[0] ) begin /* FF description*/
if (SW[0])
present_state <= A;
else
present_state <= next_state;
end
// 3. Next-state combinational logic
always_comb /*next state transition*/
begin
next_state = present_state; // default state is the same
case ( present_state )
A : if ( SW[1] ) next_state = F;
else next_state = B;
B : if ( SW[1] ) next_state = F;
else next_state = C;
C : if ( SW[1] ) next_state = F;
else next_state = D;
D : if ( SW[1] ) next_state = F;
else next_state = E;
E : if ( SW[1] ) next_state = F;
else next_state = E;
F : if ( SW[1] ) next_state = G;
else next_state = B;
G : if ( SW[1] ) next_state = H;
else next_state = B;
H : if ( SW[1] ) next_state = I;
else next_state = B;
I : if ( SW[1] ) next_state = I;
else next_state = B;
default: next_state = A;
endcase
end
// 4. Output logic
assign LEDR[9] = (present_state == E) || (present_state == I);
assign LEDR[8:4] = 5'b00000;
assign LEDR[3:0] = present_state;
endmodule