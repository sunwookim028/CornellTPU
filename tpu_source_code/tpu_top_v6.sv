`timescale 1 ns / 1 ps

	module tpu_top_v6 #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_DATA_WIDTH	= 32,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 6,

		// Parameters of Axi Slave Bus Interface S00_AXIS
		parameter integer C_S00_AXIS_TDATA_WIDTH	= 64,

		// Parameters of Axi Master Bus Interface M00_AXIS
		parameter integer C_M00_AXIS_TDATA_WIDTH	= 32,
		parameter integer C_M00_AXIS_START_COUNT	= 32
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
		input wire  s00_axi_rready,

		// Ports of Axi Slave Bus Interface S00_AXIS
		input wire  s00_axis_aclk,
		input wire  s00_axis_aresetn,
		output wire  s00_axis_tready,
		input wire [C_S00_AXIS_TDATA_WIDTH-1 : 0] s00_axis_tdata,
		input wire [(C_S00_AXIS_TDATA_WIDTH/8)-1 : 0] s00_axis_tstrb,
		input wire  s00_axis_tlast,
		input wire  s00_axis_tvalid,

		// Ports of Axi Master Bus Interface M00_AXIS
		input wire  m00_axis_aclk,
		input wire  m00_axis_aresetn,
		output wire  m00_axis_tvalid,
		output wire [C_M00_AXIS_TDATA_WIDTH-1 : 0] m00_axis_tdata,
		output wire [(C_M00_AXIS_TDATA_WIDTH/8)-1 : 0] m00_axis_tstrb,
		output wire  m00_axis_tlast,
		input wire  m00_axis_tready
	);
	
	// 32-bit buses from AXI slave
    wire [31:0] slv_reg0_bus;
    wire [31:0] slv_reg3_bus;
    wire [31:0] slv_reg4_bus;
    wire [31:0] slv_reg5_bus;
    wire [31:0] slv_reg6_bus;


//    wire [1:0]  instr = slv_reg0_bus[1:0];   // instruction selector
    reg         instr_ready;        // set while idle
    reg         stream_ready;       // BRAM DMA handshake ready
    wire [12:0] addr_ram    = slv_reg3_bus[12:0];
//    wire [12:0] addr_b    = slv_reg4_bus[12:0];
//    wire [12:0] addr_out  = slv_reg5_bus[12:0];
    wire [31:0] dma_len       = slv_reg6_bus;
    
    wire [2:0] tpu_mode = slv_reg0_bus[2:0];
    
    wire [7:0] pc;
    
    wire [63:0] instr;
    wire [12:0] addr_a;
    wire [12:0] addr_b;
    wire [12:0] addr_out;
    wire [12:0] addr_const;
    wire [9:0] opcode;
    wire [22:0] len;
    wire [1:0] mode;
    
    reg start_systolic;
    reg start_vpu;
    reg start_vadd;
    
    wire systolic_done;
    wire vpu_done;
    wire vadd_done;
    
    
// Instantiation of Axi Bus Interface S00_AXI
	tpu_top_v4_slave_lite_v1_0_S00_AXI # ( 
		.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
	) tpu_top_v4_slave_lite_v1_0_S00_AXI_inst (
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
		.S_AXI_RREADY(s00_axi_rready),
		
		// === NEW USER STATUS SIGNALS ===
        .instr_ready_ext(instr_ready),
        .stream_ready_ext(stream_ready),
        .slv_reg0_out(slv_reg0_bus),
        .slv_reg3_out(slv_reg3_bus),
        .slv_reg4_out(slv_reg4_bus),
        .slv_reg5_out(slv_reg5_bus),
        .slv_reg6_out(slv_reg6_bus)
	);

// Instantiation of Axi Bus Interface S00_AXIS
	tpu_top_v4_slave_stream_v1_0_S00_AXIS # ( 
		.C_S_AXIS_TDATA_WIDTH(C_S00_AXIS_TDATA_WIDTH)
	) tpu_top_v4_slave_stream_v1_0_S00_AXIS_inst (
		.S_AXIS_ACLK(s00_axis_aclk),
		.S_AXIS_ARESETN(s00_axis_aresetn),
		.S_AXIS_TREADY(s00_axis_tready),
		.S_AXIS_TDATA(s00_axis_tdata),
		.S_AXIS_TSTRB(s00_axis_tstrb),
		.S_AXIS_TLAST(s00_axis_tlast),
		.S_AXIS_TVALID(s00_axis_tvalid),
		
		.len(dma_len),
		.data_to_bram(dma_dram_din),
		.data_to_iram(dma_iram_din),
		.write_pointer_stream(write_pointer),
		.done(write_bram_done),
		.write_en(data_write_en || instr_write_en),
		.tpu_mode_stream(tpu_mode)
	);

// Instantiation of Axi Bus Interface M00_AXIS
	tpu_top_v4_master_stream_v1_0_M00_AXIS # ( 
		.C_M_AXIS_TDATA_WIDTH(C_M00_AXIS_TDATA_WIDTH),
		.C_M_START_COUNT(C_M00_AXIS_START_COUNT)
	) tpu_top_v4_master_stream_v1_0_M00_AXIS_inst (
		.M_AXIS_ACLK(m00_axis_aclk),
		.M_AXIS_ARESETN(m00_axis_aresetn),
		.M_AXIS_TVALID(m00_axis_tvalid),
		.M_AXIS_TDATA(m00_axis_tdata),
		.M_AXIS_TSTRB(m00_axis_tstrb),
		.M_AXIS_TLAST(m00_axis_tlast),
		.M_AXIS_TREADY(m00_axis_tready),
		
		.data_to_ddr(dma_dout),
		.len(dma_len),
		.read_en(start_stream),
		.done(read_bram_done),
		.read_pointer_stream(read_pointer)
	);

	// Add user logic here
	
	//DMA to bram wires
	wire [12:0] dma_addr;
	wire [31:0] dma_dram_din, dma_dout;
	wire [63:0] dma_iram_din;
	
	reg data_write_en, instr_write_en, read_en, start_compute, start_stream;
    wire write_bram_done, read_bram_done, compute_done;
    wire [15:0] write_pointer;
    wire [15:0] read_pointer;
    
    // BRAM to compute interface wires (port b)
    wire [12:0] comp_addr_b;
    wire [31:0] comp_din_b, comp_dout_b;
    wire        comp_en_b, comp_we_b;
    wire pc_enable;
    wire pc_load;
    reg [7:0] pc_load_val;
    
    //  FSM State encoding
    localparam IDLE         = 4'd0;
    localparam EXEC_WRITE   = 4'd1;
    localparam EXEC_READ    = 4'd2;
    localparam EXEC_COMPUTE = 4'd3;
    localparam WAIT_COMPUTE = 4'd4;
    localparam FETCH_1      = 4'd5;
    localparam FETCH_2      = 4'd6;
    localparam FETCH_3      = 4'd7;
    localparam WAIT_DONE    = 4'd8;
    
    reg [3:0] state = IDLE;
    
    //  Sequential FSM logic
    always @(posedge s00_axi_aclk or negedge s00_axi_aresetn) begin
        if (!s00_axi_aresetn) begin
            state         <= IDLE;
            instr_ready   <= 1'b1;
            stream_ready  <= 1'b1;
            data_write_en   <= 1'b0;
            instr_write_en <= 1'b0;
            read_en    <= 1'b0;
            start_compute <= 1'b0;
            start_systolic <= 1'b0;
            start_vpu <= 1'b0;
            start_stream <= 1'b0;
        end else begin
            // defaults
            data_write_en   <= 1'b0;
            instr_write_en <= 1'b0;
            read_en    <= 1'b0;
            start_compute <= 1'b0;
            start_vpu <= 1'b0;
            start_systolic <= 1'b0;
            start_vadd <= 1'b0;
            start_stream <= 1'b0;
    
            case (state)
                //------------------------------------------------------
                IDLE: begin
                    instr_ready <= 1'b1; // ready for next instruction
                    if (tpu_mode == 3'd1) begin // WRITE_BRAM_DATA
                        instr_ready  <= 1'b0;
                        data_write_en  <= 1'b1;
                        stream_ready <= 1'b1; // BRAM ready for DMA stream
                        state        <= EXEC_WRITE;
                    end else if (tpu_mode == 3'd2) begin // READ_BRAM
                        instr_ready  <= 1'b0;
                        read_en   <= 1'b1;
                        start_stream <= 1'b1;
                        stream_ready <= 1'b1;
                        state        <= EXEC_READ;
                    end else if (tpu_mode == 3'd3) begin // COMPUTE
                        instr_ready  <= 1'b0;
                        start_compute <= 1'b1;
                        stream_ready <= 1'b0;
                        state        <= EXEC_COMPUTE;
                    end else if (tpu_mode == 3'd4) begin  // WRITE_IRAM_DATA
                        instr_ready  <= 1'b0;
                        instr_write_en  <= 1'b1;
                        stream_ready <= 1'b1; // BRAM ready for DMA stream
                        state        <= EXEC_WRITE;
                    end
                end
    
                //------------------------------------------------------
                EXEC_WRITE: begin
                    // Wait until BRAM transfer finishes
                    stream_ready <= 1'b1;
                    if (tpu_mode == 3'd1) begin
                        data_write_en <= 1'b1;
                    end else if (tpu_mode == 3'd4) begin
                        instr_write_en <= 1'b1;
                    end
                    if (write_bram_done) begin
                        state <= WAIT_DONE;
                        end
                end
    
                //------------------------------------------------------
                EXEC_READ: begin
                    stream_ready <= 1'b1;
                    read_en <= 1'b1;
                    if (read_bram_done) begin
                        state <= WAIT_DONE;
                        end
                end
    
                //------------------------------------------------------
                EXEC_COMPUTE: begin
                    if (compute_done) begin
                        state <= WAIT_DONE;
                        end
                    else begin
                        if (mode == 2'd0) begin
                            start_vpu <= 1'b1;
                            state <= WAIT_COMPUTE;
                        end else if (mode == 2'd1) begin
                            start_systolic <= 1'b1;
                            state <= WAIT_COMPUTE;
                        end else if (mode == 2'd2)begin
                            start_vadd <= 1'b1;  
                            state <= WAIT_COMPUTE;  
                        end
                    end
                end
                
                //------------------------------------------------------
                WAIT_COMPUTE: begin
                    if (systolic_done || vpu_done || vadd_done) begin
                        state <= FETCH_1;
                    end
                end
                //------------------------------------------------------
                FETCH_1: begin
                    state <= FETCH_2;
                end
                
                //------------------------------------------------------
                FETCH_2: begin
                    state <= FETCH_3;
                end
                
                //------------------------------------------------------
                FETCH_3: begin
                    state <= EXEC_COMPUTE;
                end
                //------------------------------------------------------
                WAIT_DONE: begin
                    instr_ready <= 1'b1;
                    if (tpu_mode == 3'd0) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
    
    //  Instantiate submodules
    bram_top #(
        .ADDR_WIDTH(13),
        .DATA_WIDTH(32)
    ) u_bram_top (
        .clk(s00_axi_aclk),
        .rst_n(s00_axi_aresetn),
        .base_addr(addr_ram),
    
        // DMA AXI-Stream interfaces 
        
        .dma_wr_en(data_write_en),
        .dma_wr_data(dma_dram_din),
        .dma_write_pointer(write_pointer),
        
        .dma_rd_en(read_en),
        .dma_rd_data(dma_dout),
        .dma_read_pointer(read_pointer),
        
    
        // Compute-side BRAM port
        .dma_comp_addr_b(comp_addr_b),
        .dma_comp_din_b (comp_din_b),
        .dma_comp_dout_b(comp_dout_b),
        .dma_comp_en_b  (comp_en_b),
        .dma_comp_we_b  (comp_we_b)
    );
    
    compute_core #(
    .ADDR_WIDTH(13),
    .DATA_WIDTH(32),
    .VPU_DATA_W(32),
    .VPU_ADDR_W(13),
    .VPU_OP_W(10),
    .VPU_IADDR_W(5)
    ) u_compute_core (
        .clk(s00_axi_aclk),
        .rst_n(s00_axi_aresetn),
    
        .mode_compute(mode),
    
        .addr_a_compute(addr_a),
        .addr_b_compute(addr_b),
        .addr_out_compute(addr_out),
        .addr_const_compute(addr_const),
        .opcode_compute(opcode),
        .len_compute(len),
    
        .start_systolic_compute(start_systolic),
        .start_vadd_compute(start_vadd),
        .start_vpu_compute(start_vpu),
    
        .systolic_done_compute(systolic_done),
        .vadd_done_compute(vadd_done),
        .vpu_done_compute(vpu_done),
    
        .bram_addr_b(comp_addr_b),
        .bram_din_b(comp_din_b),
        .bram_dout_b(comp_dout_b),
        .bram_en_b(comp_en_b),
        .bram_we_b(comp_we_b)
    );
    
assign pc_enable = (systolic_done || vadd_done || vpu_done);
assign compute_done = (mode == 2'd3); 
    pc #(
    .PC_WIDTH(8)
    ) u_pc (
        .clk        (s00_axi_aclk),
        .rst_n        (s00_axi_aresetn),
    
        .PC_enable  (pc_enable),
        .PC_load    (pc_load),
        .PC_load_val(pc_load_val),
    
        .PC         (pc)
    );
    
    decoder dec(
        .instr_decode(instr),
        .len_decode(len),
        .opcode_decode(opcode),
        .addr_const_decode(addr_const),
        .addr_a_decode(addr_a),
        .addr_b_decode(addr_b),
        .addr_out_decode(addr_out),
        .mode_decode(mode)
    );
    
    
    // for loading to IRAM
    reg [7:0] iram_addr;
    
    always @(posedge s00_axi_aclk or negedge s00_axi_aresetn) begin
        if (!s00_axi_aresetn) begin
            iram_addr <= 0;
        end else if (instr_write_en) begin
            iram_addr <= addr_ram + write_pointer;
        end
    end
    
     blk_mem_gen_1 I_bram (
        // Port A - DMA side (FSM-controlled)
        .clka(s00_axi_aclk),
        .ena(1'b1),
        .wea(instr_write_en),
        .addra(iram_addr),
        .dina(dma_iram_din),
        .douta(),

        // Port B - Compute side
        .clkb(s00_axi_aclk),
        .enb(1'b1),
        .web(1'b0), // compute should never write to Instruction RAM
        .addrb(pc),
        .dinb(64'b0),
        .doutb(instr)
    );
    
	// User logic ends

	endmodule