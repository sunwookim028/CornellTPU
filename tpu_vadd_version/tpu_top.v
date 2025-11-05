
`timescale 1 ns / 1 ps

	module tpu_top #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_DATA_WIDTH	= 32,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 5
	)
	(
		// Users to add ports here

		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S00_AXI
		input wire  s00_axi_aclk,
		input wire  s00_axi_aresetn,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
		input wire [2 : 0] s00_axi_awprot,
		input wire  s00_axi_awvalid,
		output wire  s00_axi_awready,
		input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
		input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
		input wire  s00_axi_wvalid,
		output wire  s00_axi_wready,
		output wire [1 : 0] s00_axi_bresp,
		output wire  s00_axi_bvalid,
		input wire  s00_axi_bready,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
		input wire [2 : 0] s00_axi_arprot,
		input wire  s00_axi_arvalid,
		output wire  s00_axi_arready,
		output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
		output wire [1 : 0] s00_axi_rresp,
		output wire  s00_axi_rvalid,
		input wire  s00_axi_rready
	);
// Instantiation of Axi Bus Interface S00_AXI
	tpu_top_slave_lite_v1_0_S00_AXI # ( 
		.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
	) tpu_top_slave_lite_v1_0_S00_AXI_inst (
		.S_AXI_ACLK(s00_axi_aclk),
		.S_AXI_ARESETN(s00_axi_aresetn),
		.S_AXI_AWADDR(s00_axi_awaddr),
		.S_AXI_AWPROT(s00_axi_awprot),
		.S_AXI_AWVALID(s00_axi_awvalid),
		.S_AXI_AWREADY(s00_axi_awready),
		.S_AXI_WDATA(s00_axi_wdata),
		.S_AXI_WSTRB(s00_axi_wstrb),
		.S_AXI_WVALID(s00_axi_wvalid),
		.S_AXI_WREADY(s00_axi_wready),
		.S_AXI_BRESP(s00_axi_bresp),
		.S_AXI_BVALID(s00_axi_bvalid),
		.S_AXI_BREADY(s00_axi_bready),
		.S_AXI_ARADDR(s00_axi_araddr),
		.S_AXI_ARPROT(s00_axi_arprot),
		.S_AXI_ARVALID(s00_axi_arvalid),
		.S_AXI_ARREADY(s00_axi_arready),
		.S_AXI_RDATA(s00_axi_rdata),
		.S_AXI_RRESP(s00_axi_rresp),
		.S_AXI_RVALID(s00_axi_rvalid),
		.S_AXI_RREADY(s00_axi_rready)
	);

	// Add user logic here
	
    //=====================================================================
    // User logic for TPU Top Controller (pure Verilog-2001 version)
    //=====================================================================
    
    // --------------------------------------------------------------------
    //  AXI-Lite register mapping
    // --------------------------------------------------------------------
    //  slv_reg0 : instr        (0=WRITE_BRAM, 1=READ_BRAM, 2=COMPUTE)
    //  slv_reg1 : instr_ready  (1 = ready for new instruction, 0 = busy)
    //  slv_reg2 : stream_ready (1 = BRAM ready for DMA bursts)
    //  slv_reg3 : addr_a       (base address for BRAM access)
    //  slv_reg4 : addr_b       (secondary vector base for compute)
    //  slv_reg5 : addr_out     (destination base address for compute)
    //  slv_reg6 : len          (number of words to process)
    // --------------------------------------------------------------------
    
    wire [1:0]  instr     = tpu_top_v1_0_S00_AXI_inst.slv_reg0[1:0];   // instruction selector
    reg         instr_ready;        // set while idle
    reg         stream_ready;       // BRAM DMA handshake ready
    wire [12:0] addr_a    = tpu_top_v1_0_S00_AXI_inst.slv_reg3[12:0];
    wire [12:0] addr_b    = tpu_top_v1_0_S00_AXI_inst.slv_reg4[12:0];
    wire [12:0] addr_out  = tpu_top_v1_0_S00_AXI_inst.slv_reg5[12:0];
    wire [31:0] len       = tpu_top_v1_0_S00_AXI_inst.slv_reg6;
    
    // --------------------------------------------------------------------
    //  Internal control signals
    // --------------------------------------------------------------------
    reg start_write, start_read, start_compute;
    wire bram_done, compute_done;
    
    // BRAM <-> compute interface wires
    wire [12:0] comp_addr_b;
    wire [31:0] comp_din_b, comp_dout_b;
    wire        comp_en_b, comp_we_b;
    

    //  FSM State encoding
    localparam IDLE         = 3'd0;
    localparam EXEC_WRITE   = 3'd1;
    localparam EXEC_READ    = 3'd2;
    localparam EXEC_COMPUTE = 3'd3;
    localparam WAIT_DONE    = 3'd4;
    
    reg [2:0] state;
    
    //  Sequential FSM logic
    always @(posedge s00_axi_aclk or negedge s00_axi_aresetn) begin
        if (!s00_axi_aresetn) begin
            state         <= IDLE;
            instr_ready   <= 1'b1;
            stream_ready  <= 1'b0;
            start_write   <= 1'b0;
            start_read    <= 1'b0;
            start_compute <= 1'b0;
        end else begin
            // defaults
            start_write   <= 1'b0;
            start_read    <= 1'b0;
            start_compute <= 1'b0;
            stream_ready  <= 1'b0;
    
            case (state)
                //------------------------------------------------------
                IDLE: begin
                    instr_ready <= 1'b1; // ready for next instruction
                    if (instr == 2'd0) begin // WRITE_BRAM
                        instr_ready  <= 1'b0;
                        start_write  <= 1'b1;
                        stream_ready <= 1'b1; // BRAM ready for DMA stream
                        state        <= EXEC_WRITE;
                    end else if (instr == 2'd1) begin // READ_BRAM
                        instr_ready  <= 1'b0;
                        start_read   <= 1'b1;
                        stream_ready <= 1'b1;
                        state        <= EXEC_READ;
                    end else if (instr == 2'd2) begin // COMPUTE
                        instr_ready  <= 1'b0;
                        start_compute <= 1'b1;
                        state        <= EXEC_COMPUTE;
                    end
                end
    
                //------------------------------------------------------
                EXEC_WRITE: begin
                    // Wait until BRAM transfer finishes
                    if (bram_done)
                        state <= WAIT_DONE;
                end
    
                //------------------------------------------------------
                EXEC_READ: begin
                    if (bram_done)
                        state <= WAIT_DONE;
                end
    
                //------------------------------------------------------
                EXEC_COMPUTE: begin
                    if (compute_done)
                        state <= WAIT_DONE;
                end
    
                //------------------------------------------------------
                WAIT_DONE: begin
                    instr_ready <= 1'b1;
                    state <= IDLE;
                end
            endcase
        end
    end
    
  
    //  Write back instr_ready / stream_ready flags to AXI registers 
    always @(*) begin
        tpu_top_v1_0_S00_AXI_inst.slv_reg1 = {31'd0, instr_ready};
        tpu_top_v1_0_S00_AXI_inst.slv_reg2 = {31'd0, stream_ready};
    end
    

    //  Instantiate submodules
    bram_top #(
        .ADDR_WIDTH(13),
        .DATA_WIDTH(32)
    ) u_bram_top (
        .clk(s00_axi_aclk),
        .rst_n(s00_axi_aresetn),
        .start_write(start_write),
        .start_read(start_read),
        .base_addr(addr_a),
        .len(len),
        .done(bram_done),
    
        // DMA AXI-Stream interfaces 
        .s_axis_valid(s_axis_valid),
        .s_axis_data (s_axis_data),
        .s_axis_last (s_axis_last),
        .s_axis_ready(s_axis_ready),
        .m_axis_valid(m_axis_valid),
        .m_axis_data (m_axis_data),
        .m_axis_last (m_axis_last),
        .m_axis_ready(m_axis_ready),
    
        // Compute-side BRAM port
        .comp_addr_b(comp_addr_b),
        .comp_din_b (comp_din_b),
        .comp_dout_b(comp_dout_b),
        .comp_en_b  (comp_en_b),
        .comp_we_b  (comp_we_b)
    );
    
    compute_top #(
        .ADDR_WIDTH(13),
        .DATA_WIDTH(32)
    ) u_compute_top (
        .clk(s00_axi_aclk),
        .rst_n(s00_axi_aresetn),
        .start_compute(start_compute),
        .done(compute_done),
    
        // BRAM port connection (shared BRAM)
        .addr_b(comp_addr_b),
        .din_b (comp_din_b),
        .dout_b(comp_dout_b),
        .en_b  (comp_en_b),
        .we_b  (comp_we_b),
    
        // control addresses for compute operation
        .addr_a(addr_a),
        .addr_b_base(addr_b),
        .addr_out(addr_out),
        .len(len)
    );

	// User logic ends

	endmodule
