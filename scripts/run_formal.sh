#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPORT_DIR="$ROOT_DIR/formal/reports"

mkdir -p "$REPORT_DIR"

run_formal() {
    local name="$1"
    local script="$2"

    echo "==> Running formal equivalence for $name"
    yosys -s "$script" | tee "$REPORT_DIR/${name}_formal.log"
}

run_formal "sync_counter" "$ROOT_DIR/formal/equiv_sync.ys"
run_formal "gray_counter" "$ROOT_DIR/formal/equiv_gray.ys"
run_formal "gray_counter_ce" "$ROOT_DIR/formal/equiv_gray_ce.ys"

echo "All local formal checks completed successfully."
