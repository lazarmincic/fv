//processing element
module pe (
    input logic clk,
    input logic rst,
    input logic en,
    input logic sort_dir,
    input logic shift_left,
    
    input logic [15:0] a_left_i,
    input logic [15:0] a_right_i,
    input logic [15:0] b_left_i,
    input logic [15:0] b_right_i,
    input logic token_left_i,
    input logic token_right_i,
    input logic set_reg,

    output logic [15:0] a_left_o,
    output logic [15:0] a_right_o,
    output logic [15:0] b_left_o,
    output logic [15:0] b_right_o,
    output logic token_left_o,
    output logic token_right_o
);
    logic [15:0] reg_a;
    logic [15:0] reg_b;

    logic [15:0] next_reg_a;
    logic [15:0] next_reg_b;

    always_comb begin : sort_4_numbers

        logic [15:0] v0, v1, v2, v3; // vrednosti
        logic [15:0] t; // temp
        // podrazumevane
        a_right_o = sort_dir ? '1 : '0; 
        b_right_o = sort_dir ? '1 : '0; 
        a_left_o = 16'b0;
        b_left_o = 16'b0;
        next_reg_a = reg_a;
        next_reg_b = reg_b;
        if (token_left_i && set_reg) begin
            v0 = '1; 
            v1 = '1; 
        end else begin
            v0 = reg_a;
            v1 = reg_b;
        end
        v2 = a_left_i;
        v3 = b_left_i;
        t = '0;

        if (shift_left == 1'b0) begin // u desno
            if (token_left_i || !set_reg) begin
                if (sort_dir) begin 
                    if (v0 > v1) begin 
                        t = v0; 
                        v0 = v1; 
                        v1 = t; 
                    end
                    if (v2 > v3) begin 
                        t = v2; 
                        v2 = v3; 
                        v3 = t; 
                    end
                end else begin      
                    if (v0 < v1) begin 
                        t = v0; 
                        v0 = v1; 
                        v1 = t; 
                    end
                    if (v2 < v3) begin 
                        t = v2; 
                        v2 = v3; 
                        v3 = t; 
                    end
                end

                if (sort_dir) begin 
                    if (v0 > v2) begin 
                        t = v0; 
                        v0 = v2; // min
                        v2 = t; 
                    end 
                    if (v1 > v3) begin 
                        t = v1; 
                        v1 = v3; 
                        v3 = t; // max
                    end
                end else begin 
                    if (v0 < v2) begin 
                        t = v0; 
                        v0 = v2; 
                        v2 = t; 
                    end
                    if (v1 < v3) begin 
                        t = v1; 
                        v1 = v3; 
                        v3 = t; 
                    end
                end

                if (sort_dir) begin
                    if (v1 > v2) begin 
                        t = v1; 
                        v1 = v2; 
                        v2 = t; 
                    end
                end else begin   
                    if (v1 < v2) begin 
                        t = v1; 
                        v1 = v2; 
                        v2 = t; 
                    end
                end
                next_reg_a = v0; 
                next_reg_b = v1; 
                a_right_o = v2; 
                b_right_o = v3; 
            end else begin
                next_reg_a = '1;
                next_reg_b = '1;
            end
        end else begin  // u levo
            next_reg_a = a_right_i; 
            next_reg_b = b_right_i; 
            a_left_o = reg_a;
            b_left_o = reg_b;
        end
    end


    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            reg_a <= '0;
            reg_b <= '0;
            token_left_o <= 1'b0;
            token_right_o <= 1'b0;
        end else if (en) begin
            reg_a <= next_reg_a;
            reg_b <= next_reg_b;
            token_left_o <= 1'b0;
            token_right_o <= 1'b0;
            if (shift_left) begin
                token_left_o <= token_right_i;
            end else begin
                token_right_o <= token_left_i;
            end
        end  
         
    end

endmodule