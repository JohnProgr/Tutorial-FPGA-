`timescale 1ns/1ps

module tb_divider_pipeline;

    logic       clk;
    logic       rst_n;
    logic       valid_i;
    logic [5:0] dividend_i;
    logic [3:0] divisor_i;

    logic [5:0] quotient_o;
    logic [3:0] remainder_o;
    logic       div_zero_o;
    logic       done_o;

    divider_pipeline dut (
        .clk         (clk),
        .rst_n       (rst_n),
        .valid_i     (valid_i),
        .dividend_i  (dividend_i),
        .divisor_i   (divisor_i),
        .quotient_o  (quotient_o),
        .remainder_o (remainder_o),
        .div_zero_o  (div_zero_o),
        .done_o      (done_o)
    );

    always #5 clk = ~clk;

    task automatic apply_case(
        input logic [5:0] dividend,
        input logic [3:0] divisor,
        input logic [5:0] exp_quotient,
        input logic [3:0] exp_remainder,
        input logic       exp_div_zero
    );
        begin
            @(negedge clk);
            dividend_i = dividend;
            divisor_i  = divisor;
            valid_i    = 1'b1;

            @(negedge clk);
            valid_i = 1'b0;

            wait(done_o == 1'b1);
            #1;

            if (
                quotient_o  !== exp_quotient  ||
                remainder_o !== exp_remainder ||
                div_zero_o  !== exp_div_zero
            ) begin
                $display("ERROR: %0d / %0d -> q=%0d r=%0d div0=%b | esperado q=%0d r=%0d div0=%b",
                    dividend, divisor,
                    quotient_o, remainder_o, div_zero_o,
                    exp_quotient, exp_remainder, exp_div_zero
                );
            end else begin
                $display("OK: %0d / %0d -> q=%0d r=%0d div0=%b",
                    dividend, divisor,
                    quotient_o, remainder_o, div_zero_o
                );
            end

            repeat (2) @(negedge clk);
        end
    endtask

    initial begin
        $dumpfile("tb_divider_pipeline.vcd");
        $dumpvars(0, tb_divider_pipeline);

        clk        = 1'b0;
        rst_n      = 1'b0;
        valid_i    = 1'b0;
        dividend_i = 6'd0;
        divisor_i  = 4'd0;

        repeat (3) @(negedge clk);
        rst_n = 1'b1;

        apply_case(6'd6,  4'd3,  6'd2,  4'd0, 1'b0);
        apply_case(6'd7,  4'd3,  6'd2,  4'd1, 1'b0);
        apply_case(6'd63, 4'd15, 6'd4,  4'd3, 1'b0);
        apply_case(6'd63, 4'd1,  6'd63, 4'd0, 1'b0);
        apply_case(6'd5,  4'd8,  6'd0,  4'd5, 1'b0);
        apply_case(6'd63, 4'd6,  6'd10, 4'd3, 1'b0);
        apply_case(6'd12, 4'd0,  6'd0,  4'd0, 1'b1);

        $display("Simulacion de divider_pipeline finalizada.");
        $finish;
    end

endmodule