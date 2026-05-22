`timescale 1ns/1ps

module divider_pipeline (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       valid_i,
    input  logic [5:0] dividend_i,
    input  logic [3:0] divisor_i,

    output logic [5:0] quotient_o,
    output logic [3:0] remainder_o,
    output logic       div_zero_o,
    output logic       done_o
);

    // Señales combinacionales por etapa
    logic [4:0] divisor_ext;

    logic [4:0] rem_shift_5, rem_shift_4, rem_shift_3;
    logic [4:0] rem_shift_2, rem_shift_1, rem_shift_0;

    logic [4:0] rem_next_5, rem_next_4, rem_next_3;
    logic [4:0] rem_next_2, rem_next_1, rem_next_0;

    logic [4:0] diff_5, diff_4, diff_3;
    logic [4:0] diff_2, diff_1, diff_0;

    logic q5_comb, q4_comb, q3_comb;
    logic q2_comb, q1_comb, q0_comb;

    logic cout_5, cout_4, cout_3;
    logic cout_2, cout_1, cout_0;

    assign divisor_ext = {1'b0, divisor_i};

    // =========================
    // Registros entre etapas
    // =========================

    logic valid_s5, valid_s4, valid_s3;
    logic valid_s2, valid_s1;

    logic [5:0] dividend_s5, dividend_s4, dividend_s3;
    logic [5:0] dividend_s2, dividend_s1;

    logic [4:0] divisor_s5, divisor_s4, divisor_s3;
    logic [4:0] divisor_s2, divisor_s1;

    logic div_zero_s5, div_zero_s4, div_zero_s3;
    logic div_zero_s2, div_zero_s1;

    logic [4:0] rem_s5, rem_s4, rem_s3;
    logic [4:0] rem_s2, rem_s1;

    logic q5_s5;

    logic q5_s4, q4_s4;

    logic q5_s3, q4_s3, q3_s3;

    logic q5_s2, q4_s2, q3_s2, q2_s2;

    logic q5_s1, q4_s1, q3_s1, q2_s1, q1_s1;

    // =========================
    // Etapa 5
    // =========================

    assign rem_shift_5 = {4'b0000, dividend_i[5]};

    divider_stage #(
        .WIDTH(5)
    ) stage_5 (
        .r_i      (rem_shift_5),
        .b_i      (divisor_ext),
        .diff_o   (diff_5),
        .r_next_o (rem_next_5),
        .q_bit_o  (q5_comb),
        .cout_o   (cout_5)
    );

    // =========================
    // Etapa 4
    // =========================

    assign rem_shift_4 = {rem_s5[3:0], dividend_s5[4]};

    divider_stage #(
        .WIDTH(5)
    ) stage_4 (
        .r_i      (rem_shift_4),
        .b_i      (divisor_s5),
        .diff_o   (diff_4),
        .r_next_o (rem_next_4),
        .q_bit_o  (q4_comb),
        .cout_o   (cout_4)
    );

    // =========================
    // Etapa 3
    // =========================

    assign rem_shift_3 = {rem_s4[3:0], dividend_s4[3]};

    divider_stage #(
        .WIDTH(5)
    ) stage_3 (
        .r_i      (rem_shift_3),
        .b_i      (divisor_s4),
        .diff_o   (diff_3),
        .r_next_o (rem_next_3),
        .q_bit_o  (q3_comb),
        .cout_o   (cout_3)
    );

    // =========================
    // Etapa 2
    // =========================

    assign rem_shift_2 = {rem_s3[3:0], dividend_s3[2]};

    divider_stage #(
        .WIDTH(5)
    ) stage_2 (
        .r_i      (rem_shift_2),
        .b_i      (divisor_s3),
        .diff_o   (diff_2),
        .r_next_o (rem_next_2),
        .q_bit_o  (q2_comb),
        .cout_o   (cout_2)
    );

    // =========================
    // Etapa 1
    // =========================

    assign rem_shift_1 = {rem_s2[3:0], dividend_s2[1]};

    divider_stage #(
        .WIDTH(5)
    ) stage_1 (
        .r_i      (rem_shift_1),
        .b_i      (divisor_s2),
        .diff_o   (diff_1),
        .r_next_o (rem_next_1),
        .q_bit_o  (q1_comb),
        .cout_o   (cout_1)
    );

    // =========================
    // Etapa 0
    // =========================

    assign rem_shift_0 = {rem_s1[3:0], dividend_s1[0]};

    divider_stage #(
        .WIDTH(5)
    ) stage_0 (
        .r_i      (rem_shift_0),
        .b_i      (divisor_s1),
        .diff_o   (diff_0),
        .r_next_o (rem_next_0),
        .q_bit_o  (q0_comb),
        .cout_o   (cout_0)
    );

    // =========================
    // Registros del pipeline
    // =========================

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_s5 <= 1'b0;
            valid_s4 <= 1'b0;
            valid_s3 <= 1'b0;
            valid_s2 <= 1'b0;
            valid_s1 <= 1'b0;

            dividend_s5 <= 6'd0;
            dividend_s4 <= 6'd0;
            dividend_s3 <= 6'd0;
            dividend_s2 <= 6'd0;
            dividend_s1 <= 6'd0;

            divisor_s5 <= 5'd0;
            divisor_s4 <= 5'd0;
            divisor_s3 <= 5'd0;
            divisor_s2 <= 5'd0;
            divisor_s1 <= 5'd0;

            div_zero_s5 <= 1'b0;
            div_zero_s4 <= 1'b0;
            div_zero_s3 <= 1'b0;
            div_zero_s2 <= 1'b0;
            div_zero_s1 <= 1'b0;

            rem_s5 <= 5'd0;
            rem_s4 <= 5'd0;
            rem_s3 <= 5'd0;
            rem_s2 <= 5'd0;
            rem_s1 <= 5'd0;

            q5_s5 <= 1'b0;

            q5_s4 <= 1'b0;
            q4_s4 <= 1'b0;

            q5_s3 <= 1'b0;
            q4_s3 <= 1'b0;
            q3_s3 <= 1'b0;

            q5_s2 <= 1'b0;
            q4_s2 <= 1'b0;
            q3_s2 <= 1'b0;
            q2_s2 <= 1'b0;

            q5_s1 <= 1'b0;
            q4_s1 <= 1'b0;
            q3_s1 <= 1'b0;
            q2_s1 <= 1'b0;
            q1_s1 <= 1'b0;

            quotient_o  <= 6'd0;
            remainder_o <= 4'd0;
            div_zero_o  <= 1'b0;
            done_o      <= 1'b0;
        end else begin
            // Desplazamiento de valid
            valid_s5 <= valid_i;
            valid_s4 <= valid_s5;
            valid_s3 <= valid_s4;
            valid_s2 <= valid_s3;
            valid_s1 <= valid_s2;

            // Registro después de etapa 5
            dividend_s5 <= dividend_i;
            divisor_s5  <= divisor_ext;
            div_zero_s5 <= (divisor_i == 4'd0);
            rem_s5      <= rem_next_5;
            q5_s5       <= q5_comb;

            // Registro después de etapa 4
            dividend_s4 <= dividend_s5;
            divisor_s4  <= divisor_s5;
            div_zero_s4 <= div_zero_s5;
            rem_s4      <= rem_next_4;
            q5_s4       <= q5_s5;
            q4_s4       <= q4_comb;

            // Registro después de etapa 3
            dividend_s3 <= dividend_s4;
            divisor_s3  <= divisor_s4;
            div_zero_s3 <= div_zero_s4;
            rem_s3      <= rem_next_3;
            q5_s3       <= q5_s4;
            q4_s3       <= q4_s4;
            q3_s3       <= q3_comb;

            // Registro después de etapa 2
            dividend_s2 <= dividend_s3;
            divisor_s2  <= divisor_s3;
            div_zero_s2 <= div_zero_s3;
            rem_s2      <= rem_next_2;
            q5_s2       <= q5_s3;
            q4_s2       <= q4_s3;
            q3_s2       <= q3_s3;
            q2_s2       <= q2_comb;

            // Registro después de etapa 1
            dividend_s1 <= dividend_s2;
            divisor_s1  <= divisor_s2;
            div_zero_s1 <= div_zero_s2;
            rem_s1      <= rem_next_1;
            q5_s1       <= q5_s2;
            q4_s1       <= q4_s2;
            q3_s1       <= q3_s2;
            q2_s1       <= q2_s2;
            q1_s1       <= q1_comb;

            // Salida después de etapa 0
            if (div_zero_s1) begin
                quotient_o  <= 6'd0;
                remainder_o <= 4'd0;
                div_zero_o  <= 1'b1;
            end else begin
                quotient_o  <= {q5_s1, q4_s1, q3_s1, q2_s1, q1_s1, q0_comb};
                remainder_o <= rem_next_0[3:0];
                div_zero_o  <= 1'b0;
            end

            done_o <= valid_s1;
        end
    end

endmodule