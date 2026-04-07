`timescale 1ns/1ps

module gray_counter_ce_tb;

reg clk;
reg rst_n;
reg enable;
wire [3:0] bin_count;
wire [3:0] gray_count;
reg [3:0] expected_bin;
reg [3:0] expected_gray;
integer cycle_count;

gray_counter_ce dut (
    .clk        (clk),
    .rst_n      (rst_n),
    .enable     (enable),
    .bin_count  (bin_count),
    .gray_count (gray_count)
);

always #5 clk = ~clk;

function [3:0] bin_to_gray;
    input [3:0] value;
    begin
        bin_to_gray = value ^ (value >> 1);
    end
endfunction

task check_outputs;
    begin
        expected_gray = bin_to_gray(expected_bin);
        #1;
        if (bin_count !== expected_bin) begin
            $display("ERROR gray_counter_ce bin mismatch cycle=%0d expected=%b got=%b", cycle_count, expected_bin, bin_count);
            $finish(1);
        end
        if (gray_count !== expected_gray) begin
            $display("ERROR gray_counter_ce gray mismatch cycle=%0d expected=%b got=%b", cycle_count, expected_gray, gray_count);
            $finish(1);
        end
    end
endtask

initial begin
    $dumpfile("sim/waves/gray_counter_ce.vcd");
    $dumpvars(0, gray_counter_ce_tb);

    clk = 1'b0;
    rst_n = 1'b0;
    enable = 1'b0;
    expected_bin = 4'd0;
    expected_gray = 4'd0;
    cycle_count = 0;

    #12;
    rst_n = 1'b1;

    repeat (4) begin
        @(posedge clk);
        cycle_count = cycle_count + 1;
        check_outputs();
    end

    enable = 1'b1;
    repeat (8) begin
        @(posedge clk);
        cycle_count = cycle_count + 1;
        expected_bin = expected_bin + 1'b1;
        check_outputs();
    end

    enable = 1'b0;
    repeat (4) begin
        @(posedge clk);
        cycle_count = cycle_count + 1;
        check_outputs();
    end

    enable = 1'b1;
    repeat (4) begin
        @(posedge clk);
        cycle_count = cycle_count + 1;
        expected_bin = expected_bin + 1'b1;
        check_outputs();
    end

    $display("PASS gray_counter_ce completed %0d cycles", cycle_count);
    $finish;
end

endmodule
