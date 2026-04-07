#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <design_name>" >&2
    echo "Example: $0 gray_counter_ce" >&2
    exit 1
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IMAGE_NAME="${OPENLANE_IMAGE:-efabless/openlane:2023.07.14}"
DESIGN_NAME="$1"
DESIGN_DIR="$ROOT_DIR/openlane/$DESIGN_NAME"

if [[ ! -d "$DESIGN_DIR" ]]; then
    echo "OpenLane design directory not found: $DESIGN_DIR" >&2
    exit 1
fi

if [[ ! -d "$HOME/.volare" ]]; then
    echo "PDK cache directory not found: $HOME/.volare" >&2
    echo "Run: python3 -m volare enable --pdk sky130 78b7bc32ddb4b6f14f76883c2e2dc5b5de9d1cbc" >&2
    exit 1
fi

echo "==> Running OpenLane for $DESIGN_NAME"
docker run --rm \
    -e PDK_ROOT=/root/.volare \
    -v "$ROOT_DIR":/work \
    -v "$HOME/.volare":/root/.volare \
    "$IMAGE_NAME" \
    flow.tcl -design "/work/openlane/$DESIGN_NAME"
