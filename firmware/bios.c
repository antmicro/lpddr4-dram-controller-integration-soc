/*
 * Copyright 2023 Antmicro
 * SPDX-License-Identifier: Apache-2.0
 */

#include "uart_stdio.h"
#include "csr.h"

#define TEST_BASE 0x40000000
#define TEST_SIZE 0x100000
#define MAX_INPUT_LEN 30
// #define DEBUG 1

uint32_t lfsr(uint32_t prev)
{
    uint32_t lsb = prev & 1;

    prev >>= 1;
    prev ^= (-lsb) & 0x80200003;

    return prev;
}

uint32_t nb_of_params(char *input, uint32_t len) {
	uint32_t nb_of_separators = 0;

	for (uint32_t i = 0; i < len; i++) {
		if (*(input + i) == ' ') {
			nb_of_separators++;
		}
	}

	return nb_of_separators;
}

void print_cmd_help() {
	printf("Available memory access commands:\n");
	printf("write - 'w <address> <value> <count>'\n");
	printf("read - 'r <address> <count>'\n");
	printf("<address> and <value> should be passed in hexadecimal format without '0x' prefix.\n\n");
}

int main(int argc, char **argv) {
	uint32_t addr, value, count, i;
	uint32_t mismatch_counter = 0;
	uint32_t seed = 1;
	char input[MAX_INPUT_LEN] = { 0 };
	char op, c;

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

	printf("Writing to 0x%x-0x%x...\n", TEST_BASE, (TEST_BASE + TEST_SIZE));
	for (uint32_t addr = TEST_BASE; addr < (TEST_BASE + TEST_SIZE); addr += 4) {
		seed = lfsr(seed);
		#ifdef DEBUG
			printf("Writing 0x%x at 0x%x\n", seed, addr);
		#endif
		*(uint32_t*)addr = seed;
	}

	seed = 1;
	printf("Reading 0x%x-0x%x...\n", TEST_BASE, (TEST_BASE + TEST_SIZE));
	for (uint32_t addr = TEST_BASE; addr < (TEST_BASE + TEST_SIZE); addr += 4) {
		seed = lfsr(seed);
		if (*(uint32_t*)addr != seed) {
			mismatch_counter++;
			#ifdef DEBUG
				printf("Data mismatch at 0x%x (0x%x vs 0x%x)\n", addr, *(uint32_t*)addr, seed);
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

	print_cmd_help();

	while (1) {
		printf(">");

		c = uart_getc(stdin);
		i = 0;
		while ((c != '\n') && (c != '\r') && (i < (MAX_INPUT_LEN - 1))) {
			input[i] = c;
			c = uart_getc(stdin);
			i++;
		};
		input[i] = '\0';
		printf(">%s\n", input);

		if (input[1] != ' ') {
			printf("Incorrect input format.\n");
			continue;
		}

		op = input[0];

		if (op == 'w') {
			if ((nb_of_params(input, i) != 3) || (sscanf(input, "%*s %lx %lx %d", &addr, &value, &count) != 3)) {
				printf("Incorrect input for write command.\n");
				print_cmd_help();
				continue;
			}

			for (uint32_t i = 0; i < (count * 4); i += 4) {
				*(uint32_t*)(addr + i) = value;
			}
		} else if (op == 'r') {
			if ((nb_of_params(input, i) != 2) || (sscanf(input, "%*s %lx %d", &addr, &count) != 2)) {
				printf("Incorrect input for read command.\n");
				print_cmd_help();
				continue;
			}

			for (int i = 0; i < count; i++) {
				printf("Value at address 0x%x: 0x%x\n", (addr + (i * 4)), *(uint32_t*)(addr + (i * 4)));
			}
		} else {
			printf("Unrecognized command %c\n", op);
			print_cmd_help();
		}
		printf("\n");
	}

	return 0;
}
