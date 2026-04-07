`timescale 1ns/1ps

module gray_counter_tb;

reg clk;
reg rst_n;
wire [3:0] bin_count;
wire [3:0] gray_count;
reg [3:0] expected_bin;
reg [3:0] expected_gray;
reg [3:0] transition_xor;
integer cycle_count;

gray_counter dut (
    .clk        (clk),
    .rst_n      (rst_n),
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

initial begin
    $dumpfile("sim/waves/gray_counter.vcd");
    $dumpvars(0, gray_counter_tb);

    clk = 1'b0;
    rst_n = 1'b0;
    expected_bin = 4'd0;
    expected_gray = 4'd0;
    transition_xor = 4'd0;
    cycle_count = 0;

    #12;
    rst_n = 1'b1;

    repeat (16) begin
        @(posedge clk);
        cycle_count = cycle_count + 1;
        expected_bin = expected_bin + 1'b1;
        expected_gray = bin_to_gray(expected_bin);
        #1;
        if (bin_count !== expected_bin) begin
            $display("ERROR gray_counter bin mismatch cycle=%0d expected=%b got=%b", cycle_count, expected_bin, bin_count);
            $finish(1);
        end
        if (gray_count !== expected_gray) begin
            $display("ERROR gray_counter gray mismatch cycle=%0d expected=%b got=%b", cycle_count, expected_gray, gray_count);
            $finish(1);
        end
        transition_xor = gray_count ^ bin_to_gray(expected_bin - 1'b1);
        if (transition_xor != 4'b0001 &&
            transition_xor != 4'b0010 &&
            transition_xor != 4'b0100 &&
            transition_xor != 4'b1000) begin
            $display("ERROR gray_counter transition is not single-bit cycle=%0d xor=%b", cycle_count, transition_xor);
            $finish(1);
        end
    end

    $display("PASS gray_counter completed %0d cycles", cycle_count);
    $finish;
end

endmodule
