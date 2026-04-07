`include "common_defs.vh"

module gray_counter (
    input  wire                    clk,
    input  wire                    rst_n,
    output reg  [`COUNTER_WIDTH-1:0] bin_count,
    output wire [`COUNTER_WIDTH-1:0] gray_count
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        bin_count <= {`COUNTER_WIDTH{1'b0}};
    end else begin
        bin_count <= bin_count + 1'b1;
    end
end

assign gray_count = bin_count ^ (bin_count >> 1);

endmodule
