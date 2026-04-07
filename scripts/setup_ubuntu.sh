#!/usr/bin/env bash

set -euo pipefail

OPENLANE_IMAGE="${OPENLANE_IMAGE:-efabless/openlane:2023.07.14}"
SKY130_REVISION="${SKY130_REVISION:-78b7bc32ddb4b6f14f76883c2e2dc5b5de9d1cbc}"

echo "==> Updating apt package index"
sudo apt update

echo "==> Installing Ubuntu packages"
sudo apt install -y \
    ca-certificates \
    curl \
    docker.io \
    git \
    gtkwave \
    iverilog \
    make \
    python3 \
    python3-pip \
    ripgrep \
    yosys

echo "==> Enabling Docker service"
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker "$USER"

echo "==> Installing Volare"
python3 -m pip install --upgrade --no-cache-dir volare

echo "==> Pulling OpenLane image"
sudo docker pull "$OPENLANE_IMAGE"

echo "==> Enabling sky130 PDK revision $SKY130_REVISION"
python3 -m volare enable --pdk sky130 "$SKY130_REVISION"

cat <<EOF

Setup complete.

Important:
1. Log out and log back in, or run: newgrp docker
2. Then verify Docker access:
   docker info
3. Recommended first checks:
   ./scripts/run_sim.sh
   ./scripts/run_synth.sh
   ./scripts/collect_metrics.sh
4. First backend run:
   ./scripts/run_openlane_sync.sh

EOF
