`timescale 1ns/1ps

module sync_counter_tb;

reg clk;
reg rst_n;
wire [3:0] count;
reg [3:0] expected_count;
integer cycle_count;

sync_counter dut (
    .clk   (clk),
    .rst_n (rst_n),
    .count (count)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("sim/waves/sync_counter.vcd");
    $dumpvars(0, sync_counter_tb);

    clk = 1'b0;
    rst_n = 1'b0;
    expected_count = 4'd0;
    cycle_count = 0;

    #12;
    rst_n = 1'b1;

    repeat (16) begin
        @(posedge clk);
        cycle_count = cycle_count + 1;
        expected_count = expected_count + 1'b1;
        #1;
        if (count !== expected_count) begin
            $display("ERROR sync_counter cycle=%0d expected=%b got=%b", cycle_count, expected_count, count);
            $finish(1);
        end
    end

    $display("PASS sync_counter completed %0d cycles", cycle_count);
    $finish;
end

endmodule
