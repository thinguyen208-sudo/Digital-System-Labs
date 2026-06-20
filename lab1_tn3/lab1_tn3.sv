module lab1_tn3_wrapper (
    input  logic [1:0] KEY,    // KEY1: Clock, KEY0: Sync Reset
    input  logic [9:0] SW,     // SW7-0: Data, SW9: EA, SW8: EB
    output logic [9:0] LEDR,   
    output logic [6:0] HEX0, HEX1, HEX2, HEX3
);

    logic [7:0]  reg_A, reg_B;
    logic [15:0] p_wire, reg_P;

    // --- Khoi thanh ghi (Input/Output Registered) ---
    // Luu y: Theo yeu cau trang 7 la Synchronous Reset 
    always_ff @(posedge KEY[1]) begin
        if (!KEY[0]) begin 
            reg_A <= 8'h0;
            reg_B <= 8'h0;
            reg_P <= 16'h0;
        end else begin
            if (SW[9]) reg_A <= SW[7:0]; // Chot du lieu cho A 
            if (SW[8]) reg_B <= SW[7:0]; // Chot du lieu cho B 
            reg_P <= p_wire;             // Chot ket qua tich P [cite: 159]
        end
    end

    // Ket noi bo nhan
    eight_bit_multiplier multiplier_inst (
        .A(reg_A), .B(reg_B), .P(p_wire)
    );

    // --- Logic dieu khien LEDR  ---
    assign LEDR[7:0] = SW[9] ? reg_A : (SW[8] ? reg_B : 8'h0);
    assign LEDR[9:8] = 2'b00;

    // --- Giai ma 7-segment (Hexadecimal) [cite: 168] ---
    led7seg_decoder h0 (reg_P[3:0],   HEX0);
    led7seg_decoder h1 (reg_P[7:4],   HEX1);
    led7seg_decoder h2 (reg_P[11:8],  HEX2);
    led7seg_decoder h3 (reg_P[15:12], HEX3);

endmodule
module lab1_tn3(
    input logic clk, 
    input logic rst,
    input logic En_A,
    input logic En_B,
    input logic [7:0] A,
    input logic [7:0] B,
    output logic [15:0] reg_P
);

logic [7:0] reg_A;
logic [7:0] reg_B;
logic [15:0] p;

eight_bit_register Register_A_mult(
    .clk (clk),
    .rst (rst),
    .D (En_A ? A : reg_A),
    .Q (reg_A)
);

eight_bit_register Register_B_mult(
    .clk (clk),
    .rst (rst),
    .D (En_B ? B : reg_B),
    .Q (reg_B)
);

eight_bit_multiplier Multiplier(
    .A (reg_A),
    .B (reg_B),
    .P (p)
);

register_16_bit Register_P(
    .clk (clk),
    .rst (rst),
    .D (p),
    .Q (reg_P)
);

endmodule

module eight_bit_multiplier (
    input  logic [7:0] A,
    input  logic [7:0] B,
    output logic [15:0] P
);
    // Cac day tin hieu trung gian cho 7 bo cong
    logic [7:0] s [0:6];
    logic [0:6] c;

    // Tinh bit dau tien
    assign P[0] = A[0] & B[0];

    // Bo cong 0: Cong (A*B[0] dich phai 1) voi (A*B[1])
    eight_bit_adder add0 (
        .A({1'b0, A[7:1]} & {8{B[0]}}), 
        .B(A & {8{B[1]}}), 
        .C_in(1'b0), .S(s[0]), .C_out(c[0])
    );
    assign P[1] = s[0][0];

    // Bo cong 1: Cong (Ket qua add0 dich phai 1) voi (A*B[2])
    eight_bit_adder add1 (
        .A({c[0], s[0][7:1]}), 
        .B(A & {8{B[2]}}), 
        .C_in(1'b0), .S(s[1]), .C_out(c[1])
    );
    assign P[2] = s[1][0];

    // Bo cong 2
    eight_bit_adder add2 ({c[1], s[1][7:1]}, (A & {8{B[3]}}), 1'b0, s[2], c[2]);
    assign P[3] = s[2][0];

    // Bo cong 3
    eight_bit_adder add3 ({c[2], s[2][7:1]}, (A & {8{B[4]}}), 1'b0, s[3], c[3]);
    assign P[4] = s[3][0];

    // Bo cong 4
    eight_bit_adder add4 ({c[3], s[3][7:1]}, (A & {8{B[5]}}), 1'b0, s[4], c[4]);
    assign P[5] = s[4][0];

    // Bo cong 5
    eight_bit_adder add5 ({c[4], s[4][7:1]}, (A & {8{B[6]}}), 1'b0, s[5], c[5]);
    assign P[6] = s[5][0];

    // Bo cong 6
    eight_bit_adder add6 ({c[5], s[5][7:1]}, (A & {8{B[7]}}), 1'b0, s[6], c[6]);
    
    // Cac bit con lai cua ket qua
    assign P[15:7] = {c[6], s[6]};

endmodule

module register_16_bit(
    input logic clk,
    input logic rst,
    input logic [15:0] D,
    output logic [15:0] Q
);
always_ff @( posedge clk or negedge rst ) begin
    if(!rst)
        Q <= 16'b0;
    else
        Q <= D;
end
endmodule
module eight_bit_adder(
    input logic [7:0] A,
    input logic [7:0] B,
    input logic C_in,
    output logic [7:0] S,
    output logic C_out,
    output logic V
);

logic [8:0] carry;

full_adder add0(
    .a (A[0]),
    .b (B[0]^C_in),
    .Cin (carry[0]),
    .s (S[0]),
    .Cout (carry[1])
);

full_adder add1(
    .a (A[1]),
    .b (B[1]^C_in),
    .Cin (carry[1]),
    .s (S[1]),
    .Cout (carry[2])
);

full_adder add2(
    .a (A[2]),
    .b (B[2]^C_in),
    .Cin (carry[2]),
    .s (S[2]),
    .Cout (carry[3])
);

full_adder add3(
    .a (A[3]),
    .b (B[3]^C_in),
    .Cin (carry[3]),
    .s (S[3]),
    .Cout (carry[4])
);

full_adder add4(
    .a (A[4]),
    .b (B[4]^C_in),
    .Cin (carry[4]),
    .s (S[4]),
    .Cout (carry[5])
);

full_adder add5(
    .a (A[5]),
    .b (B[5]^C_in),
    .Cin (carry[5]),
    .s (S[5]),
    .Cout (carry[6])
);

full_adder add6(
    .a (A[6]),
    .b (B[6]^C_in),
    .Cin (carry[6]),
    .s (S[6]),
    .Cout (carry[7])
);

full_adder add7(
    .a (A[7]),
    .b (B[7]^C_in),
    .Cin (carry[7]),
    .s (S[7]),
    .Cout (carry[8])
);

assign carry[0] = C_in;
assign C_out = carry[8];
assign V = carry[8] ^ carry[7];

endmodule
module led7seg_decoder(
    input logic [3:0] i_data,
    output logic [6:0] o_hex
);

	always_comb begin
    unique case(i_data)
      4'd0: o_hex = 7'b1000000;
      4'd1: o_hex = 7'b1111001;
      4'd2: o_hex = 7'b0100100;
      4'd3: o_hex = 7'b0110000;
      4'd4: o_hex = 7'b0011001;
      4'd5: o_hex = 7'b0010010;
      4'd6: o_hex = 7'b0000010;
      4'd7: o_hex = 7'b1111000;
      4'd8: o_hex = 7'b0000000;
      4'd9: o_hex = 7'b0010000;
      4'd10: o_hex = 7'b0001000;
      4'd11: o_hex = 7'b0000011;
      4'd12: o_hex = 7'b1000110;
      4'd13: o_hex = 7'b0100001;
      4'd14: o_hex = 7'b0000110;
      4'd15: o_hex = 7'b0001110;
      default: o_hex = 7'b0111111;
    endcase
  end
endmodule
module full_adder(
    input a, b, Cin,
    output s, Cout
);
assign s = a^b^Cin;
assign Cout = a&b | (a^b)&Cin;
endmodule
module eight_bit_register(
    input logic clk,
    input logic rst,
    input logic [7:0] D,
    output logic [7:0] Q
);

always_ff @( posedge clk or negedge rst ) begin
    if(!rst)
        Q <= 8'b0;
    else 
        Q <= D;   
end
endmodule