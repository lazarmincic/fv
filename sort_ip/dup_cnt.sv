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
    logic en;

    assign pair_equal = (a_i == b_i);
    assign match_inter = (a_i == prev_b) && prev_b_valid;
    assign en = aout_tready && shift_left;

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
		else if (en) begin 
			prev_b <= b_i;
            prev_b_valid <= 1'b1;
            dup_cnt_prev <= dup_cnt_o;
        end
	end

    always_comb begin
        if (clear) begin 
            dup_cnt_o = '0; 
        end else if (shift_left) begin
            dup_cnt_o = dup_cnt_prev + pair_equal + match_inter;
        end else begin
            dup_cnt_o = dup_cnt_prev;
        end
    end
endmodule