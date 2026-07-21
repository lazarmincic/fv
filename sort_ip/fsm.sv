module fsm (
    input logic clk,
    input logic rst,

    input logic ain_tvalid,
    output logic ain_tready,
    input logic ain_tlast,

    output logic aout_tvalid,
    input logic aout_tready,
    
    input logic pe_token,
    output logic en
);

    typedef enum logic [1:0] {
        IDLE = 2'b00, 
        RECEIVE = 2'b01,
        TRANSMIT = 2'b10 
    } state_t;

    state_t current_state, next_state;

    always_ff @(posedge clk or posedge rst_n) begin
        if (rst_n) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    always_comb begin
        next_state = current_state;
        case (current_state)
            IDLE: begin
                if (ain_tvalid) begin
                    next_state = RECEIVE;
                end
            end
            RECEIVE: begin
                if (ain_tvalid && ain_tready && ain_tlast) begin
                    next_state = TRANSMIT;
                end
            end

            TRANSMIT: begin
                if (aout_tvalid && aout_tready && pe_token) begin
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

        case (current_state)
            RECEIVE: begin
                ain_tready = 1'b1;
                if (ain_tvalid && ain_tready) begin
                    en = 1'b1;
                end
            end

            TRANSMIT: begin
                aout_tvalid = 1'b1; 
                if (aout_tvalid && aout_tready) begin
                    en = 1'b1;
                end
            end

            default: ;
        endcase
    end

endmodule