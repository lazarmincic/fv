//processing element
module pe (
    input logic clk,
    input logic rst,
    input logic en,
    input logic sort_dir,
    
    input logic [15:0] a_i,
    input logic [15:0] b_i,
    input logic last_i,
    output logic [15:0] a_o,
    output logic [15:0] b_o
    output logic last_o
);
    logic [15:0] reg_a;
    logic [15:0] reg_b;

    logic [15:0] next_reg_a;
    logic [15:0] next_reg_b;

    always_comb begin : sort_4_numbers
        logic [15:0] v0, v1, v2, v3; // vrednosti
        logic [15:0] t; // temp

        v0 = reg_a;
        v1 = reg_b;
        v2 = a_i;
        v3 = b_i;

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
        a_o = v2; 
        b_o = v3; 
    end

    always_ff @(posedge clk or posedge rst_n) begin
        if (rst) begin
            reg_a <= '0;
            reg_b <= '0;
            last_o <= 1'b0;
        end else if (en) begin
            reg_a <= next_reg_a;
            reg_b <= next_reg_b;
            last_o <= last_i;
        end
    end

endmodule