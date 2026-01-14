module fifo4 #(
    parameter int WIDTH = 32
)(
    input  logic                 clk,
    input  logic                 rst_n,

    // Write side
    input  logic                 wr_en,
    input  logic [WIDTH-1:0]     wr_data,

    // Read side
    input  logic                 rd_en,
    output logic [WIDTH-1:0]     rd_data,

    // Status
    output logic                 full,
    output logic                 empty,
    output logic                 one_item_remaining
);

    //-----------------------------
    // Storage (8 entries)
    //-----------------------------
    logic [WIDTH-1:0] mem [0:7];

    //-----------------------------
    // Pointers (2-bit index + wrap)
    //-----------------------------
    logic [3:0] wptr;   // index = wptr[2:0], wrap = wptr[3]
    logic [3:0] rptr;

    //-----------------------------
    // EMPTY / FULL logic
    //-----------------------------
    assign empty = (wptr == rptr);
    assign full  = (wptr[3] != rptr[3]) &&
                   (wptr[2:0] == rptr[2:0]);
    assign one_item_remaining = ((rptr + 4'd1) == wptr);

    //-----------------------------
    // WRITE logic
    //-----------------------------
    always_ff @(posedge clk) begin
        if (!rst_n) begin
            wptr <= '0;
        end else if (wr_en && !full) begin
            mem[wptr[2:0]] <= wr_data;
            wptr <= wptr + 3'd1;
        end
    end

    //-----------------------------
    // READ logic
    //-----------------------------
    always_ff @(posedge clk) begin
        if (!rst_n) begin
            rptr <= '0;
            rd_data <= '0;
        end else if (rd_en && !empty) begin
            rd_data <= mem[rptr[2:0]];
            rptr <= rptr + 3'd1;
        end
    end

endmodule