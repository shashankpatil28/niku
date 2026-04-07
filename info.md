Final Toolchain Summary
Design Stage
Selected Tool
Justification
RTL Simulation
Icarus Verilog
Best waveform visibility and accuracy
Logic Synthesis
Yosys
Only open-source tool with clock gating and power optimization
Formal Verification
Yosys EQY
Ensures RTL and gate-level equivalence
Floorplanning, CTS, Routing
OpenROAD
Only open-source backend tool with full modern ASIC capabilities
End-to-End Flow
OpenLane
Silicon-proven RTL-to-GDSII automation
Static Timing Analysis
OpenSTA
Liberty-based STA compatible with OpenROAD
Power Analysis
OpenROAD Power
Accurate post-layout power estimation
DRC
Magic
Foundry-rule compliant verification
LVS
Netgen
Layout-to-netlist matching
GDS Viewing
KLayout
Industry-standard open viewer




Perfect! Let’s make a complete WSL Ubuntu workflow for your project where you:
Implement different 4-bit counters
Ripple (async)
Synchronous
Synchronous Gray + Clock Gating (low power)
Use power-saving techniques (clock gating, Gray code, low switching logic)
Run the full RTL → GDSII flow in OpenLane
Compare area, timing, power
I’ll give a step-by-step flow with all commands, folder structure, and instructions.

⚡ Step 0: Setup WSL Environment
# Update Ubuntu
sudo apt update && sudo apt upgrade -y

# Install dependencies
sudo apt install -y git docker.io python3-pip build-essential

# Start Docker
sudo service docker start

# Pull OpenLane Docker image
docker pull efabless/openlane:2023.07.14

# Optional: Install GDS viewer



Step 1: Create Project Folder Structure

cd ~/openlane/designs

# Create folders for each counter type
mkdir ripple sync gray_gated
Folder structure:
designs/
├── ripple/
├── sync/
└── gray_gated/

Step 2: Create RTL for Each Counter
2.1 Ripple Counter (Async)
ripple/counter.v
module counter (
   input clk,
   input rst_n,
   output reg [3:0] q
);

always @(posedge clk or negedge rst_n) begin
   if(!rst_n)
       q <= 4'b0;
   else
       q <= q + 1;
end

endmodule

2.2 Synchronous Counter
sync/counter.v
module counter (
   input clk,
   input rst_n,
   output reg [3:0] q
);

always @(posedge clk or negedge rst_n) begin
   if(!rst_n)
       q <= 4'b0;
   else
       q <= q + 1;
end

endmodule
Functionally same as ripple in RTL, but in synthesis we will specify synchronous clocking.

2.3 Low-Power Synchronous Gray Counter with Clock Gating
gray_gated/counter.v
module counter (
   input clk,
   input rst_n,
   input enable,
   output reg [3:0] gray
);

wire gated_clk;
assign gated_clk = clk & enable; // Clock gating

reg [3:0] bin_count;
always @(posedge gated_clk or negedge rst_n) begin
   if(!rst_n)
       bin_count <= 4'b0;
   else
       bin_count <= bin_count + 1;
end

always @(*) begin
   gray[3] = bin_count[3];
   gray[2] = bin_count[3] ^ bin_count[2];
   gray[1] = bin_count[2] ^ bin_count[1];
   gray[0] = bin_count[1] ^ bin_count[0];
end

endmodule
✅ Features: Gray code reduces switching, clock gating reduces dynamic power.

Step 3: Create OpenLane config.json for Each Design
Example gray_gated/config.json:
{
 "top_module": "counter",
 "rtl": ["counter.v"],
 "clock_period": 10,
 "vdd": 1.8,
 "technology": "sky130_fd_sc_hd"
}
Copy this for ripple and sync folders, change paths if needed.

Step 4: Run OpenLane Interactive Flow
docker run -it --rm -v ~/openlane:/openlane efabless/openlane:2023.07.14 /bin/bash
Navigate to the design folder:
cd /openlane/designs/gray_gated
flow.tcl -interactive

Step 5: Run Each Step in OpenLane
# 1️⃣ RTL Synthesis
run synth

# 2️⃣ Floorplan & Placement
run floorplan
run place

# 3️⃣ Clock Tree Synthesis
run cts

# 4️⃣ Routing
run route

# 5️⃣ Signoff Checks
run drc
run lvs
run power

# 6️⃣ GDS Generation
run gds
Repeat for ripple and sync folders.

Step 6: Compare Results
After flow completes, compare power, area, timing:
# Example: Power
cat ~/openlane/designs/gray_gated/results/power/power_report.txt
cat ~/openlane/designs/sync/results/power/power_report.txt
cat ~/openlane/designs/ripple/results/power/power_report.txt

# Synthesis reports (area, timing)
cat ~/openlane/designs/gray_gated/results/synthesis/report.txt
cat ~/openlane/designs/sync/results/synthesis/report.txt
cat ~/openlane/designs/ripple/results/synthesis/report.txt
✅ Metrics to collect:
Counter Type
Dynamic Power
Leakage Power
Total Power
Area
Max Frequency
Ripple










Synchronous










Gray + ClockGating












Step 7: Visualize Layout (Optional)
klayout ~/openlane/designs/gray_gated/results/gds/counter.gds &
klayout ~/openlane/designs/sync/results/gds/counter.gds &
klayout ~/openlane/designs/ripple/results/gds/counter.gds &
Compare routing congestion, cell placement, and area.

Step 8: Key Notes for Presentation
Low-Power Techniques Used:
Clock gating → reduces FF toggling
Gray code → reduces bit switching
Low-power cell libraries → reduce leakage
Comparison:
Ripple → simplest, but highest switching → higher dynamic power
Synchronous → better timing, moderate power
Gray + gated → lowest power, slightly larger area
Show live interactive OpenLane flow for each counter type.

I can also write a ready-to-run WSL shell script that will:
Set up all three counters
Run OpenLane flow automatically
Extract area, power, frequency into a CSV for comparison
