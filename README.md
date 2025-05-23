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
## Test Scenarios Covered

Basic reset test
Write → Read → Compare
Burst write sequences
Mixed read transactions
Invalid data (X) and error injection
Edge case addresses: 0x0000_0000, 0xFFFF_FFFF

## Coverage Points

Implemented via ss_cov using uvm_subscriber.

Coverpoints:
- op, mem_valid, mem_wstrb, mem_addr

Cross coverage:
- op x mem_valid, op x mem_wstrb

Address buckets:
- Low, mid, high address space ranges