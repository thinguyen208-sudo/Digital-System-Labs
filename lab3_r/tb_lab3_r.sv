`timescale 1ns/1ps

module tb_lab3_r();

    // Khai báo các tín hiệu kết nối với khối thiết kế (DUT - Design Under Test)
    logic [7:0] A;
    logic [7:0] B;
    logic       S;
    logic [7:0] Result;
    logic       z;
    logic       OV;

    // Triệu hồi (Instantiate) Module Top
    lab3_r dut (
        .A(A),
        .B(B),
        .S(S),
        .Result(Result),
        .z(z),
        .OV(OV)
    );

    // Khối initial chạy một lần duy nhất để bơm dữ liệu test
    initial begin
        $display("=== BAT DAU MO PHONG FLOATING-POINT ADDER/SUBTRACTOR ===");

        // 1. Phép Cộng Cơ Bản: 1.5 + 0.75 = 2.25
        // 1.5  -> 0_011_1000 (8'h38)
        // 0.75 -> 0_010_1000 (8'h28)
        // Kết quả mong đợi: 2.25 -> 0_100_0010 (8'h42)
        A = 8'h38; B = 8'h28; S = 1'b0; 
        #10; // Đợi 10 đơn vị thời gian cho mạch xử lý
        $display("Test 1 (1.5 + 0.75): Result = %h, Z = %b, OV = %b", Result, z, OV);

        // 2. Phép Trừ Cơ Bản: 5.5 - 1.25 = 4.25
        // 5.5  -> 0_101_0110 (8'h56)
        // 1.25 -> 0_011_0100 (8'h34)
        // Kết quả mong đợi: 4.25 -> 0_101_0000 (8'h50)
        A = 8'h56; B = 8'h34; S = 1'b1; 
        #10;
        $display("Test 2 (5.5 - 1.25): Result = %h, Z = %b, OV = %b", Result, z, OV);

        // 3. Phép Cộng Số Hụt (Subnormal): 0.25 + 0.015625 = 0.265625
        // 0.25     -> 0_001_0000 (8'h10)
        // 0.015625 -> 0_000_0001 (8'h01)
        // Kết quả mong đợi: 0_001_0001 (8'h11)
        A = 8'h10; B = 8'h01; S = 1'b0; 
        #10;
        $display("Test 3 (Subnormal):  Result = %h, Z = %b, OV = %b", Result, z, OV);

        // 4. Kiểm tra Tràn Số (Overflow): 15.5 + 0.5
        // Tràn số xảy ra khi kết quả nằm ngoài phạm vi biểu diễn của 8-bit[cite: 317].
        // 15.5 -> 0_110_1111 (8'h6F)
        // 0.5  -> 0_010_0000 (8'h20)
        // Kết quả mong đợi: OV = 1
        A = 8'h6F; B = 8'h20; S = 1'b0; 
        #10;
        $display("Test 4 (Overflow):   Result = %h, Z = %b, OV = %b", Result, z, OV);

        // 5. Kiểm tra Cờ Zero: 1.5 - 1.5 = 0
        // Cờ Zero sẽ bằng 1 khi kết quả tính toán bằng 0[cite: 317].
        // 1.5 -> 8'h38
        // Kết quả mong đợi: Z = 1, Result = 8'h00
        A = 8'h38; B = 8'h38; S = 1'b1; 
        #10;
        $display("Test 5 (Zero Case):  Result = %h, Z = %b, OV = %b", Result, z, OV);

        $display("=== HOAN TAT MO PHONG ===");
        $stop; // Dừng mô phỏng
    end

endmodule