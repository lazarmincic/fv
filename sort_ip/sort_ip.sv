module sort_ip
  (
		input logic clk,
		input logic rst,

		input logic sort_dir,
		input logic ain_tvalid,
		output logic ain_tready,
		input logic [31:0] ain_tdata,
		input logic ain_tlast,

		output logic dup_nums,
		output logic aout_tvalid,
		input logic aout_tready,
		output logic [31:0] aout_tdata,
		output logic aout_tlast
   );
	logic [9:0] dup_count; // log2(1024)
	logic en;

	/* brojanje duplikata, skica
    always_ff @(posedge clk or posedge rst_n) begin
		if (rst) begin
			dup_count  <= '0;
			prev_out_2 <= '0;
		end 
		else if (transmit_valid) begin 
			dup_count  <= dup_count + pair_equal + match_inter;
			prev_out_2 <= out_2;
		end
	end
	*/
endmodule
