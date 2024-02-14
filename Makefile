SHELL=/bin/bash
ROOT_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
THIRD_PARTY_DIR := $(ROOT_DIR)/third_party
BUILD_DIR := $(ROOT_DIR)/build
FIRMWARE_DIR := $(ROOT_DIR)/firmware
LITEX_DIR := $(THIRD_PARTY_DIR)/litex/litex/soc

RISCV_TOOLCHAIN = riscv64-unknown-elf-gcc-10.1.0-2020.08.2-x86_64-linux-ubuntu14
RISCV_TOOLCHAIN_URL = https://static.dev.sifive.com/dev-tools/freedom-tools/v2020.08/$(RISCV_TOOLCHAIN).tar.gz

GCC_PREFIX = riscv64-unknown-elf

# Ensure that RISC-V toolchain is installed
ifneq ($(MAKECMDGOALS), riscv-toolchain)
ifeq ($(shell which $(GCC_PREFIX)-gcc 2> /dev/null),)
GCC_PREFIX = riscv32-unknown-elf
endif
ifeq ($(shell which $(GCC_PREFIX)-gcc 2> /dev/null),)
$(error RISC-V toolchain not found, please run `make riscv-toolchain` to install it or install the toolchain manually)
endif
endif

CC = $(GCC_PREFIX)-gcc
OBJCOPY = $(GCC_PREFIX)-objcopy

# Use system Vivado command if available, otherwise source settings64.sh
VIVADO = $(shell which vivado)
ifeq (, $(VIVADO))
	VIVADO_VER  ?= 2020.2
	VIVADO_PATH ?= /opt/Xilinx/Vivado/$(VIVADO_VER)
	VIVADO_CMD  ?= source $(VIVADO_PATH)/settings64.sh && vivado
else
	VIVADO_CMD ?= $(VIVADO)
endif

PART          = xc7k70tfbg484-1
BITSTREAM     = $(BUILD_DIR)/top.bit
GENERATED_RTL = $(BUILD_DIR)/dram_phy/gateware/dram_phy.v \
	$(BUILD_DIR)/dram_ctrl/gateware/dram_ctrl.v \
	$(BUILD_DIR)/lpddr4_soc/lpddr4_soc.v

TOPWRAP_GEN = $(BUILD_DIR)/topwrap/gen_dram_ctrl.yaml \
	$(BUILD_DIR)/topwrap/gen_dram_phy.yaml \
	$(BUILD_DIR)/topwrap/gen_lpddr4_soc.yaml

INCLUDE_DIRS = \
	$(BUILD_DIR)/dram_ctrl/software/include/generated;$\
	$(BUILD_DIR)/dram_ctrl/software/include;$\
	$(LITEX_DIR)/software/include;$\
	$(LITEX_DIR)/software/libbase;$\
	$(LITEX_DIR)/cores/cpu/vexriscv
export INCLUDE_DIRS

ZEPHYR_BIN = $(FIRMWARE_DIR)/build/zephyr/zephyr.bin

PYTHON = $(shell which python3)

PATH := $(PATH):$(PWD)/third_party/riscv64-unknown-elf-gcc/bin
export PATH

all: bitstream ## Generate verilog sources and build a bitstream

riscv-toolchain: ## Install RISC-V toolchain
	@echo Downloading RISC-V toolchain
	curl -L $(RISCV_TOOLCHAIN_URL) | tar -xzf -
	mv $(RISCV_TOOLCHAIN) third_party/riscv-toolchain

deps: ## Configure Python environment
	pip install -r requirements.txt

$(BUILD_DIR):
	mkdir -p $@

$(BUILD_DIR)/lpddr4_soc:
	mkdir -p $@

$(BUILD_DIR)/dram_ctrl/gateware/dram_ctrl.v: | $(BUILD_DIR)
	$(PYTHON) ./third_party/tristan-dram-controller/gen.py ./tristan-ctrl.yml --output $(BUILD_DIR)/dram_ctrl

$(BUILD_DIR)/dram_phy/gateware/dram_phy.v: | $(BUILD_DIR)
	$(PYTHON) ./third_party/tristan-dram-phy/src/gen.py ./tristan-phy.yml 1 --output $(BUILD_DIR)/dram_phy
	$(PYTHON) ./third_party/tristan-dram-phy/src/gen.py ./tristan-phy.yml 2 --output $(BUILD_DIR)/dram_phy

$(BUILD_DIR)/lpddr4_soc/lpddr4_soc.v: | $(BUILD_DIR)/lpddr4_soc
	$(PYTHON) ./src/generate_lpddr4_soc.py --bitstream --headers --build-dir $(BUILD_DIR)/lpddr4_soc
	sed -i -r 's/".+_sram.init"/"bios.init"/g' $@

$(BUILD_DIR)/topwrap:
	mkdir -p $@

soc: $(GENERATED_RTL) | $(BUILD_DIR)/topwrap ## Generate verilog sources
	cd $(BUILD_DIR)/topwrap && fpga_topwrap parse $?
	fpga_topwrap build --design topwrap/project.yml --part $(PART)

$(TOPWRAP_GEN): $(GENERATED_RTL)
	$(MAKE) soc

$(ROOT_DIR)/.west:
	west init -l firmware
	cd $(FIRMWARE_DIR) && west update

$(ZEPHYR_BIN): $(wildcard $(FIRMWARE_DIR)/app/src/*.c) $(ROOT_DIR)/.west
	cd $(FIRMWARE_DIR) && west build -p -b litex_vexriscv app

$(BUILD_DIR)/bios.init: $(ZEPHYR_BIN) | $(BUILD_DIR)
	hexdump -v -e '1/4 "%08X\n"' $< > $@

firmware: $(BUILD_DIR)/bios.init

$(BITSTREAM): SHELL:=/bin/bash
$(BITSTREAM): $(TOPWRAP_GEN)
$(BITSTREAM): $(BUILD_DIR)/bios.init
$(BITSTREAM): | $(BUILD_DIR)
	cp $(BUILD_DIR)/bios.init $(BUILD_DIR)/lpddr4_soc/bios.init
	$(VIVADO_CMD) -mode batch -source ./build.tcl

bitstream: $(BITSTREAM) ## Generate verilog sources and build a bitstream

load: $(BITSTREAM) ## Generate a bitstream and load it to the board's SRAM
	openocd -f ./prog/openocd_xc7_ft4232.cfg -c "init; pld load 0 $(BITSTREAM); exit"

clean-zephyr: ## Remove Zephyr
	$(RM) -r $(ROOT_DIR)/.west $(ROOT_DIR)/zephyr $(ROOT_DIR)/modules

clean-firmware: ## Remove Zephyr generated files
	$(RM) -r $(FIRMWARE_DIR)/build

clean: clean-firmware ## Remove all generated files
	$(RM) -r $(BUILD_DIR) $(ROOT_DIR)/.Xil
	$(RM) vivado* usage_statistics*

.PHONY: deps soc bitstream load clean clean-zephyr firmware

.DEFAULT_GOAL := help
HELP_COLUMN_SPAN = 15
HELP_FORMAT_STRING = "\033[36m%-$(HELP_COLUMN_SPAN)s\033[0m %s\n"
help: ## Show this help message
	@echo List of available targets:
	@grep -hE '^[^#[:blank:]]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf $(HELP_FORMAT_STRING), $$1, $$2}'
	@echo
	@echo
	@echo List of available optional parameters:
	@echo
	@echo -e "\033[36mVIVADO_VER\033[0m  Version of Vivado to search under VIVADO_PATH (default: $(VIVADO_VER))"
	@echo -e "\033[36mVIVADO_PATH\033[0m Path to the Vivado installation directory (default: $(VIVADO_PATH))"
	@echo -e "\033[36mVIVADO_CMD\033[0m  Path to the Vivado binary, it overwrites previous parameters (default: $(VIVADO_CMD))"
