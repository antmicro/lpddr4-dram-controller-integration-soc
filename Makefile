ROOT_DIR = $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
THIRD_PARTY_DIR = $(ROOT_DIR)/third_party

PYTHONPATH += $(THIRD_PARTY_DIR)/linux-test-chip-soc-generator

VIVADO_VER   ?= 2020.2
VIVADO       ?= /opt/Xilinx/Vivado/$(VIVADO_VER)

BITSTREAM     = build/top.bit
GENERATED_RTL = build/dram_phy/gateware/dram_phy.v \
    build/dram_ctrl/gateware/dram_ctrl.v

PYTHON = PYTHONPATH=$(PYTHONPATH) $(shell which python3)

all: soc bitstream

deps:
	for D in `find ./third_party/ -type d`; do \
		if [ -f $$D/setup.py ]; then \
			pip install -e $$D; \
		fi; \
	done

build:
	mkdir -p $@

build/dram_ctrl/gateware/dram_ctrl.v: | build
	$(PYTHON) ./third_party/tristan-dram-controller/gen.py ./tristan-ctrl.yml --output build/dram_ctrl

build/dram_phy/gateware/dram_phy.v: | build
	$(PYTHON) ./third_party/tristan-dram-phy/src/gen.py ./tristan-phy.yml 1 --output build/dram_phy
	$(PYTHON) ./third_party/tristan-dram-phy/src/gen.py ./tristan-phy.yml 2 --output build/dram_phy

build/lpddr4_soc/gateware/lpddr4_soc.v: | build
	$(PYTHON) ./src/generate_lpddr4_soc.py --headers --build-dir build/lpddr4_soc

build/antmicro_lpddr4_test_board/gateware/antmicro_lpddr4_test_board.v: | build
	$(PYTHON) ./src/demosoc.py

soc: $(GENERATED_RTL) build/antmicro_lpddr4_test_board/gateware/antmicro_lpddr4_test_board.v

topwrap-soc: $(GENERATED_RTL) build/lpddr4_soc/gateware/lpddr4_soc.v

$(BITSTREAM): SHELL:=/bin/bash
$(BITSTREAM): | build
$(BITSTREAM): $(GENERATED_RTL)
	source $(VIVADO)/settings64.sh && vivado -mode batch -source ./build.tcl

bitstream: $(BITSTREAM)

load: $(BITSTREAM)
	openocd -f ./prog/openocd_xc7_ft4232.cfg -c "init; pld load 0 $(BITSTREAM); exit"

clean:
	-rm -rf build
	-rm vivado*

.PHONY: deps soc bitstream load clean
