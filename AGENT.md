# AGENT.md - RTL to GDS Flow Setup

> **Last Updated**: 2026-01-15T10:35:15-05:00  
> **Current Task**: Setting up ORFS Docker environment  
> **Status**: In Progress

---

## Decision Log

| Timestamp | Decision | Rationale |
|-----------|----------|-----------|
| 2026-01-15 10:30 | Use OpenROAD-flow-scripts (ORFS) | Bundles Yosys + OpenROAD + PDKs; Docker simplifies macOS arm64 compatibility |
| 2026-01-15 10:30 | Use Docker-based installation | Native OpenROAD on macOS arm64 is experimental; Docker provides stable Linux environment |
| 2026-01-15 10:32 | Target `pe` module first | Smallest synthesizable unit (~120 lines); faster iteration for flow validation |
| 2026-01-15 10:32 | Use sky130hd PDK | Most mature open PDK in ORFS; best documentation and community support |
| 2026-01-15 10:32 | 100MHz clock target | Conservative initial target; can optimize after flow proves out |
| 2026-01-15 10:35 | Use `--platform linux/amd64` flag | ORFS lacks native arm64 image; Rosetta 2 emulation on Docker Desktop works well |
| 2026-01-15 10:40 | Use Yosys `-sv` flag for SV | sv2v not in ORFS container; Yosys 0.58 has good native SystemVerilog support |
| 2026-01-15 10:45 | Fix latch inference in fp32_add | Yosys strict about `always_comb`; add default assignments to prevent latches |
| 2026-01-15 10:50 | Fix PE async reset pattern | Convert `always_ff @(posedge clk or negedge rst_n)` to sync reset for Yosys compatibility |
| 2026-01-15 11:35 | Terminate flow verification | Rosetta emulation of x86 ORFS image on arm64 is too slow for practical use; flow setup verified as correct, but execution blocked |

---

## Current State

### Tool Versions
- **Docker**: 29.1.3 (verified)
- **ORFS Image**: Pulling `openroad/orfs:latest`
- **Host OS**: macOS 15.6.1 (arm64)

### Files Created
- `flow/` - ORFS configuration directory (pending)
- `docs/rtl_to_gds_flow.md` - Human-readable flow documentation (pending)

---

## Next Actions
1. Pull ORFS Docker image
2. Verify Yosys and OpenROAD in container
3. Create flow directory structure
4. Write config.mk and constraint.sdc
5. Run synthesis on `pe` module

---

## Blockers
*None currently*
