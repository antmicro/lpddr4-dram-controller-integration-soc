/*
 * Copyright 2024 Antmicro
 * SPDX-License-Identifier: Apache-2.0
 */

#include <zephyr/kernel.h>
#include <zephyr/shell/shell.h>
#include <version.h>
#include <zephyr/logging/log.h>
#include <stdlib.h>
#include <zephyr/drivers/uart.h>
#include <zephyr/usb/usb_device.h>
#include <ctype.h>

int main(void)
{
	printf("Hello world! %s\n", CONFIG_BOARD);

	while (1)
	{
		printf("Hello world! %s\n", CONFIG_BOARD);
		k_msleep(1);
	}

	return 0;
}
