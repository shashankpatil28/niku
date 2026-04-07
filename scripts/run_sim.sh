#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SIM_DIR="$ROOT_DIR/sim"
WAVE_DIR="$SIM_DIR/waves"

mkdir -p "$SIM_DIR" "$WAVE_DIR"

run_test() {
    local name="$1"
    local rtl_file="$2"
    local tb_file="$3"
    local output_file="$SIM_DIR/${name}.out"

    echo "==> Compiling $name"
    iverilog -g2012 -I "$ROOT_DIR/rtl" -o "$output_file" "$rtl_file" "$tb_file"

    echo "==> Running $name"
    vvp "$output_file"
}

run_test "sync_counter" "$ROOT_DIR/rtl/sync_counter.v" "$ROOT_DIR/tb/sync_counter_tb.v"
run_test "gray_counter" "$ROOT_DIR/rtl/gray_counter.v" "$ROOT_DIR/tb/gray_counter_tb.v"
run_test "gray_counter_ce" "$ROOT_DIR/rtl/gray_counter_ce.v" "$ROOT_DIR/tb/gray_counter_ce_tb.v"

echo "All simulations completed successfully."
