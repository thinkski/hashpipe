sha256
======

This is a VHDL implementation in RTL of a SHA-256 hasher using systolic pipeline
architecture.

Performance
-----------
The core has been synthesize and simulated in ISE on a Xilinx Cyclone III 120K
FPGA. Two instances fit on this device, with an Fmax of approximately 70 MHz,
thus producing together 140 MHash/sec.
