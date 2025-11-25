# CornellTPU
The Cornell TPU; or maybe the Big Red Unit (BRU)?


 # Systolic_wrapper
 Systolic wrapper (rename systolic_top?) is the top level module that instantiates the systolic array datapath and manages the control logic for it. The systolic wrapper provides a clean interface between the systolic array and the rest of the CornellTPU (i.e. the control unit and the memory system). 

 ## Interface
 ### Parameters
  - N: The size of the systolic array. Assume matrices are square and NxN.
  - DATA_WIDTH: The size of each matrix element in bits.
  - BANKING_FACTOR: How many elements can be loaded in (or later, stored) at once. BANKING_FACTOR * DATA_WIDTH should be the bandwidth of the data connection with memory.
  - ADDRESS_WIDTH: The size in bits of each memory address.
  - MEM_LATENCY: The response latency of memory. Assume a fixed latency.
 ### Control Signals
 Standard:
  - clk: Clock signal
  - rst: Reset signal (pulse high to reset)

 To/from control:
  - start: Pulse high to begin systolic_wrapper operation (begin load->matmul->store sequence)
  - done: Pulsed high by systolic_wrapper when storing is complete
  - base_addr_w [ADDRESS_WIDTH - 1 : 0]: Base address in memory of weight matrix. Latched when start is driven high.
  - base_addr_x [ADDRESS_WIDTH - 1 : 0]: Base address in memory of x matrix. Latched when start is driven high.
  - base_addr_out [ADDRESS_WIDTH - 1 : 0]: Base address in memory to store output matrix. Latched when start is driven high.

 To/from memory:
  - mem_req_addr [ADDRESS_WIDTH - 1 : 0]: Address of memory access request (i.e. address to read/write at for this request)
  - mem_req_data [BANKING_FACTOR*DATA_WIDTH-1 : 0]: Data of memory access request (meaningless for reads; data to write for writes)
  - mem_resp_data [BANKING_FACTOR*DATA_WIDTH-1 : 0]: Data of memory access response (meaningless for writes; requested data for reads)
  - mem_read_en: Memory read enable. Driven high when a memory read request is sent. (Also can be interpreted as a valid signal for mem_req_addr).
  - mem_write_en: Memory write enable. Driven high when a memory write request is sent. (Also can be interpreted as a valid signal for mem_req_addr and mem_req_data).

## FSM:
The flow of the FSM is as follows:

IDLE -> LOAD_W_REQ <--> LOAD_W_WAIT -> LOAD_X_REQ <--> LOAD_X_WAIT -> RUN -> CAPTURE -> STORE_REQ <--> STORE_WAIT -> DONE

During the req states (i.e. load_w_req, load_x_req, store_req), the FSM sends a request to memory and then enters the corresponding wait state. During the wait state the FSM will wait the parameterized memory access latency before accepting a read response from memory (in the case of reads), or assuming a write was successful. The FSM will then either move on to the next state or return to the request state depending on whether the matrix has been fully loaded/stored.

## How to test systolic array:
We are using cocotb to test our systolic array design. The systolic array is driven with precisely timed sequences of weight values (loaded column-by-column) and input activations (streamed row-by-row), matching the array’s intended dataflow. To create test cases, you must create a test points inside the Makefile that runs the Python testing file. To run these tests, in the terminal enter "makec test_name." 

## Advanced Features: 
Our goals for advanced features of the systolic array would be to explore larger models as well as maybe implementing a double buffer.