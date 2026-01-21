# AXI4-Lite Master & Slave Controller

## Overview
This project implements a complete **AXI4-Lite** communication system in Verilog. It consists of a synthesizeable Master controller and a Slave peripheral with internal memory, designed for SoC (System-on-Chip) integration.

## Key Features
* **Protocol Compliance:** AMBA AXI4-Lite (32-bit Address, 32-bit Data).
* **Master Module:** Initiates Write transactions with a 4-state FSM.
* **Slave Module:** Responds to requests and includes a 16-word internal register file.
* **Verification:** Verified using a self-checking testbench with waveform analysis.

## Verification Results
The simulation below demonstrates a successful **Write-then-Read** transaction.
1.  **Write:** Data `0xCAFEBABE` is written to Address `0x0`.
2.  **Read:** The same address is read back, confirming data integrity.

![Waveform Verification](docs/waveform_verification.png)

## Folder Structure
* `rtl/`: Synthesizeable design files (Master & Slave).
* `tb/`: Simulation testbenches.
* `docs/`: Verification results and diagrams.