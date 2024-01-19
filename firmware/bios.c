/*
 * Copyright 2023 Antmicro
 * SPDX-License-Identifier: Apache-2.0
 */

#include "uart_stdio.h"
#include "csr.h"

#define BASE_RAM (0x40000000 + 0x1000)

int main(int argc, char **argv) {
	uint8_t op;
	uint32_t addr, value;

	uart_stdio_init();
	printf("Hello world!\n");

	for (uint32_t addr = BASE_RAM; addr < (BASE_RAM + 0x100); addr += 4) {
		printf("Value at address 0x%x", addr);
		printf(": 0x%x\n", *(uint32_t*)addr);
	}

	printf("Waiting for DRAM training...\n");
	while (!dram_ctrl_controller_phy_sts_init_done_read()) {}
	// while (1) {
	// 	printf("Enter command: ");
	// 	scanf("%c %lx %lx", &op, &addr, &value);
	// 	getchar();
	// 	if (op == 'w') {
	// 		*(&addr) = value;
	// 		printf("Writing %d at address %d\n", value, addr);
	// 	} else if (op == 'r') {
	// 		for (int i = 0; i < value; i++) {
	// 			printf("Value at address %d: %d\n", addr, *(&addr));
	// 		}
	// 	}
	// }
	printf("Press any key to continue.");
	getchar();

	for (uint32_t addr = BASE_RAM; addr < (BASE_RAM + 0x100); addr += 4) {
		printf("Value at address 0x%x: 0x%x\n", addr, *(uint32_t*)addr);
	}

	for (uint32_t addr = BASE_RAM; addr < (BASE_RAM + 0x100); addr += 4) {
		*(uint32_t*)addr = 0xFEEDABED;
	}

	for (uint32_t addr = BASE_RAM; addr < (BASE_RAM + 0x100); addr += 4) {
		printf("Value at address 0x%x: 0x%x\n", addr, *(uint32_t*)addr);
	}

	return 0;
}
