/*
 * Copyright 2023 Antmicro
 * SPDX-License-Identifier: Apache-2.0
 */

#include "uart_stdio.h"
#include "csr.h"

#define TEST_BASE 0x40000000
#define TEST_SIZE 0x100000
#define TEST_WORD 0xdeadbeef
// #define DEBUG 1

int main(int argc, char **argv) {
	uint8_t op;
	uint32_t addr, value;

	uart_stdio_init();

	printf("\n");
	printf("Configure DRAM timing parameters.\n");
	dram_ctrl_controller_tRP_write(2);
	dram_ctrl_controller_tRCD_write(2);
	dram_ctrl_controller_tWR_write(2);
	dram_ctrl_controller_tWTR_write(2);
	dram_ctrl_controller_tREFI_write(196);
	dram_ctrl_controller_tRFC_write(10);
	dram_ctrl_controller_tFAW_write(3);
	dram_ctrl_controller_tCCD_write(4);
	dram_ctrl_controller_tRRD_write(2);
	dram_ctrl_controller_tRC_write(5);
	dram_ctrl_controller_tRAS_write(3);

	ddrphy_rdphase_write(6);
	ddrphy_wrphase_write(6);
	ddrphy_rst_write(1);
	ddrphy_rst_write(0);

	printf("Initialize training.\n");
	dram_ctrl_controller_phy_ctl_write(1);

	printf("Waiting for training finish...\n");
	while (!dram_ctrl_controller_phy_sts_init_done_read()) {}

	printf("DRAM training finished.\n");
	ddrctrl_init_done_write(1);
	ddrctrl_init_error_write(0);

	#ifdef DEBUG
		printf("Reading 0x%x-0x%x...\n", TEST_BASE, (TEST_BASE + TEST_SIZE));
		for (uint32_t addr = TEST_BASE; addr < (TEST_BASE + TEST_SIZE); addr += 4) {
			printf("Value at address 0x%x: 0x%x\n", addr, *(uint32_t*)addr);
		}
	#endif

	printf("Overwriting 0x%x-0x%x with 0x%x...\n", TEST_BASE, (TEST_BASE + TEST_SIZE), TEST_WORD);
	for (uint32_t addr = TEST_BASE; addr < (TEST_BASE + TEST_SIZE); addr += 4) {
		*(uint32_t*)addr = TEST_WORD;
	}

	printf("Reading 0x%x-0x%x...\n", TEST_BASE, (TEST_BASE + TEST_SIZE));
	uint32_t mismatch_counter = 0;
	for (uint32_t addr = TEST_BASE; addr < (TEST_BASE + TEST_SIZE); addr += 4) {
		if (*(uint32_t*)addr != TEST_WORD) {
			mismatch_counter++;
			#ifdef DEBUG
				printf("Data mismatch at 0x%x (0x%x vs 0x%x)\n", addr, *(uint32_t*)addr, TEST_WORD);
			#endif
		}
	}

	printf("Test finished, %d memory mismatches detected.\n", mismatch_counter);
	printf("===========================\n");
	if (mismatch_counter) {
		printf("\tTEST FAILED!\n");
	} else {
		printf("\tTEST PASSED!\n");
	}
	printf("===========================\n");

	printf("Available memory access commands:\n");
	printf("read - 'r <address> <number_of_words_to_read>'\n");
	printf("write - 'w <address> <value_of_word_to_write>'\n");
	printf("All values should be passed in hexadecimal format without '0x' prefix.\n\n");
	while (1) {
		printf("Enter command: ");
		scanf("%c %lx %lx", &op, &addr, &value); printf("%c 0x%lx 0x%lx\n", op, addr, value);
		getchar();
		if (op == 'w') {
			*(uint32_t*)addr = value;
			printf("Writing 0x%x at address 0x%x\n", value, addr);
		} else if (op == 'r') {
			for (int i = 0; i < value; i++) {
				printf("Value at address 0x%x: 0x%x\n", (addr + (i * 4)), *(uint32_t*)(addr + (i * 4)));
			}
		} else {
			printf("Unrecognized command %c\n", op);
		}
	}


	return 0;
}
