# Copyright 2023 Antmicro
# SPDX-License-Identifier: Apache-2.0

include $(FIRMWARE_DIR)/headers.mk

LITEX = $(shell python -c "import litex; print(litex.__path__[0])")/soc

LIBBASE_OBJ = uart.o memtest.o system.o
FIRMWARE_OBJ = bios.o uart_stdio.o
LINKER_SCRIPT = $(FIRMWARE_DIR)/linker.ld

OBJ = $(addprefix $(FIRMWARE_DIR)/,$(FIRMWARE_OBJ)) $(addprefix $(LITEX)/software/libbase/,$(LIBBASE_OBJ))
INC = $(BUILD_DIR)/lpddr4_soc $(LITEX)/software/include $(LITEX)/software/libbase $(LITEX)/software $(LITEX)/cores/cpu/vexriscv $(DRAM_CTRL_INC)
CFLAGS = -march=rv32im -mabi=ilp32 --specs=$(PICOLIBC_DIR)/install/picolibc.specs -T$(LINKER_SCRIPT) $(addprefix -I,$(INC))
BIN = $(BUILD_DIR)/rom.bin
FIRMWARE_OBJ_BUILD = $(addprefix $(BUILD_DIR)/,$(FIRMWARE_OBJ))
LIBBASE_OBJ_BUILD = $(addprefix $(BUILD_DIR)/, $(LIBBASE_OBJ))
OBJ_BUILD = $(FIRMWARE_OBJ_BUILD) $(LIBBASE_OBJ_BUILD)
DIRTREE = $(sort $(dir $(OBJ_BUILD)))

firmware: $(BUILD_DIR)/bios.init

$(DIRTREE):
	mkdir -p $@

$(FIRMWARE_OBJ_BUILD): $(BUILD_DIR)/%.o : $(FIRMWARE_DIR)/%.c $(AUTOGEN_H) | $(DIRTREE)
	$(CC) $(CFLAGS) -c -o $@ $<

$(LIBBASE_OBJ_BUILD): $(BUILD_DIR)/%.o : $(LITEX)/software/libbase/%.c $(AUTOGEN_H) | $(DIRTREE)
	$(CC) $(CFLAGS) -c -o $@ $<

$(BUILD_DIR)/bios.bin: $(OBJ_BUILD)
	$(CC) $(CFLAGS) -o $@ $(OBJ_BUILD)

$(BUILD_DIR)/rom.bin: $(BUILD_DIR)/bios.bin
	$(OBJCOPY) -O binary $^ $@

$(BUILD_DIR)/%.init: $(BIN) | $(BUILD_DIR)
	hexdump -v -e '1/4 "%08X\n"' $< > $@

.PHONY: firmware
