#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "==> Removing generated simulation outputs"
rm -f "$ROOT_DIR"/sim/*.out
rm -f "$ROOT_DIR"/sim/waves/*.vcd

echo "==> Removing generated synthesis and formal reports"
rm -rf "$ROOT_DIR"/synth/reports
rm -rf "$ROOT_DIR"/formal/reports

echo "==> Removing generated OpenLane run directories"
rm -rf "$ROOT_DIR"/openlane/sync_counter/runs
rm -rf "$ROOT_DIR"/openlane/gray_counter/runs
rm -rf "$ROOT_DIR"/openlane/gray_counter_ce/runs

echo "==> Removing generated summary CSV"
rm -f "$ROOT_DIR"/reports/summary.csv

echo "Generated outputs removed."
