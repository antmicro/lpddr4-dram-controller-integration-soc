ROOT_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
THIRD_PARTY_DIR := $(ROOT_DIR)/third_party
BUILD_DIR := $(ROOT_DIR)/build
SOC_GEN_DIR := $(THIRD_PARTY_DIR)/linux-test-chip-soc-generator
FIRMWARE_DIR := $(ROOT_DIR)/firmware

PREFIX = riscv64-unknown-elf
CC = $(PREFIX)-gcc
OBJCOPY = $(PREFIX)-objcopy

VIVADO_VER   ?= 2020.2
VIVADO       ?= /opt/Xilinx/Vivado/$(VIVADO_VER)

PART          = xc7k70tfbg484-1
BITSTREAM     = $(BUILD_DIR)/top.bit
GENERATED_RTL = $(BUILD_DIR)/dram_phy/gateware/dram_phy.v \
    $(BUILD_DIR)/dram_ctrl/gateware/dram_ctrl.v \
	$(BUILD_DIR)/lpddr4_soc/lpddr4_soc.v

TOPWRAP_GEN = $(BUILD_DIR)/topwrap/gen_dram_ctrl.yaml \
	$(BUILD_DIR)/topwrap/gen_dram_phy.yaml \
	$(BUILD_DIR)/topwrap/gen_lpddr4_soc.yaml

PYTHON = PYTHONPATH=$(PYTHONPATH) $(shell which python3)

include $(FIRMWARE_DIR)/headers.mk
include $(FIRMWARE_DIR)/bios.mk

all: soc bitstream

deps:
	make -C $(SOC_GEN_DIR) $@
	for D in `find ./third_party/ -type d`; do \
		if [ -f $$D/setup.py ]; then \
			pip install -e $$D; \
		fi; \
	done

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
	sed -i -r 's/".+_rom.init"/"bios.init"/g' $@

$(BUILD_DIR)/topwrap:
	mkdir -p $@

soc: $(GENERATED_RTL) | $(BUILD_DIR)/topwrap
	cd $(BUILD_DIR)/topwrap && fpga_topwrap parse $?
	fpga_topwrap build --design topwrap/project.yml --part $(PART)

$(TOPWRAP_GEN): $(GENERATED_RTL)
	$(MAKE) soc

$(BITSTREAM): SHELL:=/bin/bash
$(BITSTREAM): | $(BUILD_DIR)
$(BITSTREAM): $(TOPWRAP_GEN)
	$(MAKE) $(BUILD_DIR)/bios.init
	cp $(BUILD_DIR)/bios.init $(BUILD_DIR)/lpddr4_soc/bios.init
	source $(VIVADO)/settings64.sh && vivado -mode batch -source ./build.tcl

bitstream: $(BITSTREAM)

load: #$(BITSTREAM)
	openocd -f ./prog/openocd_xc7_ft4232.cfg -c "init; pld load 0 $(BITSTREAM); exit"

clean:
	-rm -rf $(BUILD_DIR)
	-rm vivado*

.PHONY: deps soc bitstream load clean
