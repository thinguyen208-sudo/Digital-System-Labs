// Top-level module cho DE10-Lite FPGA
module lab1_tn2_wrapper (
    // Inputs từ Hardware [cite: 175, 176]
    input  logic [9:0]  SW,        // SW[7:0] cho A, SW[9] cho add_sub
    input  logic [1:0]  KEY,       // KEY[0] cho rst_n, KEY[1] cho clock
    
    // Outputs ra Hardware [cite: 181, 182]
    output logic [9:0]  LEDR,      // LEDR[7:0]: S, LEDR[8]: Carry, LEDR[9]: Overflow
    output logic [6:0]  HEX0,      // 7-segment display 0
    output logic [6:0]  HEX1,      // 7-segment display 1
    output logic [6:0]  HEX2,      // 7-segment display 2
    output logic [6:0]  HEX3,      // 7-segment display 3
    output logic [6:0]  HEX4,      // (Không dùng, tắt đi)
    output logic [6:0]  HEX5       // (Không dùng, tắt đi)
);

    // Tắt các bộ HEX không sử dụng (Active-low nên gán 1111111)
    assign HEX4 = 7'b1111111;
    assign HEX5 = 7'b1111111;

    // Khởi tạo (Instantiate) module Experiment 2 đã viết [cite: 103, 104]
    lab1_tn2 core_logic (
        .SW(SW),          // Nối SW7-0 cho A và SW9 cho add_sub 
        .KEY(KEY),        // KEY0: reset_n, KEY1: clock 
        .LEDR(LEDR),      // Hiển thị S và các cờ Carry/Overflow 
        .HEX0(HEX0),      // Hiển thị S (low nibble) 
        .HEX1(HEX1),      // Hiển thị S (high nibble) 
        .HEX2(HEX2),      // Hiển thị A (low nibble) 
        .HEX3(HEX3)       // Hiển thị A (high nibble) 
    );

endmodule