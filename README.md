# RISCV_Verification
# RISC-V Subsystem Verification using UVM

## Overview

This project contains a complete UVM-based verification environment for a custom **RISC-V Subsystem** design. The environment verifies memory-mapped interactions between the PicoRV32 core and the subsystem using a custom interface. It tests multiple scenarios such as read/write operations, burst accesses, error conditions, and edge cases.

The environment is modular, scalable, and reusable, and includes plans for Python-based regression testing to validate multiple scenarios automatically.

---

## Features

- UVM-based layered architecture  
- Functional coverage support  
- Configurable test scenarios (READ, WRITE, BURST, MIXED, ERROR, EDGE)  
- Python-based regression support (planned)  
- Support for reset handling and transaction-level modeling  
- Assertions and logging integrated in driver/monitor  

---

## Directory Structure

