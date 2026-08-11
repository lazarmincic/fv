module dup_cnt 
#(
    parameter int DATA_WIDTH = 16,
    parameter int LENGTH = 1024
)
(
    input logic clk,
    input logic rst,
    input logic shift_left,
    input logic aout_tready,
    input logic [DATA_WIDTH-1:0] a_i,
    input logic [DATA_WIDTH-1:0] b_i,
    input logic clear,

    output logic [$clog2(LENGTH)-1:0] dup_cnt_o // log2(1024)
);

    logic [DATA_WIDTH-1:0] prev_b;
    logic match_inter;
    logic prev_b_valid;
    logic pair_equal;
    logic [$clog2(LENGTH)-1:0] dup_cnt_prev;

    assign pair_equal = (a_i == b_i);
    assign match_inter = (a_i == prev_b) && prev_b_valid;

    always_ff @(posedge clk or posedge rst) begin
		if (rst) begin
			prev_b <= '0;
            prev_b_valid <= 1'b0;
            dup_cnt_prev <= 1'b0;
        end else if (clear) begin
			prev_b <= '0;
            prev_b_valid <= 1'b0;
            dup_cnt_prev <= 1'b0;
        end
		else if (shift_left) begin 
			prev_b <= b_i;
            if (!prev_b_valid) begin
                prev_b_valid = 1'b1;
            end
            dup_cnt_prev <= dup_cnt_o;
		end
	end

    always_comb begin
        dup_cnt_o  <= '0;
        if (clear) begin 
            dup_cnt_o  <= '0; 
        end else begin
            if (shift_left && aout_tready) begin
                dup_cnt_o  <= dup_cnt_prev + pair_equal + match_inter;
            end
        end
    end
endmodule