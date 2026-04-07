# Low-Power 4-Bit Counter ASIC Flow

This repository contains a presentation-focused open-source ASIC project for a 4-bit counter family using:

- Icarus Verilog
- Yosys
- Yosys EQY configs
- OpenLane
- OpenROAD / OpenSTA
- Magic
- Netgen
- KLayout-compatible outputs

The project compares three designs:

- `sync_counter`
  Baseline synchronous binary counter
- `gray_counter`
  Binary counter with Gray-coded output
- `gray_counter_ce`
  Low-power counter with synchronous enable plus Gray-coded output

## Recommended Environment

Primary target:

- Ubuntu Linux with Docker

This repository also worked on macOS with Colima in development, but the clean reproducible path for classmates is Ubuntu.

## Fresh Ubuntu Setup

Clone the repository and run:

```bash
chmod +x scripts/setup_ubuntu.sh
./scripts/setup_ubuntu.sh
```

Detailed Ubuntu instructions are in [SETUP_UBUNTU.md](SETUP_UBUNTU.md).

Before creating the first clean GitHub commit from a working directory that already has generated outputs, run:

```bash
chmod +x scripts/clean_generated.sh
./scripts/clean_generated.sh
```

## Quick Start

Simulation:

```bash
./scripts/run_sim.sh
```

Synthesis and front-end metrics:

```bash
./scripts/run_synth.sh
./scripts/collect_metrics.sh
```

Optional local formal fallback:

```bash
./scripts/run_formal.sh
```

Backend runs:

```bash
./scripts/run_openlane_sync.sh
./scripts/run_openlane_gray.sh
./scripts/run_openlane_gray_ce.sh
```

## Important Files

RTL:

- [sync_counter.v](rtl/sync_counter.v)
- [gray_counter.v](rtl/gray_counter.v)
- [gray_counter_ce.v](rtl/gray_counter_ce.v)

Testbenches:

- [sync_counter_tb.v](tb/sync_counter_tb.v)
- [gray_counter_tb.v](tb/gray_counter_tb.v)
- [gray_counter_ce_tb.v](tb/gray_counter_ce_tb.v)

OpenLane configs:

- [sync_counter config](openlane/sync_counter/config.json)
- [gray_counter config](openlane/gray_counter/config.json)
- [gray_counter_ce config](openlane/gray_counter_ce/config.json)

## Generated Outputs

Front-end generated outputs:

- `sim/waves/*.vcd`
- `synth/reports/`
- `reports/summary.csv`

Backend generated outputs:

- `openlane/<design>/runs/<run_id>/reports/metrics.csv`
- `openlane/<design>/runs/<run_id>/reports/manufacturability.rpt`
- `openlane/<design>/runs/<run_id>/results/final/`

These are intentionally ignored in git by `.gitignore`.

## Presentation Notes

Mentor/demo notes:

- [presentation_notes.md](presentation_notes.md)

Project planning notes:

- [project_plan.md](project_plan.md)
