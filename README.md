# spi-master-slave-rtl-verification
Overview

This project demonstrates a Serial Peripheral Interface (SPI) communication system implemented in SystemVerilog/Verilog. It focuses on enabling reliable data transfer between a master and a slave device using serial communication. The design is modular, scalable, and suitable for RTL verification exercises and learning SPI protocol behavior.

Features

Master-Slave SPI Communication: Master sends data serially to the slave while controlling the chip select (CS) line.
12-bit Data Transfer: Data is loaded in a temporary register and transmitted serially via MOSI.
Clock Synchronization: All data transfers are synchronized with the clock signal to ensure reliable communication.
Transaction Completion Handling: Master stops transmission and deactivates CS once the transfer is complete.
Testbench Support: Includes a simulation environment to verify correct functionality and observe waveforms.
Modular Design: Separate modules for master, slave, and top-level integration allow easy expansion for additional features or multiple slaves.

Design Modules
spi_master.sv – Handles data loading, serial shifting, MOSI output, and CS control. It initiates communication and completes transactions when data transfer finishes.
spi_slave.sv – Receives serial data from the master, reconstructs the full word, and signals when the transaction is complete.
top_module.sv – Integrates the master and slave modules, providing necessary connections for clock, reset, data, and control signals.
testbench.sv – Provides stimuli to the design, monitors transactions, and allows waveform analysis for verification.

SPI Mode
This project uses SPI Mode 0:
Clock Polarity (CPOL) = 0
Clock Phase (CPHA) = 0
Data is sampled on the rising edge of the clock and transmitted on the falling edge.

Simulation & Verification

The included testbench allows you to:
Observe bit-by-bit data transmission from master to slave.
Monitor the chip select (CS) signal, ensuring correct transaction initiation and termination.
Verify that the slave reconstructs data correctly and signals transaction completion.
Analyze waveforms to understand the timing relationships of clock, MOSI, MISO, and CS signals.

Repository Structure
SPI-Project/
├── rtl/
│   ├── spi_master.sv
│   ├── spi_slave.sv
│   └── top_module.sv
├── testbench/
│   └── testbench.sv
└── README.md


This structure keeps the RTL modules separate from testbench files, making it easier to manage the project and extend it with additional functionality, like multi-slave communication, different SPI modes, or error-checking mechanisms.
