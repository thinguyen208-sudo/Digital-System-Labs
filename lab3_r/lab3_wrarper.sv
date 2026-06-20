module lab3_wrapper(
	input  [9:0] SW, // SW[7:0] to select input, sw[8] to select register, sw[9] to select + or -
	input  [2:0] KEY,
	output [9:0] LEDR //LEDR[7:0] for the result, LEDR[8] for the zero detection, LEDR[9] for the overflow
);

	logic [7:0]w_A;
	logic [7:0]w_B;

	register r1(
		.D(SW[7:0]),
		.clk(~KEY[1]),
		.RST(~KEY[0]),
		.EN(~SW[8]),
		.Q(w_A)
	);
	
	register r2(
		.D(SW[7:0]),
		.clk(~KEY[1]),
		.RST(~KEY[0]),
		.EN(SW[8]),
		.Q(w_B)
	);
	
	lab3_r r(
		.A(w_A),
		.B(w_B),
		.S(SW[9]),
		.Result (LEDR[7:0]),
		.z(LEDR[8]),
		.OV(LEDR[9])
	);
	
endmodule
	