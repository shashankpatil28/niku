# Ubuntu Setup Guide

This guide assumes a fresh Ubuntu machine with no ASIC tools preinstalled.

## 1. Clone the repository

```bash
git clone <your-github-repo-url> low_power_counter
cd low_power_counter
```

## 2. Run the one-time setup script

```bash
chmod +x scripts/setup_ubuntu.sh
./scripts/setup_ubuntu.sh
```

The setup script installs:

- Docker
- Icarus Verilog
- GTKWave
- Yosys
- Python and pip
- Volare
- the OpenLane Docker image
- the required `sky130` PDK revision

## 3. Refresh Docker group permissions

After setup, either log out and log back in or run:

```bash
newgrp docker
```

Then verify Docker:

```bash
docker info
```

## 4. Run the front-end flow

Simulation:

```bash
./scripts/run_sim.sh
```

Synthesis:

```bash
./scripts/run_synth.sh
./scripts/collect_metrics.sh
```

Optional local formal fallback:

```bash
./scripts/run_formal.sh
```

## 5. Run the backend flow

Baseline design:

```bash
./scripts/run_openlane_sync.sh
```

Gray-code design:

```bash
./scripts/run_openlane_gray.sh
```

Low-power Gray-plus-enable design:

```bash
./scripts/run_openlane_gray_ce.sh
```

## 6. Important generated outputs

Simulation waveforms:

- `sim/waves/*.vcd`

Front-end reports:

- `reports/summary.csv`
- `reports/presentation_tables/synthesis_summary.md`

OpenLane outputs:

- `openlane/<design>/runs/<run_id>/reports/metrics.csv`
- `openlane/<design>/runs/<run_id>/reports/manufacturability.rpt`
- `openlane/<design>/runs/<run_id>/results/final/`

## 7. Recommended first presentation path

If you only want to prove one clean baseline and one low-power backend implementation, run:

```bash
./scripts/run_openlane_sync.sh
./scripts/run_openlane_gray_ce.sh
```

