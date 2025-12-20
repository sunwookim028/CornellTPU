# Memory Subsystem

The memory subsystem provides a **software-managed scratchpad memory** for the CornellTPU. It is built around a **true dual-port BRAM** and provides a clean interface between external memory (via DMA-style streams) and on-chip compute units (e.g., vector engines and the systolic array). All computation operates exclusively on data resident in BRAM.

# bram_top

`bram_top` is the top-level memory module that instantiates a **true dual-port BRAM** and manages address generation for DMA-side and compute-side accesses. The memory subsystem provides a clean interface between external memory transfers and accelerator compute.

## Interface

### Parameters
- `ADDR_WIDTH`: The size in bits of the BRAM address space.
- `DATA_WIDTH`: The size in bits of each BRAM data element.

### Control Signals

Standard:
- `clk`: Clock signal
- `rst_n`: Active-low reset signal

### To/from DMA / Memory (Port A)

Used for loading data from external memory into BRAM and storing results back to memory.

- `base_addr [ADDR_WIDTH-1:0]`: Base address in BRAM for the current buffer.
- `dma_wr_en`: Write enable. Asserted when DMA write data is valid.
- `dma_wr_data [DATA_WIDTH-1:0]`: Data to be written into BRAM.
- `dma_write_pointer [15:0]`: Offset from `base_addr` for DMA writes.
- `dma_rd_en`: Read enable. Asserted when DMA requests data.
- `dma_rd_data [DATA_WIDTH-1:0]`: Data read from BRAM.
- `dma_read_pointer [15:0]`: Offset from `base_addr` for DMA reads.

All DMA accesses use base-plus-offset addressing:
bram_addr = base_addr + pointer


### To/from Compute (Port B)

Used by compute units such as `compute_top` and the systolic array.

- `dma_comp_addr_b [ADDR_WIDTH-1:0]`: BRAM address for compute access
- `dma_comp_din_b [DATA_WIDTH-1:0]`: Data written by compute
- `dma_comp_dout_b [DATA_WIDTH-1:0]`: Data read by compute
- `dma_comp_en_b`: Compute-side BRAM enable
- `dma_comp_we_b`: Compute-side write enable

Port B provides single-cycle, random-access reads and writes and operates independently of DMA traffic.

# compute_top

`compute_top` is a compute controller that demonstrates how compute kernels interact with the memory subsystem. It operates entirely on BRAM-resident data and has no direct access to external memory.

## Interface

### Control Signals
- `start`: Pulse high to begin computation
- `done`: Pulsed high when computation completes

### Address Signals
- `addr_a_vadd [ADDR_WIDTH-1:0]`: Base address of input A in BRAM
- `addr_b_vadd [ADDR_WIDTH-1:0]`: Base address of input B in BRAM
- `addr_out_vadd [ADDR_WIDTH-1:0]`: Base address of output in BRAM
- `len_vadd [22:0]`: Vector length

### BRAM Interface (Port B)
- `bram_addr_b`
- `bram_din_b`
- `bram_dout_b`
- `bram_en_b`
- `bram_we_b`

## FSM

The flow of the compute FSM is as follows:

IDLE → READ_A → READ_B → WAIT_1 → WAIT_2 → WAIT_3 → WRITE_OUT → DONE



The FSM explicitly accounts for BRAM read latency, performs computation on retrieved operands, writes results back into BRAM, and signals completion via `done`.

## How to test memory subsystem

Simulation-based testing is used to verify correct BRAM behavior and compute interaction. Tests validate DMA addressing, compute-side reads/writes, and end-to-end execution of vector kernels.

## Advanced Features

Our goals for advanced features of the memory subsystem include implementing **double buffering** to overlap load, compute, and store phases, expanding memory banking for higher throughput, and tighter integration with the systolic array datapath.
