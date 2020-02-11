# hashpipe

Hashpipe is a SHA-256 hashing engine implemented in VHDL. It is designed as
a systolic pipeline, producing one hash per clock cycle.

## Performance

The core has been synthesized and simulated in Quartus II on an Altera Cyclone III 120K
FPGA. Two instances fit on this device, with an Fmax of approximately 70 MHz,
thus producing together 140 MHash/sec.
