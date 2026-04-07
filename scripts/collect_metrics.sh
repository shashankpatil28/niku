#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPORT_DIR="$ROOT_DIR/synth/reports"
SUMMARY_FILE="$ROOT_DIR/reports/summary.csv"

mkdir -p "$ROOT_DIR/reports"

extract_cells() {
    local stat_file="$1"
    awk '/^[[:space:]]+[0-9]+ cells$/ {print $1; exit}' "$stat_file"
}

extract_wires() {
    local stat_file="$1"
    awk '/^[[:space:]]+[0-9]+ wire bits$/ {print $1; exit}' "$stat_file"
}

{
    echo "design,cell_count,wire_bits"
    for design in sync_counter gray_counter gray_counter_ce; do
        stat_file="$REPORT_DIR/${design}_stat.txt"
        if [[ -f "$stat_file" ]]; then
            echo "${design},$(extract_cells "$stat_file"),$(extract_wires "$stat_file")"
        fi
    done
} > "$SUMMARY_FILE"

echo "Wrote $SUMMARY_FILE"

cat > "$ROOT_DIR/reports/presentation_tables/synthesis_summary.md" <<EOF
# Synthesis Summary

| Design | Cell Count | Wire Bits | Note |
|---|---:|---:|---|
| sync_counter | $(extract_cells "$REPORT_DIR/sync_counter_stat.txt") | $(extract_wires "$REPORT_DIR/sync_counter_stat.txt") | Baseline synchronous binary counter |
| gray_counter | $(extract_cells "$REPORT_DIR/gray_counter_stat.txt") | $(extract_wires "$REPORT_DIR/gray_counter_stat.txt") | Gray-coded output adds XOR logic |
| gray_counter_ce | $(extract_cells "$REPORT_DIR/gray_counter_ce_stat.txt") | $(extract_wires "$REPORT_DIR/gray_counter_ce_stat.txt") | Enable-aware low-power version |
EOF

echo "Wrote $ROOT_DIR/reports/presentation_tables/synthesis_summary.md"
