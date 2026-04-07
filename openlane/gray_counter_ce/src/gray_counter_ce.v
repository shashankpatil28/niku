`include "common_defs.vh"

module gray_counter_ce (
    input  wire                    clk,
    input  wire                    rst_n,
    input  wire                    enable,
    output reg  [`COUNTER_WIDTH-1:0] bin_count,
    output wire [`COUNTER_WIDTH-1:0] gray_count
);

// Use a synchronous clock-enable instead of combinational clock gating.
// This stops unnecessary counter toggles while remaining synthesis-safe.
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        bin_count <= {`COUNTER_WIDTH{1'b0}};
    end else if (enable) begin
        bin_count <= bin_count + 1'b1;
    end
end

// Gray coding reduces output bit transitions versus plain binary output.
assign gray_count = bin_count ^ (bin_count >> 1);

endmodule
