# Low-Power 4-Bit Counter ASIC Project Plan

## Goal

Build a presentation-ready and runnable Linux/WSL project that takes a 4-bit low-power counter from:

RTL -> simulation -> synthesis -> equivalence check -> floorplan/place/CTS/route -> STA -> power -> DRC/LVS -> GDSII

Target open-source tools:

- Icarus Verilog
- Yosys
- Yosys EQY
- OpenROAD
- OpenLane
- OpenSTA
- OpenROAD power analysis
- Magic
- Netgen
- KLayout

## Important Corrections To `info.md`

The current document is useful as a presentation outline, but several points need to be corrected before implementation:

1. The "ripple counter" RTL shown is not a ripple counter.
   It is a normal synchronous counter because every bit updates on the same clock edge.

2. `assign gated_clk = clk & enable;` is not a safe ASIC clock-gating method.
   This can create glitches and is not acceptable for a clean RTL-to-GDSII flow.

3. "Functionally same as ripple in RTL, but in synthesis we will specify synchronous clocking" is incorrect.
   Ripple vs synchronous behavior must be defined in RTL, not by synthesis settings.

4. OpenLane is not usually driven by manually typing `run synth`, `run floorplan`, `run place`, etc. for a class project.
   A reproducible scripted flow is better.

5. `config.json` example is too incomplete for a reliable OpenLane run.
   We need a proper config with clock port, design name, source paths, PDK settings, and run directory conventions.

6. The tool roles overlap:
   OpenLane orchestrates much of the backend flow and internally uses OpenROAD, Magic, Netgen, and KLayout-compatible outputs.
   For the presentation, this is fine, but the execution plan should clearly distinguish "driver flow" vs "underlying engines".

## Recommended Design Scope

Use three versions for comparison:

1. `sync_counter`
   Baseline 4-bit synchronous binary up-counter.

2. `gray_counter`
   4-bit counter with binary state internally and Gray-coded output for reduced output switching.

3. `gray_counter_ce`
   Same as Gray counter, but with a synchronous clock-enable input.
   This is the safest low-power RTL variant for the first project version.

## What To Avoid In Version 1

Avoid a true ripple counter in the ASIC flow unless the presentation explicitly requires it.

Reasons:

- Ripple counters create multiple clock domains internally.
- Timing analysis becomes less clean for a beginner project.
- Backend constraints are harder to explain properly.
- It weakens the "low power and robust implementation" story.

If the presentation requires "ripple vs synchronous", keep ripple as an RTL simulation comparison only, not the main GDSII candidate.

## Recommended Linux/WSL Project Structure

```text
low_power_counter/
├── rtl/
│   ├── sync_counter.v
│   ├── gray_counter.v
│   ├── gray_counter_ce.v
│   └── common_defs.vh
├── tb/
│   ├── sync_counter_tb.v
│   ├── gray_counter_tb.v
│   └── gray_counter_ce_tb.v
├── sim/
│   ├── run_iverilog.sh
│   └── waves/
├── synth/
│   ├── yosys/
│   │   ├── synth_sync.ys
│   │   ├── synth_gray.ys
│   │   └── synth_gray_ce.ys
│   └── reports/
├── formal/
│   ├── eqy_sync.eqy
│   ├── eqy_gray.eqy
│   └── eqy_gray_ce.eqy
├── openlane/
│   ├── sync_counter/
│   │   ├── config.json
│   │   └── src/
│   ├── gray_counter/
│   │   ├── config.json
│   │   └── src/
│   └── gray_counter_ce/
│       ├── config.json
│       └── src/
├── scripts/
│   ├── setup_env.sh
│   ├── run_sim.sh
│   ├── run_synth.sh
│   ├── run_formal.sh
│   ├── run_openlane.sh
│   └── collect_metrics.sh
├── reports/
│   ├── summary.csv
│   └── presentation_tables/
└── README.md
```

## Clean Tool Flow

### 1. RTL Coding

Write portable Verilog-2001 where possible.

Guidelines:

- Use synchronous sequential logic with nonblocking assignments.
- Use active-low reset only if the cell library flow supports it cleanly.
- Prefer clock-enable logic inside the `always @(posedge clk)` block instead of gating the clock in plain RTL.

### 2. RTL Simulation With Icarus Verilog

Purpose:

- Verify counting sequence
- Verify reset behavior
- Verify enable behavior
- Generate VCD waveforms for presentation

### 3. Logic Synthesis With Yosys

Purpose:

- Map RTL into gate-level netlist
- Estimate area/cell usage
- Produce netlist for equivalence checking

### 4. Equivalence Check With EQY

Purpose:

- Prove synthesized netlist matches RTL behavior

### 5. Physical Design With OpenLane

Use OpenLane as the top-level automated driver.

Internally this covers:

- floorplanning
- placement
- CTS
- routing
- signoff generation

### 6. Timing With OpenSTA

Use post-synthesis and post-route timing reports from the OpenLane/OpenROAD flow.

### 7. Power Analysis

Use post-route switching activity when possible.
If SAIF/VCD-based power is too complex for version 1, present comparative internal power estimates consistently across the three designs.

### 8. DRC / LVS / GDSII

- Magic for DRC
- Netgen for LVS
- KLayout for GDS viewing

## Linux/WSL Command Sequence

This is the corrected high-level command sequence to target first.

### Environment Setup

```bash
sudo apt update
sudo apt install -y git make python3 python3-pip build-essential iverilog gtkwave
sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER
```

Then re-login to WSL.

### Clone/Open Project

```bash
mkdir -p ~/asic
cd ~/asic
git clone <your-repo-url> low_power_counter
cd low_power_counter
```

### Pull OpenLane Image

```bash
docker pull efabless/openlane:2023.07.14
```

### RTL Simulation

```bash
mkdir -p sim/waves
iverilog -g2012 -o sim/sync_counter.out rtl/sync_counter.v tb/sync_counter_tb.v
vvp sim/sync_counter.out

iverilog -g2012 -o sim/gray_counter.out rtl/gray_counter.v tb/gray_counter_tb.v
vvp sim/gray_counter.out

iverilog -g2012 -o sim/gray_counter_ce.out rtl/gray_counter_ce.v tb/gray_counter_ce_tb.v
vvp sim/gray_counter_ce.out
```

### Yosys Synthesis

```bash
mkdir -p synth/reports
yosys -s synth/yosys/synth_sync.ys
yosys -s synth/yosys/synth_gray.ys
yosys -s synth/yosys/synth_gray_ce.ys
```

### EQY Formal Equivalence

```bash
eqy formal/eqy_sync.eqy
eqy formal/eqy_gray.eqy
eqy formal/eqy_gray_ce.eqy
```

### OpenLane Runs

From the project root:

```bash
docker run --rm -it \
  -v "$PWD":/work \
  -v "$HOME/.volare":/root/.volare \
  efabless/openlane:2023.07.14 \
  bash
```

Inside the container:

```bash
cd /work
flow.tcl -design openlane/sync_counter
flow.tcl -design openlane/gray_counter
flow.tcl -design openlane/gray_counter_ce
```

### Reports To Collect

Collect for each design:

- cell count
- area
- worst negative slack
- total negative slack
- total power
- leakage power
- routed DEF/GDS presence
- DRC status
- LVS status

## macOS To Linux Portability

Yes, the project can be created on macOS and run on Linux, but only if you keep it environment-neutral.

Safe to create on macOS:

- Verilog RTL
- testbenches
- Yosys scripts
- EQY files
- OpenLane config files
- shell scripts
- README and report files

Things that commonly break portability:

1. Hard-coded macOS paths
   Example: `/Users/name/...`

2. BSD vs GNU command differences
   `sed`, `date`, and `stat` options differ between macOS and Linux.

3. Line endings or executable-bit issues
   Use LF endings and commit executable scripts with `chmod +x`.

4. Native binary assumptions
   Do not rely on macOS-installed EDA binaries for the real run.
   Run the actual ASIC flow inside Linux/WSL or Docker.

5. GUI-only verification steps
   KLayout and GTKWave viewing may differ across systems, but the produced files remain portable.

## Best Practice For Portability

Develop source files on macOS if you want, but validate using:

- WSL Ubuntu, or
- a Linux machine, or
- Dockerized OpenLane on Linux

That means:

- code on macOS is fine
- signoff execution should be treated as Linux-first

## Implementation Plan

### Phase 1: Make The RTL Correct

Deliverables:

- synchronous binary counter
- Gray output counter
- Gray counter with synchronous enable
- testbenches and waveform dumps

### Phase 2: Make The Front-End Flow Reproducible

Deliverables:

- Icarus simulation scripts
- Yosys synthesis scripts
- EQY config files
- pass/fail logs

### Phase 3: Make The Physical Flow Reproducible

Deliverables:

- OpenLane configs
- successful run directories
- post-route reports
- GDSII files

### Phase 4: Make The Presentation Strong

Deliverables:

- comparison table
- waveform screenshots
- floorplan/layout screenshots
- power/timing/area plots

## Presentation Message

The strongest presentation message is:

"We implemented three 4-bit counter architectures and validated the complete open-source ASIC flow from RTL to GDSII. The low-power Gray-code plus clock-enable version reduced switching activity while maintaining a clean synchronous implementation that is easier to verify and sign off."

## Recommended Next Coding Step

Start by implementing only these first:

1. `rtl/sync_counter.v`
2. `rtl/gray_counter.v`
3. `rtl/gray_counter_ce.v`
4. matching testbenches
5. a single `run_sim.sh`

Only after simulation is clean should we write Yosys, EQY, and OpenLane configs.
