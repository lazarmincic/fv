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

    always_ff @(posedge clk or posedge rst)
	begin
		
	end

    always_comb
	begin
		
	end

endmodule
