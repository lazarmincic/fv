module panex #(parameter  S = 2) ( 
	input clk,
	input rst,
	input [1:0] fr,
	input [1:0] to
	) ;

	typedef enum logic [1:0] {
		empty = 2'b00,
		red = 2'b01,
		blue = 2'b10
	} disc_t;
	const bit [1:0] left = 2'b00, middle = 2'b01, right = 2'b10;
	
	typedef struct {
	    disc_t color; // boje i prazno
	    bit [$clog2(S)-1:0] init_pos;
	} Disc;

	// left middle right [s+1] 
	Disc sticks [3][S+1];	// 1 dodatni disk od gore je za premestanje
	bit solved;
	
	bit signed [$clog2(S):0] top_index[3]; // log2 ceiling S bita + 1 signed bit

	//
	always_ff @ (posedge clk) begin
		if (rst) begin
			for (int i = 0; i < S; i = i + 1)
			begin
				sticks[left][i].color <= blue;
				sticks[middle][i].color <= empty;
				sticks[right][i].color <= red;

				sticks[left][i].init_pos <= i; // init_pos - initial position
				sticks[middle][i].init_pos <= i;
				sticks[right][i].init_pos <= i;
			end
			sticks[left][S].color <= empty;
			sticks[middle][S].color <= empty;
			sticks[right][S].color <= empty;

			sticks[left][S].init_pos <= S;
			sticks[middle][S].init_pos <= S;
			sticks[right][S].init_pos <= S;

			top_index[left] <= S-4'sb1;
			top_index[right] <= S-4'sb1;
			top_index[middle] <= -4'sb1;
		end else if (!solved) begin 
			if(sticks[fr][top_index[fr]].init_pos >= top_index[to]+4'sb1) begin // promenio sam <= u >= ovde POSLEDNJE
				sticks[to][top_index[to]+4'sb1] <= sticks[fr][top_index[fr]];
				sticks[fr][top_index[fr]].color <= empty;
				top_index[to] <= top_index[to] + 4'sb1;	
			end else begin
				sticks[to][sticks[fr][top_index[fr]].init_pos] <= sticks[fr][top_index[fr]];
				sticks[fr][top_index[fr]].color <= empty;
				top_index[to] <= sticks[fr][top_index[fr]].init_pos;
			end

			top_index[fr] <= -1;
			for (int i = 0; i< S ; i=i+1) begin
				if (sticks[fr][i].color != empty && i < top_index[fr]) begin
					top_index[fr] <= i;
				end
			end
		end
	end

	
	always_comb @(posedge clk) begin
		solved = 1'b1;
		for (int i=0;i<=S;i=i+1) begin
			if (i != S) begin
				if (sticks[left][i].color != red)
					solved = 1'b0;
				if (sticks[middle][i].color != empty)
					solved = 1'b0;
				if (sticks[right][i].color != blue)
					solved = 1'b0;
			end else begin
				if (sticks[left][i].color != empty || 
					sticks[middle][i].color != empty ||
					sticks[right][i].color != empty)
					solved = 1'b0;
			end
		end
	end

    default clocking
        @(posedge clk);
    endclocking

    default disable iff (rst);

	//assume da se 11 od fr i to ne koriste
	assume property (to != 2'b11);
	assume property (fr != 2'b11);
	//kraj, resenje - cover tacka sa obrnute dve kule
	cover property (solved == 1'b1);
	//cover property ((fr==0 ##1 fr==0 ##1 fr==1 ##1 fr==0) and (to==2 ##1 to==1 ##1 to==0 ##1 to==1)); sanity check 1 - radi
	assume property (fr!=to);
	//assume da se ne moze prebacivati sa praznog stapa
	assume property (top_index[fr] >=4'sb0 && top_index[to]<S);
	// srednji stap sme da bude pun do vrha jedino ako se prebacuje sa njega
	assume property (top_index[middle]<S || fr==1); 
	// gore u sredinu ne moze da se stavi disk
	assume property ((~(to==1)) || top_index[to]<S-1);
	//cover property (top_index[middle]==1); SANITY CHECK 2 - RADI
	
	// kada se resi dalje ne diraj nista
	assert property (solved |=> $stable(sticks) && $stable(top_index));


endmodule

// boje i fukcionalnost kao u https://www.jaapsch.net/puzzles/panex.htm
