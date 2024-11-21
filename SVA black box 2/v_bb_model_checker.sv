module v_bb_model_checker (
	input CLK, input STALL, input RST, input OPCH, input [3:0] OPS, input TEST,input AB,input BC,
	input CD,input ERR,input REQ,input ACK,input BUSY,input DONE,input [2:0] DATA
	) ;

	default
	clocking @(posedge CLK);
	endclocking

	default disable iff RST;

	logic [6:0] count;

	logic signed [3:0] brojac,brojac_sl; // uvecavaj kada dodje r, smanjuj a
	
	//logic req_d, ack_d; //zakasnjen 
	// Broji ivice
/*	always_ff @(posedge CLK or posedge RST) begin //na ivice
		if (RST) begin
		    req_d <= 1'b0;
		    ack_d <= 1'b0;
		end else begin
		    req_d <= REQ; 
		    ack_d <= ACK;
		end
    	end

	always_ff @(posedge CLK or posedge RST) begin
		if (RST) 
		    brojac <= 3'b000; // Reset counter to 0
		else begin  // Detect rising edges
		    logic req_rising = REQ && !req_d;
		    logic ack_rising = ACK && !ack_d;
		    
		    case ({req_rising, ack_rising})
		        2'b10: brojac <= brojac + 1'b1;  // Only REQ rising edge
		        2'b01: brojac <= brojac - 1'b1;  // Only ACK rising edge
		        2'b11: ; // Both REQ and ACK rising edges, counter unchanged
		        default: brojac <= brojac; // No change
		    endcase
		end
    	end */
 // Broji vrednosti
	always_ff @(posedge CLK or posedge RST) begin
        if (RST) begin
            brojac <= 4'b0; // Reset counter to 0
        end else begin
            // Handle cases based on the status of REQ and ACK
            case ({REQ, ACK})
                2'b10: brojac <= brojac + 1'b1; // Only REQ is high, increment count
                2'b01: brojac <= brojac - 1'b1; // Only ACK is high, decrement count
                default: brojac <= brojac;        // Both REQ and ACK are high/low, no change 
            endcase
            end
    	end


	a1: assume property (REQ |=> ~REQ); //ne valja!! proizvonjii proj ciklusa da bude nula
	a2: assert property (brojac!=4'sb0000 |-> ##[+] brojac==4'sb0000); //1
	// s_eventually i ##[+] razlika?
	a3: assert property (brojac != 0 |=> s_eventually brojac== 0); //2 dec brojevi
	c1: cover property (brojac!=4'sb0000 ##[+] brojac==4'sb0000);
	a4: assert property (brojac >= 4'sb0000); // ako je neg, ack se pojavio sam
	a5: assert property (brojac == 4'sb0110 |-> ACK or brojac <= 4'sb101); 
	a7: assert property (REQ && brojac==4'sb0000 |-> ~ACK);
	c2: cover property (ACK ##0 REQ ##0 brojac != 4'b0);
	a6: assert property (ACK ##0 REQ |-> brojac > 4'sb0000);

	a8: assert property (brojac>4'sb0001 || (brojac==4'sb0001 && ~ACK)|-> BUSY); 
	a9: assert property (brojac==4'sb0000 || brojac==4'sb0001 && ACK  |-> ~BUSY);

	cover property (DONE);
	assert property (brojac==4'sb0001 && ACK && ~REQ |-> DONE ##1 ~DONE);

	assert property (~DONE ##1 DONE |-> $stable (DATA));

	assert property (TEST |=> AB[*3] ##[3:4] BC[=3:4] ##[+] CD );

	assert property (!ERR);

	assert property (OPS == 4'd0 || OPS == 4'd1 || OPS == 4'd2 || OPS == 4'd4 || OPS == 4'd8);

	assert property (RST |=> OPS == 4'b0000); //ne mora ovo
	assert property (OPS == 4'b0000 |=> OPS == 4'b0001);
	assert property (OPS == 4'b0001 && OPCH |=> OPS == 4'b0010 );
	assert property (OPS == 4'b0001 && ~OPCH |=> OPS == 4'b0100 );
	assert property (OPS == 4'b0010 || OPS == 4'b0100 |=> OPS == 4'b1000 );
	assert property (OPS == 4'b1000 |=> OPS == 4'b0000);

	assert property (STALL |=> not $changed (OPS));

	cover property (OPS == 4'b0100 ##4 OPS == 4'b0100);

	//cover property (REQ ##1 brojac);
	//cover property (REQ[*1:$] ##1 ~REQ[*1:$] ##1 ~ACK );
	//cover property (brojac===3'b100##[*]brojac===3'b101);
	//cover property (ACK##[+]~ACK);
	
	//cover property (REQ ##[*] ~REQ ##[*] ACK ##[*]REQ);	

endmodule //|_'
