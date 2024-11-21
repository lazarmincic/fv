module sv_model_checker (
    input clk,
    input rst,
    input [1023:0] x,
    input [1023:0] y
	) ;

	default
	clocking @(posedge clk);
	endclocking

	default disable iff rst;

	a1: assert property (y[0] |=> ~y[0]);
	a2: assert property (y[2][=1:$]);
	a3: assert property ((y[1] ##1 y[3][*1:$] ##1 ~y[3])|->y[4]);
	a4: assert property (y[2]##1 y[5]|=>y[6]);
	a5: assert property (~y[2][*3]|->y[7]);
	a6: assert property (y[8][*2:3]|=>(~y[9] ##1 y[10]));
	a7: assert property ((y[0]|=> y[1])or(y[0]|=>y[11]));
	a8: assert property ((y[2]##1~y[2][*1:$]##1 y[2]) |=> y[16]); 
	a9: assert property ((y[28:17]==12'hFFF)[->3] |=> y[15]);
	c10: cover property (y[29][*10]);
	a_11_1: assert property (y[31:30]!=2'b11);
	//a_11_2: assume property (x[1]^x[0]);
	//cover property (y[31:30]==2'b11);

endmodule
