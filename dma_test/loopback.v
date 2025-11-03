`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Simple AXI4-Stream loopback module for DMA testing
//////////////////////////////////////////////////////////////////////////////////

module loopback #(parameter DATA_WIDTH = 32)(
    input  wire                   axi_clk,
    input  wire                   axi_reset_n,
    
    // AXI4-Stream Slave interface (input from DMA MM2S)
    input  wire                   s_axis_valid,
    input  wire [DATA_WIDTH-1:0]  s_axis_data,
    input  wire                   s_axis_last,
    output wire                   s_axis_ready,
    
    // AXI4-Stream Master interface (output to DMA S2MM)
    output reg                    m_axis_valid,
    output reg  [DATA_WIDTH-1:0]  m_axis_data,
    output reg                    m_axis_last,
    input  wire                   m_axis_ready
    );

    assign s_axis_ready = m_axis_ready;

    always @(posedge axi_clk) begin
        if (!axi_reset_n) begin
            m_axis_valid <= 0;
            m_axis_data  <= 0;
            m_axis_last  <= 0;
        end else begin
            if (s_axis_valid && s_axis_ready) begin
                m_axis_data  <= s_axis_data;
                m_axis_last  <= s_axis_last;  
                m_axis_valid <= 1;
            end else if (m_axis_ready) begin
                m_axis_valid <= 0;
                m_axis_last  <= 0;
            end
        end
    end

endmodule
