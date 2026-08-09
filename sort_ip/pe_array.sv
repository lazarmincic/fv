module pe_array 
#(  parameter int DATA_WIDTH = 16,
    parameter int LENGTH = 1024
)
(
    input logic clk,
    input logic rst,
    input logic en,  
    input logic sort_dir, 
    input logic shift_left,

    input logic token_left_i,
    input logic set_reg,
    
    input logic [DATA_WIDTH-1:0] a_left_i,
    input logic [DATA_WIDTH-1:0] b_left_i,

    output logic [DATA_WIDTH-1:0] a_left_o,
    output logic [DATA_WIDTH-1:0] b_left_o,

    output logic token_left_o
);

    wire [DATA_WIDTH-1:0] wire_a_lr [0:LENGTH/2-1]; // lr - left to right smer
    wire [DATA_WIDTH-1:0] wire_b_lr [0:LENGTH/2-1];
    wire [DATA_WIDTH-1:0] wire_a_rl [0:LENGTH/2-1];
    wire [DATA_WIDTH-1:0] wire_b_rl [0:LENGTH/2-1];
    wire wire_token_lr [0:LENGTH/2];
    wire wire_token_rl [0:LENGTH/2];
    
    assign wire_a_lr[0] = a_left_i;
    assign wire_b_lr[0] = b_left_i;
    assign wire_token_lr[0] = token_left_i;

    genvar i;
    generate
        for (i = 0; i < LENGTH/2; i++) begin : pe_chain
            if (i != LENGTH/2-1) begin 
            pe #(
                .DATA_WIDTH (DATA_WIDTH),
                .LENGTH (LENGTH)
                ) 
            pe_u (
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
                pe #(
                    .DATA_WIDTH (DATA_WIDTH),
                    .LENGTH (LENGTH)
                    ) 
                pe_u (
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
                    .token_right_o (wire_token_lr[i+1]),
                    // sa desna na levo
                    .a_right_i ('0),
                    .b_right_i ('0),
                    .token_right_i (wire_token_rl[i+1]),

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
    assign wire_token_rl [LENGTH/2] = wire_token_lr [LENGTH/2];

endmodule