VIVADO_VER   ?= 2020.2
VIVADO       ?= /opt/Xilinx/Vivado/$(VIVADO_VER)

BITSTREAM     = build/top.bit
GENERATED_RTL = build/dram_phy/gateware/dram_phy.v \
    build/dram_ctrl/gateware/dram_ctrl.v \
    build/antmicro_lpddr4_test_board/gateware/antmicro_lpddr4_test_board.v

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
	./third_party/tristan-dram-controller/gen.py ./tristan-ctrl.yml --output build/dram_ctrl

build/dram_phy/gateware/dram_phy.v: | build
	./third_party/tristan-dram-phy/src/gen.py ./tristan-phy.yml 1 --output build/dram_phy
	./third_party/tristan-dram-phy/src/gen.py ./tristan-phy.yml 2 --output build/dram_phy

build/antmicro_lpddr4_test_board/gateware/antmicro_lpddr4_test_board.v: | build
	./src/demosoc.py

soc: $(GENERATED_RTL)

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
