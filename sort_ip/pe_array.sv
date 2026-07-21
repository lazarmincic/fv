module pe_array (
    input logic clk,
    input logic rst,
    input logic en,  
    input logic sort_dir, 
    input logic ain_tlast,
    output logic aout_tlast, 

    input logic [15:0] a_i,
    input logic [15:0] b_i,

    output logic [15:0] a_o,
    output logic [15:0] b_o
);

    logic [15:0] wire_1 [0:512];
    logic [15:0] wire_2 [0:512];
    logic wire_last [0:512];

    assign wire_1[0] = a_i;
    assign wire_2[0] = b_i;
    assign wire_last[0] = ain_tlast;

    genvar i;
    generate
        for (i = 0; i < 512; i++) begin : pe_chain
            if (i == 512 - 1) begin
                pe pe (
                    .clk (clk),
                    .rst (rst),
                    .en (en),
                    .sort_dir (sort_dir),
                    
                    .a_i (wire_1[i]),
                    .b_i (wire_2[i]),
                    .last_i (wire_last[i]),
                    
                    .a_o (),
                    .b_o (),
                    .last_o ()
                );
            end
            else begin 
            pe pe (
                .clk (clk),
                .rst (rst),
                .en (en),
                .sort_dir (sort_dir),
                
                .a_i (wire_1[i]),
                .b_i (wire_2[i]),
                .last_i (wire_last[i]),
                
                .a_o (wire_1[i+1]),
                .b_o (wire_2[i+1]),
                .last_o (wire_last[i+1])
            );
            end
        end
    endgenerate

    assign a_o = pe_chain[0].pe.reg_a;
    assign b_o = pe_chain[0].pe.reg_b;
    assign aout_tlast = pe_chain[0].pe.last_o;

endmodule