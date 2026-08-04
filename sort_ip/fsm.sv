// set reg  se desava u prelazu izmedju idle i slanje

module fsm (
    input logic clk,
    input logic rst,

    input logic ain_tvalid,
    input logic ain_tlast,
    input logic aout_tready,
    input logic token_i,
    input logic sort_dir,

    output logic ain_tready,
    output logic aout_tvalid,
    output logic en,
    output logic shift_left,
    output logic token_o,
    output logic set_reg,
    output logic clear
);

    logic token_sent;

    typedef enum logic [1:0] {
        IDLE = 2'b00, 
        PRIJEM = 2'b01,
        SLANJE = 2'b10 
    } state_t;

    state_t current_state, next_state;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= IDLE;
            token_sent <= 1'b0;
        end else begin
            current_state <= next_state;
            if (current_state == IDLE) begin
                token_sent <= 1'b0; 
            end else if (current_state == PRIJEM && ain_tvalid && !token_sent) begin
                token_sent <= 1'b1;
            end
        end
    end

    always_comb begin
        next_state = current_state;
        set_reg = 1'b0;
        clear = 1'b0;
        case (current_state)
            IDLE: begin
                if (ain_tvalid) begin
                    next_state = PRIJEM;
                    if (sort_dir) 
                        set_reg = 1'b1;
                    
                end
            end
            PRIJEM: begin
                if (ain_tvalid && ain_tready && ain_tlast) begin
                    next_state = SLANJE;
                    clear = 1'b1;
                end
            end

            SLANJE: begin
                if (aout_tvalid && aout_tready && token_i) begin
                    next_state = IDLE;
                end
            end

            default: next_state = IDLE;
        endcase
    end

    always_comb begin
        ain_tready = 1'b0;
        aout_tvalid = 1'b0;
        en = 1'b0;
        shift_left = 1'b0;
        token_o = 1'b0;

        case (current_state)
            IDLE: begin
                ain_tready = 1'b0; 
            end
            
            PRIJEM: begin
                ain_tready = 1'b1;
                if (ain_tvalid && ain_tready) begin
                    en = 1'b1;
                    if (!token_sent) begin
                        token_o = 1'b1; // puls
                        
                    end
                end
            end

            SLANJE: begin
                aout_tvalid = 1'b1; 
                if (aout_tvalid && aout_tready) begin
                    en = 1'b1;
                    shift_left = 1'b1;
                end
            end

            default: ;
        endcase
    end

endmodule