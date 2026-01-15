# RTL to GDS Flow Documentation

## Overview

This document describes the open-source RTL-to-GDS flow for the CornellTPU project using:
- **Yosys**: Logic synthesis
- **OpenROAD**: Physical design (floorplan → routing)
- **KLayout**: GDS generation and DRC

All tools are accessed via the **OpenROAD-flow-scripts (ORFS)** Docker container.

---

## Quick Start

```bash
# Navigate to flow directory
cd /Users/sunwookim028/projects/CornellTPU/flow

# Run full RTL-to-GDS flow
./run_flow.sh pe

# Or step by step:
make synth DESIGN_CONFIG=designs/pe/config.mk      # Synthesis
make floorplan DESIGN_CONFIG=designs/pe/config.mk  # Floorplan
make place DESIGN_CONFIG=designs/pe/config.mk      # Placement
make cts DESIGN_CONFIG=designs/pe/config.mk        # Clock Tree Synthesis
make route DESIGN_CONFIG=designs/pe/config.mk      # Routing
make final DESIGN_CONFIG=designs/pe/config.mk      # GDS generation
```

---

## Directory Structure

```
flow/
├── Makefile               # Main build orchestration
├── run_flow.sh            # Convenience wrapper script
├── designs/
│   └── pe/
│       ├── config.mk      # Design parameters
│       └── constraint.sdc # Timing constraints
├── results/               # Output files (generated)
│   └── sky130hd/pe/
│       ├── 1_synth.v      # Synthesized netlist
│       ├── 2_floorplan.def
│       ├── 3_place.def
│       ├── 4_cts.def
│       ├── 5_route.def
│       └── 6_final.gds    # Final layout
└── logs/                  # Flow logs (generated)
```

---

## Design Configuration

### config.mk Parameters

| Parameter | Value | Description |
|-----------|-------|-------------|
| `DESIGN_NAME` | pe | Top module name |
| `PLATFORM` | sky130hd | Target PDK |
| `CLOCK_PERIOD` | 10.0 | Clock period in ns (100MHz) |
| `CORE_UTILIZATION` | 45 | Core area utilization % |
| `PLACE_DENSITY` | 0.6 | Placement density |

### constraint.sdc

Timing constraints include:
- Clock definition on `clk` port
- Input delay: 2ns (from external registers)
- Output delay: 2ns (to external registers)

---

## Flow Stages

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   RTL       │───▶│   Synth     │───▶│  Floorplan  │
│ (pe.sv)     │    │  (Yosys)    │    │ (OpenROAD)  │
└─────────────┘    └─────────────┘    └─────────────┘
                                             │
┌─────────────┐    ┌─────────────┐    ┌──────▼──────┐
│  GDS Out    │◀───│   Route     │◀───│   Place     │
│ (KLayout)   │    │ (OpenROAD)  │    │ (OpenROAD)  │
└─────────────┘    └─────────────┘    └─────────────┘
```

---

## Viewing Results

### Open GDS in KLayout
```bash
docker run --rm -v $(pwd):/work openroad/orfs:latest \
  klayout -l /work/results/sky130hd/pe/6_final.gds
```

### Check Timing Reports
```bash
cat flow/logs/sky130hd/pe/base/5_route.log | grep "Slack"
```

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Docker permission denied | Run: `sudo usermod -aG docker $USER` then re-login |
| Synthesis fails on SV | Ensure `read_verilog -sv` flag is set in flow |
| Timing violations | Increase `CLOCK_PERIOD` or reduce `CORE_UTILIZATION` |
| DRC errors | Check `logs/` for specific violations |

---

## References

- [OpenROAD Documentation](https://openroad.readthedocs.io/)
- [ORFS GitHub](https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts)
- [SkyWater PDK](https://skywater-pdk.readthedocs.io/)
