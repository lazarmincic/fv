module pe_array (
    input logic clk,
    input logic rst,
    input logic en,  
    input logic sort_dir, 
    input logic shift_left,

    input logic token_left_i,
    input logic set_reg,
    
    input logic [15:0] a_left_i,
    input logic [15:0] b_left_i,

    output logic [15:0] a_left_o,
    output logic [15:0] b_left_o,

    output logic token_left_o
);

    logic [15:0] wire_a_lr [0:511]; // lr - left to right smer
    logic [15:0] wire_b_lr [0:511];
    logic [15:0] wire_a_rl [0:511];
    logic [15:0] wire_b_rl [0:511];
    logic wire_token_lr [0:511];
    logic wire_token_rl [0:511];
    
    assign wire_a_lr[0] = a_left_i;
    assign wire_b_lr[0] = b_left_i;
    assign wire_token_lr[0] = token_left_i;

    genvar i;
    generate
        for (i = 0; i < 512; i++) begin : pe_chain
            if (i != 511) begin 
            pe pe (
                    .clk (clk),
                    .rst (rst),
                    .en (en),
                    .sort_dir (sort_dir),
                    .shift_left (shift_left),
                    // sa leva na desno
                    .a_left_i (wire_a_lr[i]),
                    .b_left_i (wire_b_lr[i]),
                    .token_left_i (wire_token_lr[i]),
                    .set_reg (set_reg),
                    
                    .a_right_o (wire_a_lr[i+1]),
                    .b_right_o (wire_b_lr[i+1]),
                    .token_right_o (wire_token_lr[i+1]),
                    // sa desna na levo
                    .a_right_i (wire_a_rl[i+1]),
                    .b_right_i (wire_b_rl[i+1]),
                    .token_right_i (wire_token_rl[i+1]),

                    .a_left_o (wire_a_rl[i]),
                    .b_left_o (wire_b_rl[i]),
                    .token_left_o (wire_token_rl[i])
            );
            end else begin // poslednji
                pe pe (
                    .clk (clk),
                    .rst (rst),
                    .en (en),
                    .sort_dir (sort_dir),
                    .shift_left (shift_left),
                    // sa leva na desno
                    .a_left_i (wire_a_lr[i]),
                    .b_left_i (wire_b_lr[i]),
                    .token_left_i (wire_token_lr[i]),
                    .set_reg (set_reg),
                    
                    .a_right_o (),
                    .b_right_o (),
                    .token_right_o (),
                    // sa desna na levo
                    .a_right_i ('0),
                    .b_right_i ('0),
                    .token_right_i (1'b0),

                    .a_left_o (wire_a_rl[i]),
                    .b_left_o (wire_b_rl[i]),
                    .token_left_o (wire_token_rl[i])
                );
            end
        end
    endgenerate

    assign a_left_o = wire_a_rl[0];
    assign b_left_o = wire_b_rl[0];
    assign token_left_o = wire_token_rl[0];

endmodule