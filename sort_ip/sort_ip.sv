module sort_ip
  	(
		input logic clk,
		input logic rst,

		input logic sort_dir,
		input logic ain_tvalid,
		input logic [31:0] ain_tdata,
		input logic ain_tlast,
		input logic aout_tready,

		output logic ain_tready,
		output logic [9:0] dup_nums,
		output logic aout_tvalid,
		
		output logic [31:0] aout_tdata,
		output logic aout_tlast
   );
	logic en, shift_left, token_left_i, set_reg;

	pe_array pe_array_u (
		.clk (clk),
		.rst (rst),
		.en (en),  
		.sort_dir (sort_dir), 
		.shift_left (shift_left),

		.token_left_i (token_left_i),
		.set_reg (set_reg),
		
		.a_left_i (ain_tdata[15:0]),
		.b_left_i (ain_tdata[31:16]),

		.a_left_o (aout_tdata[15:0]),
		.b_left_o (aout_tdata[31:16]),

		.token_left_o (aout_tlast)
	);

	dup_cnt dup_cnt_u (
		.clk (clk),
		.rst (rst),
		.shift_left (shift_left),
		.a_i (aout_tdata[15:0]),
		.b_i (aout_tdata[31:16]),
		
		.dup_cnt_o(dup_nums)
	);

	fsm fsm_u (
	    .clk (clk),
		.rst (rst),

		.ain_tvalid (ain_tvalid),
		.ain_tlast (ain_tlast),
		.aout_tready (aout_tready),
		.token_i (aout_tlast),

		.ain_tready (ain_tready),
		.aout_tvalid (aout_tvalid),
		.en (en),
		.shift_left (shift_left),
		.token_o (token_left_i),
		.set_reg (set_reg)
	);

endmodule
