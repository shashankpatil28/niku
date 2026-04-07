#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPORT_DIR="$ROOT_DIR/synth/reports"

mkdir -p "$REPORT_DIR"

run_synth() {
    local name="$1"
    local script="$2"

    echo "==> Synthesizing $name"
    yosys -s "$script" | tee "$REPORT_DIR/${name}_yosys.log"
}

run_synth "sync_counter" "$ROOT_DIR/synth/yosys/synth_sync.ys"
run_synth "gray_counter" "$ROOT_DIR/synth/yosys/synth_gray.ys"
run_synth "gray_counter_ce" "$ROOT_DIR/synth/yosys/synth_gray_ce.ys"

echo "All synthesis runs completed successfully."
