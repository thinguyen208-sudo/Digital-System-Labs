module register_2 
(
	input rst, clk,
	input [3:0] D,
	output logic [3:0] Q
);
 always_ff @(posedge clk)
	begin
	if (!rst)
	Q <= 3'b0000;
	else
	Q <= D;
	end
endmodule

module comb_logic_2 (
	input [3:0] p_state,
	input in,
	output [3:0] n_state,
	output out
);
/*
assign n_state[0] =	(~p_state[3]	&	~p_state[2]	&	~p_state[1]	&	~p_state[0]	&	~in) 
*/

assign n_state[0] =	(~p_state[3]	&	~p_state[2]	&	in) 
						|	(~p_state[3]	&	~p_state[0]	&	in)
						|	(~p_state[2]	&	~p_state[1]	&	~p_state[0]	&	~in)
						|	(~p_state[3]	&	p_state[2]	&	p_state[0]	&	~in)
						|	(~p_state[3]	&	p_state[1]	&	~p_state[0]);
						
assign n_state[1] =	(~p_state[3]	&	~p_state[2]	&	~p_state[1]	&	p_state[0]	&	~in) 
						|	(~p_state[3]	&	~p_state[2]	&	p_state[1]	&	~p_state[0]	&	~in) 
						| 	(~p_state[3]	&	p_state[2]	&	~p_state[1]	&	p_state[0]	&	in) 
						|	(~p_state[3]	&	p_state[2]	&	p_state[1]	&	~p_state[0]	&	in);
						
assign n_state[2] =	(~p_state[3]	&	~p_state[1]	&	in)
						|	(~p_state[3]	&	~p_state[0]	&	in)
						|	(~p_state[3]	&	p_state[2]	&	~p_state[1]	&	~p_state[0])
						|	(~p_state[3]	&	~p_state[2]	&	p_state[1]	&	p_state[0]);

assign n_state[3] =	(~p_state[3]	&	p_state[2]	&	p_state[1]	&	p_state[0]	&	in)
						|	(p_state[3]		&	~p_state[2]	&	~p_state[1]	&	~p_state[0]	&	in);
						
assign out			=	(~p_state[3]	&	p_state[2]	&	~p_state[1]	&	~p_state[0]	)
						|	(p_state[3]		&	~p_state[2]	&	~p_state[1]	&	~p_state[0]	);
endmodule

module lab2_tn1_binary
(
	input [0:0]KEY, 
	input [1:0]SW,
	output [9:0] LEDR
);
logic [3:0] a, b;
comb_logic_2 comb_inst (
	.in (SW[1]),
	.p_state (a),
	.n_state (b),
	.out(LEDR[9])
	);
register_2 reg_inst(
	.Q(a),
	.D(b),
	.clk(KEY[0]),
	.rst(SW[0])
	);
assign LEDR[3:0]= a;
assign LEDR[8:4] = 5'b00000;
endmodule	
