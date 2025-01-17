module panex #(parameter  S = 4) ( //max 15
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
/*
	disc_t stick_left [S+1] ;
	disc_t stick_middle [S+1] ;
	disc_t stick_right [S+1] ;
*/
	
	typedef struct {
	    disc_t color; // boje i prazno
	    bit [3:0] size;
	} Disc;

	Disc sticks [3][S+1];	// middle right][s+1] (bivse array_of_sticks)
	bit solved;
	
	bit signed [4:0] top_index[3]; // 4 bita jer je S max 15 + 1 signed bit


	always_ff @ (posedge clk) 
	begin
	if (rst)
		begin
			for (int i = 0; i < S; i = i + 1)
			begin
				sticks[left][i].color <= blue;
				sticks[middle][i].color <= empty;
				sticks[right][i].color <= red;

				sticks[left][i].size <= i; // size - initial position
				sticks[middle][i].size <= i;
				sticks[right][i].size <= i;
			end
			sticks[left][S].color <= empty;
			sticks[middle][S].color <= empty;
			sticks[right][S].color <= empty;

			sticks[left][S].size <= S;
			sticks[middle][S].size <= S;
			sticks[right][S].size <= S;

			top_index[left] <= S-4'sb1;
			top_index[right] <= S-4'sb1;
			top_index[middle] <= -4'sb1;
		end
	else
		begin 
			if (fr != to && (fr!=3 && to!=3))
			begin
				
				if (top_index[fr] >=4'sb0 && top_index[to]<S)
				begin
					//if (top_index[middle]<S || fr==1) // moze
					if ((~(to==1)) || top_index[to]<S-1) // gore u sredinu ne moze da se stavi disk
					begin
						if(sticks[fr][top_index[fr]].size <= top_index[to]+4'sb1)
						begin
							sticks[to][top_index[to]+4'sb1] <= sticks[fr][top_index[fr]];
							sticks[fr][top_index[fr]].color <= empty;
							top_index[to] <= top_index[to] + 4'sb1;	
						end
						else 
						begin
							sticks[to][sticks[fr][top_index[fr]].size] <= sticks[fr][top_index[fr]];
							sticks[fr][top_index[fr]].color <= empty;
							top_index[to] <= sticks[fr][top_index[fr]].size;
						end
	
						top_index[fr] <= -1;
						for (int i = 0; i< S ; i=i+1) 
						begin
							if (sticks[fr][i].color != empty && i < top_index[fr])  
							begin
								top_index[fr] <= i;
							end
						end
						
					end
				end
			end
		end
	end
/*
	always_comb
	begin
		
	end
*/
/*
	always_ff @ (posedge clk)
		begin
			if (rst)
			begin
				solved <= 1'b0;
			end
			else
			begin
			    solved <= 1'b1;
			    for (int i=0;i<S;i=i+1)
			    begin
				if (sticks[left][i].color != red)
				    solved <= 1'b0;
				if (sticks[middle][i].color != empty)
				    solved <= 1'b0;
				if (sticks[right][i].color != blue)
				    solved <= 1'b0;
				
			    end
			end
		end
*/
    default clocking
        @(posedge clk);
    endclocking

    default disable iff (rst);

	//assert property ();
	//assume da se 11 od fr i to ne koriste --
	//assume da se ne moze prebacivati sa praznog stapa

	//kraj, resenje - cover tacka sa obrnute dve kule
	assume property (to != 2'b11);
	assume property (fr != 2'b11);
	//cover property (solved == 1'b1);
	//cover property ((fr==0 ##1 fr==0 ##1 fr==1 ##1 fr==0) and (to==2 ##1 to==1 ##1 to==0 ##1 to==1)); sanity check 1 - radi
	assume property (fr!=to);
	assume property (top_index[fr] >=4'sb0 && top_index[to]<S);
	//assume property (top_index[middle]<S || fr==1);
	assume property ((~(to==1)) || top_index[to]<S-1);
	//cover property (top_index[middle]==1); SANITY CHECK 2 - RADI

	//vidi koje je najbrze pronadjeno resenje za 4 diska na netu

	//function bit all_elements

endmodule




// boje i fukcionalnost kao u https://www.jaapsch.net/puzzles/panex.htm
