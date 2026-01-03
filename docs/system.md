
# System

## Index

- [Architecture](#architecture)
- [AXI4-Lite Control Plane](#axi4-lite-control-plane)
- [ISA](#isa)
- [Programming Model](#programming-model)

This section documents the architecture, programming model, and instruction set of the TPU accelerator. The system consists of a DMA, an AXI-Lite control interface, and a custom ISA executed by on-chip compute engines.

## Architecture


The Darker lines represent data movement (fp32 data or 64 bit instructions). tpu_mode is sent to BRAM and IRAM as based on current mode, the appropriate write enable signal must be asserted. 

Diagram is not to scale.


## AXI4-Lite Control Plane

The TPU exposes a memory-mapped AXI4-Lite control interface used by the host to control execution and query status. 15 registers are available with 5 registers currently being used. All registers are 32 bits.

| Offset | Name          | Access | Description |
|--------|---------------|--------|-------------|
| 0x00   | tpu_mode      | R/W    | tpu mode (write_iram, read_bram, write_bram, compute) |
| 0x04   | instr_ready   | R      | Status register for configuring mode (busy, done) |
| 0x08   | stream_ready  | R      | Status register for streaming data (busy, done) |
| 0x0C   | addr_ram      | R/W    | Base address for bram or iram reads/writes |
| 0x10   | RESERVED      | —      | Reserved |
| 0x14   | RESERVED      | —      | Reserved |
| 0x18   | dma_len       | R/W    | Number of data words to stream |
| 0x1C   | RESERVED      | —      | Reserved |
| 0x20   | RESERVED      | —      | Reserved |
| 0x24   | RESERVED      | —      | Reserved |
| 0x28   | RESERVED      | —      | Reserved |
| 0x2C   | RESERVED      | —      | Reserved |
| 0x30   | RESERVED      | —      | Reserved |
| 0x34   | RESERVED      | —      | Reserved |
| 0x38   | RESERVED      | —      | Reserved |

### Register Details

#### tpu_mode (0x00)

This register configures the tpu's operating mode. Only bits **[2:0]** are used, upper bits reserved and read as zero. Can configure to the following operating modes:

| Value | Mode        | Description |
|-------|-------------|-------------|
| 0x0   | IDLE        | TPU idle state (no operation) |
| 0x1   | WRITE_BRAM  | Stream data into BRAM |
| 0x2   | READ_BRAM   | Stream data out of BRAM |
| 0x3   | COMPUTE     | Execute instructions from IRAM |
| 0x4   | WRITE_IRAM  | Stream intructions into IRAM |

**Preconditions:**  
- `instr_ready` **must be asserted** before writing a value to `tpu_mode`.

**Mode Transition Requirement:**  
The TPU **must be placed in `IDLE (0x0)` before transitioning to any other mode**.
Direct transitions between non-idle modes are not supported. 

---

#### instr_ready (0x04)

This register indicates whether the TPU is ready to accept a new operating mode.  
Only bit **[0]** is used, upper bits are reserved and read as zero.


When `instr_ready = 1`, host can safely write to `tpu_mode` to initiate a new operation. When `instr_ready = 0`, the TPU is actively executing and must not be reconfigured.

This register is **read-only** and is updated by hardware.

---

#### stream_ready (0x08)

This register indicates whether the TPU is ready to stream data into.  
Only bit **[0]** is used, upper bits are reserved and read as zero.


When `stream_ready = 1`, host can safely start streaming data through DMA into TPU. When `stream_ready = 0`, the TPU is not ready to receive streamed data.

This register is **read-only** and is updated by hardware.

---

#### addr_ram (0x0C)

This register specifies the base address within on-chip memory (BRAM or IRAM) from which data is read or to which data is written, depending on the current operating mode. Bits [12:0] are used, and upper bits reserved, when writing to/reading from BRAM since current depth is 8192 words. When writing to IRAM, bits [7:0] are used, and upper bits reserved, since IRAM currently holds only 256 instructions.


During memory read or write modes, data transfers begin at the address specified by `addr_ram`. The address space referenced by `addr_ram` is a compiler-managed virtual address space over on-chip memory. The interpretation of this address (BRAM vs. IRAM) depends on the selected `tpu_mode`.

---

#### dma_len (0x18)

This register specifies the number of data words to be transferred over the AXI-Stream interface during BRAM read/write or IRAM write operations. All 32 bits are used, however, currently host must ensure they dont send more than 256 instructions or 8192 words.


During stream-based operations, the TPU transfers exactly `dma_len` words starting from the base address specified in `addr_ram`. The host is responsible for ensuring that the DMA transfer length matches `dma_len` as TPU wont save/accept any data sent after `dna_len` words sent.

**Example:**  
To read 8 consecutive words from BRAM starting at address 0x02:
```text
tpu_mode = 2
addr_ram = 2
dma_len  = 8
```

## ISA

CornellTPU uses a fixed-width instruction format to control on-chip compute engines. Instructions operate on data stored in on-chip memory (BRAM) using a compiler-managed virtual address space.

Two primary instruction classes are supported:

Systolic instructions for matrix-style computation

VPU instructions for element-wise vector operations

All instructions are fetched sequentially from IRAM and executed in program order.

**Instruction Modes**

| MODE Value | Meaning               |
| ---------: | --------------------- |
|     0      | VPU instruction       |
|     1      | Systolic instruction  |
|     2      | Vadd                  |
|     3      | Halt                  |

**Note:** Vadd is a simple test compute unit that adds two vectors together. It exists just to test the system and is not used during real operations.



**Systolic instruction format**


| Field    | Bits    | Description                               |
| -------- | ------- | ----------------------------------------- |
| MODE     | [63:62] | Must be set to `1` (Systolic instruction) |
| ADDR_A   | [61:49] | Base address of input matrix A            |
| ADDR_B   | [48:36] | Base address of input matrix B            |
| ADDR_OUT | [35:23] | Base address of output matrix             |
| LEN      | [22:0]  | Number of words to process                |

**Note:** Currently systolic array only does 4x4 matrix operations so len isn't used.


**VPU instruction format**


| Field      | Bits    | Description                            |
| ---------- | ------- | -------------------------------------- |
| MODE       | [63:62] | Must be set to `0` (VPU instruction)   |
| ADDR_A     | [61:49] | Base address of input vector A         |
| ADDR_B     | [48:36] | Base address of input vector B         |
| ADDR_OUT   | [35:23] | Base address of output vector          |
| ADDR_CONST | [22:10] | Base address of constant element       |
| OPCODE     | [9:0]   | VPU operation selector                 |


**VPU opcodes**

| Opcode | Mnemonic        | Operation                   |
| -----: | --------------- | --------------------------- |
|      0 | ADD             | Element-wise addition       |
|      1 | SUB             | Element-wise subtraction    |
|      2 | RELU            | Rectified Linear Unit       |
|      3 | MUL             | Element-wise multiplication |
|      4 | RELU_DERIVATIVE | ReLU derivative             |

**Note:** Currently each vpu instruction assumes vector length of 1 so to process vectors of longer lengths host side software writes loops to issue multiple instructions. This will eventually be changed to be done on the hardware however.


---

### Notes

- Unused fields must be written as zero
- invalid mode values result in undefined behavior
- Instruction with `MODE = Halt` indicates end of instructions and TPU transitions to IDLE state. All instruction sets must end with a halt instruction.
- Future instruction classes may be added by extending the `MODE` field.


## Programming Model


**Host Responsibilities**

The host (software runtime) is responsible for:

- Allocating host (DDR) buffers for instructions, inputs, and outputs
- Programming DMA transfers to move data between DDR and on-chip memory
- Configuring TPU control registers via AXI4-Lite
- Initiating execution and monitoring completion
- Reading results back from host memory

The TPU does not autonomously fetch data from host memory and does not program the DMA. We use PYNQ in our host model to do a lot of the above.


**Execution Lifecycle**

A typical TPU program execution proceeds as follows:

1. Prepare host buffers by allocating DDR buffers for: Input data, Output data, Instruction stream

2. Load data into BRAM

3. Load instructions into IRAM

4. Start execution

5. Wait for completion

6. Read data (results) from BRAM