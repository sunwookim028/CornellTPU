#!/bin/bash
#
# run_flow.sh - RTL to GDS Flow Runner
# Wrapper script for OpenROAD-flow-scripts with Docker
#
# Usage: ./run_flow.sh <design> [target]
#   design: pe, systolic, etc.
#   target: synth, floorplan, place, cts, route, final, gui (default: final)

set -e

DESIGN=${1:-pe}
TARGET=${2:-final}
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "=== RTL to GDS Flow ==="
echo "Design: $DESIGN"
echo "Target: $TARGET"
echo "Project: $PROJECT_ROOT"
echo ""

# Run ORFS in Docker container
docker run --rm \
    --platform linux/amd64 \
    -v "$PROJECT_ROOT":/work \
    -w /OpenROAD-flow-scripts/flow \
    openroad/orfs:latest \
    make $TARGET \
        DESIGN_HOME=/work/flow/designs \
        DESIGN_CONFIG=/work/flow/designs/$DESIGN/config.mk \
        FLOW_HOME=/OpenROAD-flow-scripts/flow \
        RESULTS_DIR=/work/flow/results \
        LOGS_DIR=/work/flow/logs \
        REPORTS_DIR=/work/flow/reports

echo ""
echo "=== Flow Complete ==="
echo "Results: $PROJECT_ROOT/flow/results/sky130hd/$DESIGN/"
echo "Logs:    $PROJECT_ROOT/flow/logs/sky130hd/$DESIGN/"
