module sort_ip
	#(
		parameter int DATA_WIDTH = 4, //16
		parameter int LENGTH = 16 //1024
	)
  	(
		input logic clk,
		input logic rst,

		input logic sort_dir,
		input logic ain_tvalid,
		input logic [DATA_WIDTH*2-1:0] ain_tdata,
		input logic ain_tlast,
		input logic aout_tready,

		output logic ain_tready,
		output logic [$clog2(LENGTH)-1:0] dup_nums,
		output logic aout_tvalid,
		
		output logic [DATA_WIDTH*2-1:0] aout_tdata,
		output logic aout_tlast
   );
	logic en, shift_left, token_left_i, set_reg, clear;

	pe_array #(
		.DATA_WIDTH (DATA_WIDTH),
		.LENGTH (LENGTH)
	) 
	pe_array_u (
		.clk (clk),
		.rst (rst),
		.en (en),  
		.sort_dir (sort_dir), 
		.shift_left (shift_left),

		.token_left_i (token_left_i),
		.set_reg (set_reg),
		
		.a_left_i (ain_tdata[DATA_WIDTH-1:0]),
		.b_left_i (ain_tdata[DATA_WIDTH*2-1:DATA_WIDTH]),

		.a_left_o (aout_tdata[DATA_WIDTH-1:0]),
		.b_left_o (aout_tdata[DATA_WIDTH*2-1:DATA_WIDTH]),

		.token_left_o (aout_tlast)
	);

	dup_cnt #(
		.DATA_WIDTH (DATA_WIDTH),
		.LENGTH (LENGTH)
	)
	dup_cnt_u (
		.clk (clk),
		.rst (rst),
		.shift_left (shift_left),
		.a_i (aout_tdata[DATA_WIDTH-1:0]),
		.b_i (aout_tdata[DATA_WIDTH*2-1:DATA_WIDTH]),
		.clear (clear),
		
		.dup_cnt_o(dup_nums)
	);

	fsm #(
		.DATA_WIDTH (DATA_WIDTH),
		.LENGTH (LENGTH)
	)
	fsm_u (
	    .clk (clk),
		.rst (rst),

		.ain_tvalid (ain_tvalid),
		.ain_tlast (ain_tlast),
		.aout_tready (aout_tready),
		.token_i (aout_tlast),
		.sort_dir (sort_dir),

		.ain_tready (ain_tready),
		.aout_tvalid (aout_tvalid),
		.en (en),
		.shift_left (shift_left),
		.token_o (token_left_i),
		.set_reg (set_reg),
		.clear (clear)
	);

endmodule
