# Copyright (c) 2021-2022 Antmicro
# SPDX-License-Identifier: Apache-2.0

set(DTC_OVERLAY_FILE boards/tristan_vexriscv.overlay)

cmake_minimum_required(VERSION 3.20.0)
find_package(Zephyr REQUIRED HINTS $ENV{ZEPHYR_BASE})
project(tristan-lpddr4-app LANGUAGES C)


FILE(GLOB app_sources src/*.c)

zephyr_include_directories($ENV{INCLUDE_DIRS})

target_sources(app PRIVATE ${app_sources})
