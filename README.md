#...................AHB-APB Bridge Implementation...............#


Project Overview
This repository contains the design and implementation of an AHB (Advanced High-performance Bus) to APB (Advanced Peripheral Bus) bridge. The project includes the following key components:

AHB Slave
APB Controller
2-Stage Pipeline with a Maximum of 2-Cycle Latency
Project Structure
AHB-Slave: The AHB Slave module is responsible for receiving data and control signals from the AHB master. It handles the decoding of address and control signals and forwards the appropriate information to the APB Controller. The AHB Slave ensures proper handshaking and data transfer with minimal latency.

APB Controller: The APB Controller is designed to manage the communication between the AHB Slave and the APB peripherals. It generates the necessary control signals for the APB bus, ensuring proper timing and sequencing of data transfers. The controller handles various APB protocols, supporting efficient data exchange between the AHB and APB buses.

2-Stage Pipeline: The design incorporates a 2-stage pipeline to optimize the performance of the bridge. The pipeline structure allows for overlapping instruction execution, minimizing the data transfer time between the AHB and APB buses. The design is optimized for a maximum latency of 2 cycles, ensuring high-speed communication in SoC environments.

Key Features
Verilog/SystemVerilog Implementation: The AHB-APB bridge and associated components are implemented in Verilog/SystemVerilog, allowing for precise control over hardware behavior and timing.

CMOS Compatibility: The design is compatible with CMOS technology, making it suitable for integration into modern SoC designs.

Protocol Support: The project supports various SoC protocols, ensuring robust communication between the AHB and APB buses.


AHB-APB Bridge Overview

The AHB-APB bridge is responsible for converting high-speed transactions on the AHB
bus to low-speed transactions on the APB bus. This bridge allows the AHB master to
communicate with APB peripheral devices.
AHB Interface Signals
 H_CLK: Clock signal for AHB operations.
 H_RESET: Active low reset signal.
 H_ADDR: Address bus, used by the AHB master to specify the address of the
slave.
 H_WDATA: Write data bus, used to send data from the AHB master to the slave.
 H_RDATA: Read data bus, used to receive data from the slave to the AHB master.
 H_WRITE: Control signal indicating whether the current transaction is a write (1)
or read (0).
 H_SELx: Select signal, used by the AHB master to select the target slave.
 H_READY: Indicates that the current transfer is complete and the bus is ready for
the next transfer.
 H_RESP: Response signal, indicates the status of the transfer (OKAY, ERROR).



APB Interface Signals
 P_CLK: Clock signal for APB operations.
 P_RESET: Active low reset signal.
 P_ADDR: Address bus, specifies the address of the APB slave.
 P_WDATA: Write data bus, used to send data to the APB slave.
 P_RDATA: Read data bus, used to receive data from the APB slave.
 P_WRITE: Control signal indicating a write (1) or read (0) operation.
 P_SELx: Select signal, used to select the APB slave.
 P_ENABLE: Enable signal, indicates the second phase of an APB transfer.
 P_READY: Indicates that the APB slave has completed the operation and data is
ready. 


Testbench and Simulation: A comprehensive testbench is included to verify the functionality of the bridge. Simulations are provided to demonstrate the performance of the AHB Slave, APB Controller, and the 2-stage pipeline under different operating conditions.

Getting Started
Prerequisites
Verilog/SystemVerilog Simulation Tool: A Verilog or SystemVerilog simulation tool such as ModelSim, VCS, or any compatible EDA tool.
Basic Knowledge: Familiarity with AHB, APB, and SoC architectures.
