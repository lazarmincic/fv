// boje i fukcionalnost kao u https://www.jaapsch.net/puzzles/panex.htm
// S = 3 14s traje sa Tri endzinom 
// S = 4 3s sa J endzinom
// S = 5 ?

module panex #(parameter int S = 2) ( 
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
	    bit [$clog2(S+1)-1:0] init_pos;
	} Disc;

	// left middle right [s+1] 
	Disc sticks [3][S+1];	// 1 dodatni disk od gore je za premestanje
	bit solved;
	
	bit signed [$clog2(S+1):0] top_index[3]; // adresira s+1 i 1 bit za znak

	function automatic logic [$clog2(S+1)-1:0] drop_msb (input logic signed [$clog2(S+1):0] in);
    	return in[$clog2(S+1)-1 : 0];
	endfunction
	//
	always_ff @ (posedge clk) begin
		if (rst) begin
			for (int i = 0; i <= S; i = i + 1)
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

			top_index[left] <= S-1;
			top_index[right] <= S-1;
			top_index[middle] <= -1;

		end else if (!solved) begin 
			if(sticks[fr][drop_msb(top_index[fr])].init_pos <= top_index[to]+1'b1) begin 
				// nema zabrane
				sticks[to][drop_msb(top_index[to]+1'b1)] <= sticks[fr][drop_msb(top_index[fr])];
				sticks[fr][drop_msb(top_index[fr])].color <= empty;
				top_index[to] <= top_index[to] + 1'b1;	
			end else begin
				// zabrana propadanja
				sticks[to][sticks[fr][drop_msb(top_index[fr])].init_pos] <= sticks[fr][drop_msb(top_index[fr])];
				sticks[fr][drop_msb(top_index[fr])].color <= empty;
				top_index[to] <= sticks[fr][drop_msb(top_index[fr])].init_pos;
			end

			top_index[fr] <= -1;
			for (int i = 0; i <= S ; i=i+1) begin
				if (sticks[fr][i].color != empty && i < top_index[fr]) begin
					top_index[fr] <= i;
				end
			end
		end
	end
	
	always_comb begin
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
	cover_solved: cover property (solved == 1'b1);
	//cover property ((fr==0 ##1 fr==0 ##1 fr==1 ##1 fr==0) and (to==2 ##1 to==1 ##1 to==0 ##1 to==1)); sanity check 1 - radi
	assume property (fr!=to);
	//assume da se ne moze prebacivati sa praznog stapa, ne moze se prebaciti na pun
	assume property (top_index[fr] >=4'sb0 && (top_index[to]<S));
	assert property (top_index[middle] < S && sticks[middle][S].color == empty);
	// gore u sredinu ne moze da se stavi disk
	assume property (to == middle |-> top_index[to]<S-1);
	//cover property (top_index[middle]==1); SANITY CHECK 2 - RADI
	
	// kada se resi dalje ne diraj nista
	assert property (solved |=> $stable(sticks) && $stable(top_index));
	assume property (solved |-> $stable(fr) && $stable(to));
	//assert property (); // ne sme da se desi da se indeksira negativan disk
	cover property (1[*10]);
	// ako si prebacio sa jednog na drugi, ne prebacuj sledece sa drugog na prvi
	// spreci A->B->A
	assume property (!(fr == $past(to) && to == $past(fr)));
	assume property (top_index[fr] >= 0);
	// spreci A->B->C (nateraj ga da uradi A->C)
	assume property (!(fr == $past(to) && $past(fr) == $past(to,2) && to == $past(fr,2)));
	// zabrani uzastopno pomeranje istog diska
	assume property (!(fr == $past(to)));
	// ogranici ekvivalentne poteze TODO
	// A-B isto sto i A-C premestas jedan disk, pa drugi, i rezultat je isti
	//assume property (can_move_from_0_to_1 && can_move_from_2_to_1 && is_independent) |-> (fr != 2);

endmodule


