module counter(
    input clk,
    input rst_n,
    output reg [7:0] out
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            out <= 8'h0;
        else
            out <= out + 1;
    end
endmodule
