#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IMAGE_NAME="${OPENLANE_IMAGE:-efabless/openlane:2023.07.14}"

run_design() {
    local design="$1"
    echo "==> Running OpenLane for $design"
    docker run --rm \
        -e PDK_ROOT=/root/.volare \
        -v "$ROOT_DIR":/work \
        -v "$HOME/.volare":/root/.volare \
        "$IMAGE_NAME" \
        flow.tcl -design "/work/openlane/${design}"
}

run_design "sync_counter"
run_design "gray_counter"
run_design "gray_counter_ce"

echo "All OpenLane runs completed."
