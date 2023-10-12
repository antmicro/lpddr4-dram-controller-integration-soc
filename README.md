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
Some LEDs should light up. Refer to `rtl/top.v` for their meaning.

First UART is connected to DRAM PHY, second UART will be connected to application SoC w/ DRAM controller.
