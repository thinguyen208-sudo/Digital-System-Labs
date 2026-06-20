// --- File: lab1_top_wrapper.sv ---
// Module lớp vỏ để gán chân thực tế trên board FPGA
module lab1_tn1_wrapper (
    input  logic [9:0] SW,      // 10 Switches trên board
    input  logic [1:0] KEY,     // 2 Keys (Push buttons)
    output logic [9:0] LEDR,    // 10 Red LEDs
    output logic [6:0] HEX0,    // 7-segment HEX0
    output logic [6:0] HEX1,    // 7-segment HEX1
    output logic [6:0] HEX2,    // 7-segment HEX2
    output logic [6:0] HEX3     // 7-segment HEX3
);

    // Khởi tạo (instantiate) module chính lab1_tn1 của bạn
    lab1_tn1 core_inst (
        .SW(SW[7:0]),    // Sử dụng SW7 đến SW0 để nhập dữ liệu A 
        .KEY(KEY),       // KEY0: Reset (Active-low), KEY1: Clock 
        .LEDR(LEDR),     // LEDR7-0: Sum, LEDR8: Carry, LEDR9: Overflow 
        .HEX0(HEX0),     // Hiển thị phần thấp của tổng S 
        .HEX1(HEX1),     // Hiển thị phần cao của tổng S 
        .HEX2(HEX2),     // Hiển thị phần thấp của thanh ghi A 
        .HEX3(HEX3)      // Hiển thị phần cao của thanh ghi A 
    );

endmodule