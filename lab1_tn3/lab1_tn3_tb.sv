`timescale 1ns/1ps

module lab1_tn3_tb();
    // Khai báo các tín hiệu theo module lab1_tn3 của bạn
    logic clk, rst, En_A, En_B;
    logic [7:0] A, B;
    logic [15:0] reg_P;

    // Khởi tạo DUT (Dùng tên các cổng khớp với code của bạn)
    lab1_tn3 dut (
        .clk(clk), .rst(rst), 
        .En_A(En_A), .En_B(En_B), 
        .A(A), .B(B), 
        .reg_P(reg_P)
    );

    // Tạo xung Clock
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // --- TASK MỚI: Nạp A và B cùng lúc ---
    task load_AB(input [7:0] val_A, input [7:0] val_B);
        begin
            A = val_A; B = val_B;
            En_A = 1; En_B = 1; // Bật cả hai tín hiệu cho phép nạp
            @(posedge clk);     // Chờ cạnh lên clock để chốt đồng thời vào reg_A và reg_B
            #2 En_A = 0; En_B = 0;
        end
    endtask

    initial begin
        // Khởi tạo và Reset
        rst = 0; En_A = 0; En_B = 0; A = 0; B = 0;
        #30 rst = 1; // Kết thúc reset (active-high theo code của bạn)
        #20;

        // Test 1: 10 x 5
        load_AB(8'd10, 8'd5);
        repeat(2) @(posedge clk); // Đợi 2 chu kỳ để kết quả đi qua 2 tầng thanh ghi

        // Test 2: 255 x 2
        // Bây giờ kết quả sẽ nhảy thẳng từ 50 lên 510, không đi qua 1275
        load_AB(8'd255, 8'd2);
        repeat(2) @(posedge clk);

        #100 $stop;
    end
endmodule