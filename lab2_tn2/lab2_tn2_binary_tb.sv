`timescale 1ns / 1ps

module lab2_tn2_binary_tb();

    // Khai báo các tín hiệu kết nối với module cần test (DUT)
    logic clk;
    logic rst; // Reset tích cực mức thấp (dựa theo hình ảnh)
    logic w;
    logic z;
    logic [3:0] state; // Dùng để quan sát trạng thái (Y)
	 logic [9:0] ledr; //Khai báo mảng 10 bit, để có thể cho z = LEDR9, state = LEDR[3:0]
    
	 assign z = ledr[9];    
	 assign state = ledr[3:0];
	lab2_tn2_binary DUT (
        .KEY(clk),         // Nối tín hiệu clk của testbench vào KEY[0]
        .SW({w, rst}),     // Nối w vào SW[1] và rst vào SW[0]
        .LEDR(ledr)  // Nối ngõ ra z vào LEDR[9] và trạng thái vào LEDR[3:0]
    );

    // Tạo xung Clock (Chu kỳ 10ns -> Tần số 100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    // Khối tạo tín hiệu kích thích (Stimulus)
    initial begin
// 1. Khởi tạo ban đầu
        rst = 1'b1; 		// Kéo rst lên 1 để reset về trạng thái A
        w = 1'b0;
        
        // 2. Kích hoạt Reset (Active-low) ở đầu mô phỏng
        @(negedge clk); // Đợi cạnh xuống của clock
        rst = 1'b0;     
        
        @(negedge clk); 
        rst = 1'b0;     // FSM bắt đầu hoạt động
        
        // 3. w = 0 trong khoảng 2 chu kỳ tiếp theo (tổng là 3 chu kỳ đầu)
        @(negedge clk);
        @(negedge clk);
        
        // 4. w = 1 trong 1 chu kỳ
        w = 1'b1;
        @(negedge clk);
        
        // 5. w = 0 trong 3 chu kỳ
        w = 1'b0;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
	@(negedge clk);
        
        // 6. w = 1 trong 5 chu kỳ liên tiếp
        // Đủ 4 chu kỳ thì z sẽ nhảy lên 1, chu kỳ thứ 5 z vẫn giữ mức 1
        w = 1'b1;
        @(negedge clk); // 1
        @(negedge clk); // 2
        @(negedge clk); // 3
        @(negedge clk); // 4 -> Sau cạnh lên tiếp theo z sẽ = 1
        @(negedge clk); // 5 -> z tiếp tục giữ 1
        
        // 7. w = 0 trở lại, ngắt chuỗi 1 -> z sẽ rớt xuống 0
        w = 1'b0;
        @(negedge clk);
		  rst = 1'b1;     // Kéo rst lên 1
        @(negedge clk);
        rst = 1'b0;     // Máy chạy bth
        @(negedge clk);
        @(negedge clk);
        
        // 8. Test thử reset giữa chừng

        
        // Đợi thêm vài chu kỳ rồi kết thúc mô phỏng
        @(negedge clk);
        @(negedge clk);
        $stop;          // Dừng mô phỏng
    end

endmodule