# Mentor Demo Notes

## Demo Goal

Show a clean open-source ASIC-style flow for a low-power 4-bit counter project, with the front-end already validated and the backend prepared.

## What To Say First

"We implemented three versions of a 4-bit counter and compared them using an open-source EDA flow."

The three versions are:

- `sync_counter`: baseline synchronous counter
- `gray_counter`: Gray-coded output to reduce switching
- `gray_counter_ce`: low-power counter with synchronous enable plus Gray-coded output

## Files To Show

### 1. Project plan

- `project_plan.md`

### 2. RTL

- `rtl/sync_counter.v`
- `rtl/gray_counter.v`
- `rtl/gray_counter_ce.v`

### 3. Testbenches

- `tb/sync_counter_tb.v`
- `tb/gray_counter_tb.v`
- `tb/gray_counter_ce_tb.v`

### 4. Simulation outputs

- `sim/waves/sync_counter.vcd`
- `sim/waves/gray_counter.vcd`
- `sim/waves/gray_counter_ce.vcd`

### 5. Synthesis outputs

- `reports/summary.csv`
- `reports/presentation_tables/synthesis_summary.md`
- `synth/reports/*_netlist.v`

### 6. Formal and backend prep

- `formal/*.eqy`
- `formal/*.ys`
- `openlane/*/config.json`

## Commands To Run Live

### Simulation

```bash
./scripts/run_sim.sh
```

### Synthesis

```bash
./scripts/run_synth.sh
./scripts/collect_metrics.sh
```

### Formal equivalence

```bash
./scripts/run_formal.sh
```

### Show comparison table

```bash
cat reports/summary.csv
cat reports/presentation_tables/synthesis_summary.md
```

### Backend command prepared for Linux or Docker

```bash
./scripts/run_openlane.sh
```

## What Is Complete

- RTL coding
- testbenches
- simulation flow
- synthesis flow
- synthesis comparison table
- formal equivalence configs and local fallback scripts
- OpenLane design/config setup
- full backend run completed for `sync_counter`

## What Still Depends On Backend Runtime

- final equivalence proof closure with EQY or Linux-based formal flow
- actual OpenLane execution
- timing reports from routed design
- power reports
- DRC/LVS reports
- final GDSII screenshots

## Strong Closing Line

"The baseline counter has completed the full OpenLane backend flow, and the low-power Gray-plus-enable counter is the next backend candidate for power-oriented comparison."
