module lab2_tn2_hot (
    input  logic [1:0] SW,   
    input  logic [0:0] KEY,  
    output logic [9:0] LEDR  
);

    logic clk, rst_n, w, z;
    assign clk   = KEY[0];
    assign rst_n = SW[0]; 
    assign w     = SW[1];

    // Khai báo trạng thái (One-Hot Encoding - Table 1a)
    typedef enum logic [8:0] { 
        A = 9'b000000001,
        B = 9'b000000010,
        C = 9'b000000100,
        D = 9'b000001000,
        E = 9'b000010000,
        F = 9'b000100000,
        G = 9'b001000000,
        H = 9'b010000000,
        I = 9'b100000000
    } state_t;

    state_t present_state, next_state;

    // Thanh ghi trạng thái (Đồng bộ, tích cực mức thấp)
    always_ff @(posedge clk) begin 
        if (!rst_n)
            present_state <= A;
        else
            present_state <= next_state;
    end

    // Logic tổ hợp chuyển trạng thái (Behavioral Style)
// Logic tổ hợp chuyển trạng thái (Behavioral Style)
    always_comb begin
        // Bỏ dòng "next_state = present_state;" đi
        case (present_state)
            A: if (w) next_state = F; else next_state = B;
            B: if (w) next_state = F; else next_state = C;
            C: if (w) next_state = F; else next_state = D;
            D: if (w) next_state = F; else next_state = E;
            E: if (w) next_state = F; else next_state = E;
            F: if (w) next_state = G; else next_state = B;
            G: if (w) next_state = H; else next_state = B;
            H: if (w) next_state = I; else next_state = B;
            I: if (w) next_state = I; else next_state = B;
            default: next_state = A; // Đảm bảo luôn có giá trị trả về
        endcase
    end

    // Logic ngõ ra
    assign z = (present_state == E) || (present_state == I);

    // Xuất tín hiệu ra LED
    assign LEDR[9]   = z;
    assign LEDR[8:0] = present_state; // Mã One-hot dùng 9 LED

endmodule