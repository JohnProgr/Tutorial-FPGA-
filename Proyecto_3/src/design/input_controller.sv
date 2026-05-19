`timescale 1ns/1ps

module input_controller (
    input  logic       clk,
    input  logic       rst_n,

    input  logic [3:0] key_value_i,
    input  logic       key_valid_i,

    output logic [5:0] dividend_o,
    output logic [3:0] divisor_o,
    output logic       valid_o,

    output logic [5:0] current_value_o,
    output logic       entering_divisor_o
);

    typedef enum logic [1:0] {
        WAIT_DIVIDEND,
        WAIT_DIVISOR
    } state_t;

    state_t state_reg;

    logic [6:0] dividend_temp;
    logic [4:0] divisor_temp;

    logic [6:0] dividend_next;
    logic [4:0] divisor_next;

    logic is_digit;
    logic is_confirm;
    logic is_clear;

    assign is_digit   = (key_value_i <= 4'd9);
    assign is_confirm = (key_value_i == 4'hF); // #
    assign is_clear   = (key_value_i == 4'hE); // *

    assign entering_divisor_o = (state_reg == WAIT_DIVISOR);

    assign current_value_o = (state_reg == WAIT_DIVIDEND)
                            ? dividend_temp[5:0]
                            : {1'b0, divisor_temp};

    always_comb begin
        dividend_next = dividend_temp;
        divisor_next  = divisor_temp;

        if (key_valid_i && is_digit) begin
            case (state_reg)
                WAIT_DIVIDEND: begin
                    dividend_next = (dividend_temp * 7'd10) + key_value_i;
                end

                WAIT_DIVISOR: begin
                    divisor_next = (divisor_temp * 5'd10) + key_value_i;
                end

                default: begin
                    dividend_next = dividend_temp;
                    divisor_next  = divisor_temp;
                end
            endcase
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state_reg     <= WAIT_DIVIDEND;
            dividend_temp <= 7'd0;
            divisor_temp  <= 5'd0;

            dividend_o    <= 6'd0;
            divisor_o     <= 4'd0;
            valid_o       <= 1'b0;
        end else begin
            valid_o <= 1'b0;

            if (key_valid_i) begin
                if (is_clear) begin
                    state_reg     <= WAIT_DIVIDEND;
                    dividend_temp <= 7'd0;
                    divisor_temp  <= 5'd0;

                    dividend_o    <= 6'd0;
                    divisor_o     <= 4'd0;
                    valid_o       <= 1'b0;
                end else begin
                    case (state_reg)
                        WAIT_DIVIDEND: begin
                            if (is_digit) begin
                                if (dividend_next <= 7'd63) begin
                                    dividend_temp <= dividend_next;
                                end
                            end else if (is_confirm) begin
                                state_reg <= WAIT_DIVISOR;
                            end
                        end

                        WAIT_DIVISOR: begin
                            if (is_digit) begin
                                if (divisor_next <= 5'd15) begin
                                    divisor_temp <= divisor_next;
                                end
                            end else if (is_confirm) begin
                                dividend_o <= dividend_temp[5:0];
                                divisor_o  <= divisor_temp[3:0];
                                valid_o    <= 1'b1;

                                state_reg     <= WAIT_DIVIDEND;
                                dividend_temp <= 7'd0;
                                divisor_temp  <= 5'd0;
                            end
                        end

                        default: begin
                            state_reg     <= WAIT_DIVIDEND;
                            dividend_temp <= 7'd0;
                            divisor_temp  <= 5'd0;
                        end
                    endcase
                end
            end
        end
    end

endmodule