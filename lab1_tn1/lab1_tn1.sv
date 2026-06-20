//Module Giai ma 7-segment
module hex_7seg (
    input  logic [3:0] hex,
    output logic [6:0] seg
);
    // Bảng chân trị cho bộ giải mã 7 đoạn (Active-low cho FPGA Intel)
    always_comb begin
        case (hex)
            4'h0: seg = 7'b1000000; 4'h1: seg = 7'b1111001;
            4'h2: seg = 7'b0100100; 4'h3: seg = 7'b0110000;
            4'h4: seg = 7'b0011001; 4'h5: seg = 7'b0010010;
            4'h6: seg = 7'b0000010; 4'h7: seg = 7'b1111000;
            4'h8: seg = 7'b0000000; 4'h9: seg = 7'b0010000;
            4'hA: seg = 7'b0001000; 4'hB: seg = 7'b0000011;
            4'hC: seg = 7'b1000110; 4'hD: seg = 7'b0100001;
            4'hE: seg = 7'b0000110; 4'hF: seg = 7'b0001110;
            default: seg = 7'b1111111;
        endcase
    end
endmodule

//Khoi D-Flip Flop
module dff_en (
    input  logic d, clk, rst_n, en,
    output logic q
);
    // Reset mức thấp (negedge) theo yêu cầu đề bài [cite: 315, 357]
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) 
            q <= 1'b0;
        else if (en) 
            q <= d;
    end
endmodule


// Thanh ghi 8-bit
module reg_8bit_struct (
    input  logic [7:0] D,
    input  logic clk, rst_n, en,
    output logic [7:0] Q
);
    // Lắp ghép từng bit một, không dùng vòng lặp for
    dff_en bit0 (D[0], clk, rst_n, en, Q[0]);
    dff_en bit1 (D[1], clk, rst_n, en, Q[1]);
    dff_en bit2 (D[2], clk, rst_n, en, Q[2]);
    dff_en bit3 (D[3], clk, rst_n, en, Q[3]);
    dff_en bit4 (D[4], clk, rst_n, en, Q[4]);
    dff_en bit5 (D[5], clk, rst_n, en, Q[5]);
    dff_en bit6 (D[6], clk, rst_n, en, Q[6]);
    dff_en bit7 (D[7], clk, rst_n, en, Q[7]);
endmodule

// Full Adder
module full_adder (
    input  logic a, b, cin,
    output logic s, cout
);
    assign s    = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

// Module bộ cộng 8-bit sử dụng cấu trúc Ripple Carry
module adder_8bit (
    input  logic [7:0] a, b,
    input  logic cin,
    output logic [7:0] sum,
    output logic cout,
	 output logic c7_out
);
    logic [7:1] c; // Các đường mang nhớ trung gian

    // Kết nối các bộ cộng toàn phần (Full Adders)
    full_adder fa0 (a[0], b[0], cin,  sum[0], c[1]);
    full_adder fa1 (a[1], b[1], c[1], sum[1], c[2]);
    full_adder fa2 (a[2], b[2], c[2], sum[2], c[3]);
    full_adder fa3 (a[3], b[3], c[3], sum[3], c[4]);
    full_adder fa4 (a[4], b[4], c[4], sum[4], c[5]);
    full_adder fa5 (a[5], b[5], c[5], sum[5], c[6]);
    full_adder fa6 (a[6], b[6], c[6], sum[6], c[7]);
    full_adder fa7 (a[7], b[7], c[7], sum[7], cout);
endmodule

//khoi logic phat hien tran
module overflow_det (
    input  logic c7,
    input  logic c8,
    output logic v
);
    // Tràn xảy ra khi mang nhớ vào bit dấu khác với mang nhớ ra khỏi bit dấu
    assign v = c7 ^ c8;
endmodule

module lab1_tn1 (
    input  logic [7:0] SW,      // SW7-0: Input A [cite: 90]
    input  logic [1:0] KEY,     // KEY0: Reset_n, KEY1: Clock [cite: 90]
    output logic [9:0] LEDR,    // LEDR7-0: S, LEDR8: Carry, LEDR9: Overflow 
    output logic [6:0] HEX0, HEX1, HEX2, HEX3 // Hiển thị A và S 
);
    // Tín hiệu nội bộ
    logic [7:0] A_reg, S_accumulator, next_sum;
    logic c7_sig, c8_sig, v_sig;

    // 1. Khối thanh ghi đầu vào A (Register R trong Figure 1) [cite: 27]
    // Sử dụng KEY1 làm Clock và KEY0 làm Reset không đồng bộ
    reg_8bit_struct regA (
        .D(SW), 
        .clk(KEY[1]), 
        .rst_n(KEY[0]), 
        .en(1'b1), 
        .Q(A_reg)
    );

    // 2. Bộ cộng 8-bit (Accumulator logic: S = S + A) [cite: 19]
    adder_8bit adder_inst (
        .a(A_reg), 
        .b(S_accumulator), 
        .cin(1'b0), 
        .sum(next_sum), 
        .cout(c8_sig), 
        .c7_out(c7_sig)
    );

    // 3. Khối kiểm tra lỗi Tràn (Overflow: V = C7 ^ C8) 
    assign v_sig = c7_sig ^ c8_sig;

    // 4. Thanh ghi lưu trữ Tổng (Accumulator Register S) [cite: 29]
    reg_8bit_struct regS (
        .D(next_sum), 
        .clk(KEY[1]), 
        .rst_n(KEY[0]), 
        .en(1'b1), 
        .Q(S_accumulator)
    );

    // 5. Chốt tín hiệu Carry và Overflow vào thanh ghi (Registered Flags) 
    dff_en carry_ff    (c8_sig, KEY[1], KEY[0], 1'b1, LEDR[8]);
    dff_en overflow_ff (v_sig,  KEY[1], KEY[0], 1'b1, LEDR[9]);

    // Hiển thị Tổng S lên đèn LEDR7-0 
    assign LEDR[7:0] = S_accumulator;

    // 6. Hiển thị Hexadecimal lên các bộ 7-segment 
    // HEX3-2 hiển thị giá trị thanh ghi A (A_reg)
    hex_7seg h3(A_reg[7:4], HEX3);
    hex_7seg h2(A_reg[3:0], HEX2);
    // HEX1-0 hiển thị giá trị tổng hiện tại (S_accumulator)
    hex_7seg h1(S_accumulator[7:4], HEX1);
    hex_7seg h0(S_accumulator[3:0], HEX0);

endmodule