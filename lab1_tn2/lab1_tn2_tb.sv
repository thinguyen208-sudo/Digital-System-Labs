`timescale 1ns/1ps

module lab1_tn2_tb();
    // --- CÁC THÀNH PHẦN HIỂN THỊ TRONG FIGURE & DIAGRAM ---
    logic        Clock;    // KEY1
    logic        rst;      // KEY0 (Active-low reset)
    logic        add_sub;  // SW9
    logic [7:0]  A;        // SW7-0
    logic [7:0]  S;        // LEDR7-0 
    logic        carry;    // LEDR8 
    logic        overflow; // LEDR9

    // Kết nối tín hiệu cho Module chính
    logic [9:0] SW_in;
    logic [1:0] KEY_in;
    logic [9:0] LEDR_out;

    assign SW_in[7:0] = A;
    assign SW_in[9]   = add_sub;
    assign SW_in[8]   = 1'b0; 
    assign KEY_in[1]  = Clock;
    assign KEY_in[0]  = rst;

    assign S        = LEDR_out[7:0];
    assign carry    = LEDR_out[8];
    assign overflow = LEDR_out[9];

    // Khởi tạo Unit Under Test (UUT)
    lab1_tn2 uut (
        .SW(SW_in), .KEY(KEY_in), .LEDR(LEDR_out),
        .HEX0(), .HEX1(), .HEX2(), .HEX3() 
    );

    // Tạo xung nhịp chu kỳ 10ns
    always #5 Clock = ~Clock;

    initial begin
        // 1. Khởi tạo ban đầu
        Clock   = 0;
        rst     = 1;
        add_sub = 0;
        A       = 8'h00;

        // 2. Thực hiện Reset (Khớp với đoạn đầu rst nhô cao trong diagram)
        #2  rst = 0; 
        #10 rst = 1;
        #5;

        // 3. Chuỗi giá trị A và add_sub theo đúng Diagram trang 6 [cite: 161-170]
        @(negedge Clock) begin A = 8'h55; add_sub = 0; end // Bước 1: Cộng 0x55
        @(negedge Clock) begin A = 8'h24; add_sub = 1; end // Bước 2: Cộng 0x24
        @(negedge Clock) begin A = 8'h48; add_sub = 1; end // Bước 3: Trừ 0x48
        @(negedge Clock) begin A = 8'h71; add_sub = 0; end // Bước 4: Cộng 0x71
        @(negedge Clock) begin A = 8'h95; add_sub = 1; end // Bước 5: Trừ 0x95
        @(negedge Clock) begin A = 8'h30; add_sub = 1; end // Bước 6: Cộng 0x30
        @(negedge Clock) begin A = 8'h9A; add_sub = 0; end // Bước 7: Trừ 0x9A
        @(negedge Clock) begin A = 8'h10; add_sub = 1; end // Bước 8: Cộng 0x10
        @(negedge Clock) begin A = 8'h60; add_sub = 0; end // Bước 9: Trừ 0x60
        @(negedge Clock) begin A = 8'h80; add_sub = 1; end // Bước 10: Cộng 0x80

        repeat(3) @(posedge Clock);
        $display("Simulation Experiment 2 hoàn tất!");
        $stop;
    end
endmodule