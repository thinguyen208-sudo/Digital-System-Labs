module register6 #(parameter n=9)
(
	input rst, clk,
	input [(n-1):0] D,
	output logic [(n-1):0] Q
);
 always_ff @(posedge clk)
	begin
	if (!rst)
	Q <= 9'b000000000;
	else
	Q <= D;
	end
endmodule

module comb_logic6 (
	input [8:0] p_state,
	input in,
	output [8:0] n_state,
	output out
);
assign n_state[0] = 1'b1;
assign n_state[1] = (~p_state[0] | p_state[5] | p_state[6] | p_state[7] | p_state[8]) & (~in);
assign n_state[2] =  p_state[1] & (~in);
assign n_state[3] =  p_state[2] & (~in);
assign n_state[4] = (p_state[3] | p_state[4])& (~in);
assign n_state[5] = (~p_state[0] | p_state[1] | p_state[2] | p_state[3] | p_state[4]) & in;
assign n_state[6] =  p_state[5] & in;
assign n_state[7] =  p_state[6] & in;
assign n_state[8] = (p_state[7] | p_state[8]) & in;

assign out = (p_state[4]) | (p_state[8]);
endmodule

module lab2_tn1_6
(
	input [1:0] SW,
	input [0:0] KEY,
	output [9:0]LEDR
);
logic [8:0] a, b;
comb_logic6 comb_inst (
	.in (SW[1]),
	.p_state (a),
	.n_state (b),
	.out(LEDR[9])
	);
register6 reg_inst(
	.Q(a),
	.D(b),
	.clk(KEY[0]),
	.rst(SW[0])
	);
assign LEDR[8:0] = a;
endmodule	