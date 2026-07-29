module v_bb_model_checker 
(
	input CLK, 
	input STALL, 
	input RST, 
	input OPCH, 
	input [3:0] OPS, 
	input TEST,
	input AB,
	input BC,
	input CD,
	input ERR,
	input REQ,
	input ACK,
	input BUSY,
	input DONE,
	input [2:0] DATA
);

	default
	clocking @(posedge CLK);
	endclocking

	default disable iff RST;

	logic signed [3:0] cnt; // uvecavaj kada dodje r, smanjuj kada a
	bit rst_cnt;

	always_ff @(posedge CLK or posedge RST) begin
        if (RST) begin
            cnt <= 4'b0;
			rst_cnt <= 1'b1;
        end else begin
            case ({REQ, ACK})
                2'b10:  
					cnt <= cnt + 1'b1;
                2'b01: 
					cnt <= cnt - 1'b1;
                default: 
					cnt <= cnt;
            endcase
			rst_cnt <= 1'b0;
		end
	end

	assert property (cnt == 5 |=> cnt != 6); 
	assert property (cnt == 5 |=> $stable(cnt) || cnt == 4);
	assert property ($stable(cnt) || cnt == $past(cnt) + 1 || cnt == $past(cnt) - 1);
	// ako se pojavio novi req, mora se pojaviti ack, ili ack i req istovremeno
	a2: assert property (cnt > $past(cnt) |=> s_eventually (cnt <= $past(cnt)));
	//c1: cover property (cnt!=0 ##[+] cnt==0);
	// ako je neg, ack se pojavio sam
	a4: assert property (cnt >= 0); 

	cover property (cnt == 5 && REQ);
	cover property (cnt == 5 ##1 cnt == 5 );
	// max 5 nepotvrdjenih req
	assume property (cnt == 5 |-> ~REQ || ACK); // isto sto i REQ == ACK or !REQ || ACK
	// ack koji odgovara tom req ne moze da se desi u istom taktu
	a7: assert property (REQ |-> (~ACK && cnt == 0) || (cnt > 0));
	assert property (REQ && ACK |-> cnt > 0);
	c2: cover property (ACK ##0 REQ ##0 cnt != 0);

	cover property (BUSY);
	// >1 ili 1 koje u sl ne postaje 0
	a8: assert property (cnt>1 || (cnt==1 && ~ACK)|-> BUSY); 
	// 0 ili ce u sl postati 0
	a9: assert property (cnt==0 || (cnt==1 && ACK)  |-> ~BUSY);

	cover property (DONE);
	assert property (cnt==1 && ACK && ~REQ |-> DONE ##1 ~DONE);

	assert property (DONE |-> $stable (DATA));

	c3: cover property (1[*100]);
	a11: assert property (TEST |=> strong ((AB[*3] ##[3:4] BC[->3:4]) ##[+] CD));  

	assert property (always !ERR);

	assert property (always $onehot0(OPS)); 

	assert property (rst_cnt[->1] |=> always ~rst_cnt); 
	a10: assert property (rst_cnt |-> OPS == 4'b0000); 
	assert property (OPS == 4'b0000 && ~STALL |=> OPS == 4'b0001); // pada
	assert property ((OPS == 4'b0001 && OPCH) && ~STALL |=> OPS == 4'b0010 );
	assert property ((OPS == 4'b0001 && ~OPCH) && ~STALL |=> OPS == 4'b0100 );
	assert property ((OPS == 4'b0010 || OPS == 4'b0100) && ~STALL |=> OPS == 4'b1000 ); // ne prolazi
	assert property (OPS == 4'b1000 && ~STALL |=> OPS == 4'b0000);

	assert property (STALL |=> $stable(OPS));

	cover property (OPS == 4'b0100 ##4 OPS == 4'b0100);

	//cover property (REQ ##1 cnt);
	//cover property (REQ[*1:$] ##1 ~REQ[*1:$] ##1 ~ACK );
	//cover property (cnt===3'b100##[*]cnt===3'b101);
	//cover property (ACK##[+]~ACK);
	
	//cover property (REQ ##[*] ~REQ ##[*] ACK ##[*]REQ);	

endmodule
