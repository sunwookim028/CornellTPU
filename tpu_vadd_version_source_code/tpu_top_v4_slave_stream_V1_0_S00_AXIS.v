
`timescale 1 ns / 1 ps

	module tpu_top_v4_slave_stream_v1_0_S00_AXIS #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line

		// AXI4Stream sink: Data Width
		parameter integer C_S_AXIS_TDATA_WIDTH	= 32
	)
	(
		// Users to add ports here
		
		input wire [31:0] len,
		output wire [31:0] data_to_bram,
		output reg [15:0] write_pointer,
		output wire done,
		input wire write_en,

		// User ports ends
		// Do not modify the ports beyond this line

		// AXI4Stream sink: Clock
		input wire  S_AXIS_ACLK,
		// AXI4Stream sink: Reset
		input wire  S_AXIS_ARESETN,
		// Ready to accept data in
		output wire  S_AXIS_TREADY,
		// Data in
		input wire [C_S_AXIS_TDATA_WIDTH-1 : 0] S_AXIS_TDATA,
		// Byte qualifier
		input wire [(C_S_AXIS_TDATA_WIDTH/8)-1 : 0] S_AXIS_TSTRB,
		// Indicates boundary of last packet
		input wire  S_AXIS_TLAST,
		// Data is in valid
		input wire  S_AXIS_TVALID
	);
	// function called clogb2 that returns an integer which has the 
	// value of the ceiling of the log base 2.
	function integer clogb2 (input integer bit_depth);
	  begin
	    for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
	      bit_depth = bit_depth >> 1;
	  end
	endfunction

	// Total number of input data.
	integer NUMBER_OF_INPUT_WORDS;
	always@(*) NUMBER_OF_INPUT_WORDS  = len;
	// bit_num gives the minimum number of bits needed to address 'NUMBER_OF_INPUT_WORDS' size of FIFO.
	//integer bit_num;
	// always@(*) bit_num  = clogb2(NUMBER_OF_INPUT_WORDS-1);
	// Define the states of state machine
	// The control state machine oversees the writing of input streaming data to the FIFO,
	// and outputs the streaming data from the FIFO
	parameter [1:0] IDLE = 1'b0,        // This is the initial/idle state 

	                WRITE_FIFO  = 1'b1; // In this state FIFO is written with the
	                                    // input stream data S_AXIS_TDATA 
	wire  	axis_tready;
	// State variable
	reg mst_exec_state;  
	// FIFO implementation signals
	genvar byte_index;     
	// FIFO write enable
	wire fifo_wren;
	// FIFO full flag
	reg fifo_full_flag;
	// FIFO write pointer
//	reg [15:0] write_pointer;
	// sink has accepted all the streaming data and stored in FIFO
	  reg writes_done;
	// I/O Connections assignments
	reg [31:0] data;
	reg reset;
	reg t_last_pipelined;
	reg fifo_wren_pipelined;
	
	always @(posedge S_AXIS_ACLK)                                                                  
	begin                                                                                          
	  if (!S_AXIS_ARESETN)                                                                         
	    begin                                                                                      
	      t_last_pipelined <= 1'b0;
	      fifo_wren_pipelined <= 1'b0;                                                       
	    end                                                                                        
	  else                                                                                         
	    begin                                                                                      
	      t_last_pipelined <= S_AXIS_TLAST;
	      fifo_wren_pipelined <= fifo_wren;                                                     
	    end                                                                                        
	end  

	assign S_AXIS_TREADY	= axis_tready;
	assign data_to_bram = data;
	assign done = writes_done;
	// Control state machine implementation
	always @(posedge S_AXIS_ACLK) 
	begin  
	  if (!S_AXIS_ARESETN) 
	  // Synchronous reset (active low)
	    begin
	      mst_exec_state <= IDLE;
	    end  
	  else
	    reset <= 1'b0;
	    case (mst_exec_state)
	      IDLE:
	      begin 
	        // The sink starts accepting tdata when 
	        // there tvalid is asserted to mark the
	        // presence of valid streaming data 
	          reset <= 1'b1;
	          if (S_AXIS_TVALID && write_en)
	            begin
	              mst_exec_state <= WRITE_FIFO;
	            end
	          else
	            begin
	              mst_exec_state <= IDLE;
	            end
	      end
	      WRITE_FIFO: 
	        // When the sink has accepted all the streaming input data,
	        // the interface swiches functionality to a streaming master
	        if (writes_done)
	          begin
	            mst_exec_state <= IDLE;
	          end
	        else
	          begin
	            // The sink accepts and stores tdata 
	            // into FIFO
	            mst_exec_state <= WRITE_FIFO;
	          end

	    endcase
	end
	// AXI Streaming Sink 
	// 
	// The example design sink is always ready to accept the S_AXIS_TDATA  until
	// the FIFO is not filled with NUMBER_OF_INPUT_WORDS number of input words.
	assign axis_tready = ((mst_exec_state == WRITE_FIFO) && (!writes_done));

	always@(posedge S_AXIS_ACLK)
	begin
	  if(!S_AXIS_ARESETN || reset)
	    begin
	      write_pointer <= 0;
	      writes_done <= 1'b0;
	    end  
	  else
	    if (write_pointer <= NUMBER_OF_INPUT_WORDS-1)
	      begin
	        if (fifo_wren && (write_pointer != NUMBER_OF_INPUT_WORDS-1))
	          begin
	            // write pointer is incremented after every write to the FIFO
	            // when FIFO write signal is enabled.
	            write_pointer <= write_pointer + 1;
	            writes_done <= 1'b0;
	          end
	          if ((write_pointer == NUMBER_OF_INPUT_WORDS-1)|| t_last_pipelined)
	            begin
	              // reads_done is asserted when NUMBER_OF_INPUT_WORDS numbers of streaming data 
	              // has been written to the FIFO which is also marked by S_AXIS_TLAST(kept for optional usage).
	              writes_done <= 1'b1;
	            end
	      end  
	end

	// FIFO write enable generation
	assign fifo_wren = S_AXIS_TVALID && axis_tready;

	// FIFO Implementation
//	generate 
//	  for(byte_index=0; byte_index<= (C_S_AXIS_TDATA_WIDTH/8-1); byte_index=byte_index+1)
//	  begin:FIFO_GEN

//	    reg  [(C_S_AXIS_TDATA_WIDTH/4)-1:0] stream_data_fifo [0 : NUMBER_OF_INPUT_WORDS-1];

//	    // Streaming input data is stored in FIFO

	    
//	  end		
//	endgenerate


	// Add user logic here
	reg [C_S_AXIS_TDATA_WIDTH-1 : 0] S_AXIS_TDATA_PIPELINED;
	always @( posedge S_AXIS_ACLK )
	    begin
	      if (fifo_wren || fifo_wren_pipelined)// && S_AXIS_TSTRB[byte_index])
	        begin
//	          stream_data_fifo[write_pointer] <= S_AXIS_TDATA[(byte_index*8+7) -: 8];
              S_AXIS_TDATA_PIPELINED <= S_AXIS_TDATA;
	          data <= S_AXIS_TDATA_PIPELINED;
	        end  
	    end  

	// User logic ends

	endmodule