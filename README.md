# XC7 LPDDR4 MC+PHY integration

This repository contains a Xilinx Vivado project for Antmicro LPDDR4 Test Board, which integrates Tristan LPDDR4 PHY (LiteDRAM-derived) and Tristan DRAM controller (a.k.a. MC, based on LiteDRAM). There will be also a demonstration SoC, which uses the MC+PHY complex to test its operation.

All the components are stand-alone, either generated or existing Verilog RTL designs. They are integrated in `rtl/top.v` top-level module.

## Building

### Prerequisities

 - Xilinx Vivado 2020.2
 - System packages (Debian) that can be installed with:
   ```
   sudo apt-get install --no-install-recommends build-essential python3-setuptools python3-pip ninja-build gcc-riscv64-unknown-elf meson git openocd
   ```

### Steps

Clone / update submodules
```
git submodule update --init --recursive
```

Set up a Python3 virtualenv and activate it.
```
python3 -m venv env
source env/bin/activate
```

Install Python dependencies
```
make deps
```

Generate the SoC and DRAM memory controller
```
make soc
```

Build the bitstream
```
make bitstream VIVADO=<non-standard Vivado installation path>
```

## Running

Load the bitstream:
```
make load
```
User LEDs should light up and blink in a form of a LED chaser. Integration SoC will send a memory initialization request right after boot up.

First UART is connected to the integration SoC UART, second UART is connected to the PHY SoC. Both of these provide memory access commands which should be described after finished memory training. The DRAM is mapped at address range 0x40000000-0x60000000 from the integration SoC. Acessing data directly from the PHY requires passing an exact location (bank, row, column) in memory.

Example UART output from the integration SoC:
```
Initialize training.
Waiting for training finish...
DRAM training finished.
Writing to 0x40000000-0x40100000...
Reading 0x40000000-0x40100000...
Test finished, 0 memory mismatches detected.
===========================
        TEST PASSED!
===========================
Available memory access commands:
write - 'w <address> <value> <count>'
read - 'r <address> <count>'
<address> and <value> should be passed in hexadecimal format without '0x' prefix.

>
```

Example UART output from the PHY SoC:
```
TRISTAN DRAM PHY
Initializing DRAM...
Initializing SDRAM @0xffffffff...
Switching SDRAM to software control.
Write leveling:
  tCK equivalent taps: 32
  Cmd/Clk scan (0-16)
  |Cmd/Clk delay: 0
  m0: |00000000001111111111111111000000| delay: 10
  m1: |00000000001111111111111110000000| delay: 10
 AMW: |00000000001111111111111110000000| total: 15

// [...] Long memory training log

Switching SDRAM to hardware control.

Selected bitslips and delays:
Clock delay: 7
module:  0  1
    wb:  0  0
  wdly: 22 22
    rb:  7  7
  rdly:  9  8
DRAM initialization complete!

Available memory access commands:
write - 'w <bank> <row> <column> <value>'
read - 'r <bank> <row> <column>'
<value> should be passed in hexadecimal format without '0x' prefix.

>
```