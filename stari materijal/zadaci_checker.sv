module zadaci_checker (
		input clk, input rst,
        input rt_1,input rdy_1,input start_1,input endd_1,
		input er_2,
		input er_3,input rdy_3,
		input rdy_4,input start_4,
		input endd_5,input stop_5,input er_5,input rdy_5,input start_5,
		input endd_6,input stop_6,input er_6,input rdy_6,
		input endd_7,input start_7,input status_valid_7,input instartsv_7,
		input rt_8,input enable_8,
		input rdy_9,input start_9,input interrupt_9,
		input ack_10,input req_10
	) ;


	default
	clocking @(posedge clk);
	endclocking
	
	default disable iff (rst);

	
	logic rt_1_pao; // pre nego sto padne rt_1 0, nakon sto padne 1
	logic prvi_ciklus; // prvi ciklus 1, ostali 0
	logic [2:0] brojac;

	
	always_ff @(posedge clk or posedge rst)
	begin
		 if (rst)
			brojac <= 3'b000;
		 else if(brojac!=3'b111)
			brojac <= brojac + 3'b001;
		 else
			brojac <= 3'b111;

		 if (brojac < 3'b100)
			rt_1_pao <= 1'b0;
		 else
			rt_1_pao <= 1'b1;
	end
	 
	assign prvi_ciklus = brojac==3'b000;
	
	zad_1a: assert property (prvi_ciklus |-> rt_1);

	//cover property (prvi_ciklus##1~prvi_ciklus);
	//pada: cover property (rt_1_pao ##1 ~rt_1_pao);
	//raste: cover property (~rt_1_pao ##1 rt_1_pao);
	//cover property (brojac==3'b011 ##1 brojac==3'b100);

	zad_1b: assert property ((~rt_1_pao) |-> (rt_1 && ~rdy_1 && ~start_1 && ~endd_1));

	zad_2: assert property (er_2[*3:$]|=> ~er_2 );

	zad_3: assert property ((er_3 ##0 rdy_3)|-> ((er_3 ##1 ~er_3) or (rdy_3 ##1 ~rdy_3)));
	
	zad_4: assert property (start_4 |-> ##[1:$] rdy_4);
	
	zad_5: assert property ((endd_5 || stop_5 || er_5) |-> (rdy_5 ##1 ~rdy_5));

	zad_6a: assert property (endd_6 |-> rdy_6);
	zad_6b: assert property (stop_6 |-> rdy_6);
	zad_6c: assert property (er_6 |-> rdy_6);

	zad_7: assert property ( endd_7 |-> (~start_7 && ~status_valid_7) );

	zad_8a: assert property (rt_8 |-> ~enable_8);
	zad_8b: assert property (rt_8 ##1 ~rt_8 |-> ##[3:$] enable_8);

	zad_9a: assert property (interrupt_9 |-> rdy_9 ##1 ~rdy_9 );
	zad_9b: assert property (interrupt_9 |-> start_9 ##1 ~start_9);
	
	zad_10: assert property (req_10 |-> ##5 ack_10);

endmodule
