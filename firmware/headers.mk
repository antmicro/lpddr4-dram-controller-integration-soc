# Copyright 2023 Antmicro
# SPDX-License-Identifier: Apache-2.0

HEADERS = csr.h soc.h mem.h
AUTOGEN_H = $(addprefix $(BUILD_DIR)/lpddr4_soc/generated/,$(HEADERS))
DRAM_CTRL_INC = $(BUILD_DIR)/dram_ctrl/software/include/generated
