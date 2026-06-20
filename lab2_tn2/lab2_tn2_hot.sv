
// Behaviorial coding

module lab2_tn2_hot (
	input [1:0] SW,
	input [0:0] KEY,
	output [9:0]LEDR
) ;
// 1. State declaration (one-hot encoding)
parameter 
A = 9'b000000001,
B = 9'b000000010,
C = 9'b000000100,
D = 9'b000001000,
E = 9'b000010000,
F = 9'b000100000,
G = 9'b001000000,
H = 9'b010000000,
I = 9'b100000000;
logic [8:0] present_state , next_state ;
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
next_state = present_state; // default state is the same if not change anything
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
assign LEDR[8:0] = present_state;

endmodule