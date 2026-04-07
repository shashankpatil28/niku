`include "common_defs.vh"

module sync_counter (
    input  wire                    clk,
    input  wire                    rst_n,
    output reg  [`COUNTER_WIDTH-1:0] count
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= {`COUNTER_WIDTH{1'b0}};
    end else begin
        count <= count + 1'b1;
    end
end

endmodule
