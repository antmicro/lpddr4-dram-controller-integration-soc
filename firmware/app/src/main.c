/*
 * Copyright 2024 Antmicro <www.antmicro.com>
 * SPDX-License-Identifier: Apache-2.0
 */

#include <zephyr/kernel.h>
#include <zephyr/shell/shell.h>
#include <stdlib.h>
#include <string.h>
#include "csr.h"

#define LFSR_32BIT_POLYNOMIAL 0x80200003
#define DRAM_BASE_ADDR 0x40000000
#define DRAM_SIZE 0x20000000
#define DRAM_ADDR_END (DRAM_BASE_ADDR + DRAM_SIZE)
#define DRAM_WORD_WIDTH 4

uint32_t lfsr(uint32_t prev)
{
	uint32_t lsb = prev & 1;

	prev >>= 1;
	prev ^= (-lsb) & LFSR_32BIT_POLYNOMIAL;

	return prev;
}

void reset_ddrphy(void)
{
	ddrphy_rst_write(1);
	k_msleep(100);
	ddrphy_rst_write(0);
	k_msleep(100);
}

void init_training(void)
{
	dram_ctrl_controller_phy_ctl_write(1);
}

void wait_training_done(void)
{
	while (!dram_ctrl_controller_phy_sts_init_done_read()) {};
}

void write_training_done(void)
{
	ddrctrl_init_done_write(1);
	ddrctrl_init_error_write(0);
}

void train_memory(void)
{
	reset_ddrphy();
	init_training();
	wait_training_done();
	write_training_done();
}

void mem_write(uint32_t address, uint32_t value)
{
	*(uint32_t *)address = value;
}

uint32_t mem_read(uint32_t address)
{
	return *(uint32_t *)address;
}

void run_mem_test(const struct shell *sh, uint32_t base, uint32_t size, bool verbose)
{
	uint32_t mismatch_counter = 0;
	uint32_t seed = 1;
	uint32_t value;

	shell_print(sh, "Writing %#010x-%#010x...", base, (base + size));
	for (uint32_t addr = base; addr < (base + size); addr += DRAM_WORD_WIDTH) {
		seed = lfsr(seed);
		mem_write(addr, seed);
	}

	seed = 1;
	shell_print(sh, "Reading %#010x-%#010x...", base, (base + size));
	for (uint32_t addr = base; addr < (base + size); addr += DRAM_WORD_WIDTH) {
		seed = lfsr(seed);
		value = mem_read(addr);
		if (value != seed) {
			mismatch_counter++;
			shell_print(sh, "Data mismatch at %#010x (%#010x vs %#010x)", addr, value, seed);
		}
	}
}

static int cmd_mem_test(const struct shell *sh, size_t argc, char **argv)
{
	uint32_t base, size;
	uint32_t verbose = 0;

	base = strtol(argv[1], NULL, 0);
	size = strtol(argv[2], NULL, 0);

	if ((base == 0) || (size == 0)) {
		shell_error(sh, "Invalid memory test parameters.");
		return 1;
	}

	if ((base < DRAM_BASE_ADDR) || ((base + size) >= (DRAM_ADDR_END))) {
		shell_error(sh, "Memory access out of DRAM bounds %#010x-%#010x",
					DRAM_BASE_ADDR, DRAM_ADDR_END);
		return 1;
	}

	if (base % 4 != 0) {
		shell_error(sh, "Unaligned access is not supported.");
		return 1;
	}

	if (argc > 3) {
		verbose = strtol(argv[3], NULL, 0);
	}

	shell_print(sh, "Running memory test.");
	run_mem_test(sh, base, size, verbose);
	shell_print(sh, "Finished memory test.");

	return 0;
}

static int cmd_mem_write(const struct shell *sh, size_t argc, char **argv)
{
	uint32_t address, value;
	uint32_t count = 1;
	uint32_t address_end;

	address = strtoul(argv[1], NULL, 0);
	value = strtoul(argv[2], NULL, 0);

	if (argc > 3) {
		count = strtoul(argv[3], NULL, 0);
	}

	if (count == 0) {
		count = 1;
	}

	address_end = address + count * DRAM_WORD_WIDTH;

	if ((address < DRAM_BASE_ADDR) || (address_end >= (DRAM_ADDR_END))) {
		shell_error(sh, "Memory access out of DRAM bounds %#010x-%#010x",
					DRAM_BASE_ADDR, DRAM_ADDR_END);
		return 1;
	}

	if (address % 4 != 0) {
		shell_error(sh, "Unaligned access is not supported.");
		return 1;
	}

	if (count == 1) {
		shell_print(sh, "Writing %#010x at %#010x", value, address);
	} else {
		shell_print(sh, "Writing %#010x at %#010x-%#010x", value, address, address_end);
	}

	for (int i = 0; i < count; i++) {
		mem_write((address + i * 4), value);
	}

	shell_print(sh, "Finished memory write.");

	return 0;
}

static int cmd_mem_read(const struct shell *sh, size_t argc, char **argv)
{
	uint32_t address;
	uint32_t count = 1;
	uint32_t address_end;
	uint32_t value;

	address = strtoul(argv[1], NULL, 0);

	if (argc > 2) {
		count = strtoul(argv[2], NULL, 0);
	}

	if (!count) {
		count = 1;
	}

	address_end = address + count * DRAM_WORD_WIDTH;

	if ((address < DRAM_BASE_ADDR) || (address_end >= (DRAM_ADDR_END))) {
		shell_error(sh, "Memory access out of DRAM bounds %#010x-%#010x",
					DRAM_BASE_ADDR, DRAM_ADDR_END);
		return 1;
	}

	if (address % 4 != 0) {
		shell_error(sh, "Unaligned access is not supported.");
		return 1;
	}

	if (count == 1) {
		shell_print(sh, "Reading at %#010x", address);
	} else {
		shell_print(sh, "Reading at %#010x-%#010x", address, address_end);
	}

	for (int i = 0; i < count; i++) {
		value = mem_read(address);
		shell_print(sh, "Value at %#010x: %#010x", address, value);
		address += 4;
	}

	shell_print(sh, "Finished memory read.");

	return 0;
}

SHELL_STATIC_SUBCMD_SET_CREATE(sub_mem,
							   SHELL_CMD_ARG(test, NULL, "Test memory at address range, usage: 'mem test <address> <size> [verbose]'. ", cmd_mem_test, 3, 1),
							   SHELL_CMD_ARG(write, NULL, "Write to memory at address range, usage: 'mem write <address> <value> [count]'. ", cmd_mem_write, 3, 1),
							   SHELL_CMD_ARG(read, NULL, "Read memory at address range, usage: 'mem read <address> [count]'. ", cmd_mem_read, 2, 1),
							   SHELL_SUBCMD_SET_END);
SHELL_CMD_REGISTER(mem, &sub_mem, "Memory training, test and access commands", NULL);

int main(void)
{
	printf("Initializing memory...\n");
	train_memory();
	printf("Memory training finished!\n");

	return 0;
}
