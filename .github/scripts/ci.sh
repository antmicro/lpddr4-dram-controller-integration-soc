#!/bin/bash
# Copyright (c) 2024 Antmicro <www.antmicro.com>
# SPDX-License-Identifier: Apache-2.0

set -e

ZEPHYR_SDK_VERSION="0.16.5"

begin_command_group() {
    if [[ -n "${GITHUB_WORKFLOW:-}" ]]; then
        echo "::group::$*"
    else
        echo -e "\n\033[1;92mRunning step: $1\033[0m\n"
    fi
}

end_command_group() {
    if [[ -n "${GITHUB_WORKFLOW:-}" ]]; then
        echo "::endgroup::"
    fi
}

log_cmd() {
    printf '\033[1;96m'
    printf '%s ' "$*"
    printf '\033[0m\n'
    eval "$*"
}

install_system_packages() {
    begin_command_group "Install system packages"
    log_cmd apt-get update -qq
    log_cmd apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        gcc-riscv64-unknown-elf \
        picolibc-riscv64-unknown-elf \
        git \
        make \
        python3 \
        python3-dev \
        python3-pip \
        python3-venv \
        antlr4 \
        default-jre \
        libantlr4-runtime-dev \
        libtinfo5 \
        ninja-build \
        uuid-dev \
        bsdmainutils \
        ccache \
        device-tree-compiler \
        dfu-util \
        file \
        gcc \
        gcc-multilib \
        g++-multilib \
        libsdl2-dev \
        libmagic1 \
        meson \
        python3-setuptools \
        python3-tk \
        python3-wheel \
        python-is-python3 \
        xz-utils \
        wget
    end_command_group
}

enter_venv() {
    begin_command_group "Configure Python virtual environment"
    if [[ -z "$VIRTUAL_ENV" ]]; then
        log_cmd python3 -m venv venv
    fi
    log_cmd source venv/bin/activate
    end_command_group
}

install_zephyr() {
    begin_command_group "Install Zephyr"
    log_cmd pip install west
    log_cmd wget https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${ZEPHYR_SDK_VERSION}/zephyr-sdk-${ZEPHYR_SDK_VERSION}_linux-x86_64.tar.xz
    log_cmd "wget -O - https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${ZEPHYR_SDK_VERSION}/sha256.sum | shasum --check --ignore-missing"
    log_cmd tar xvf zephyr-sdk-${ZEPHYR_SDK_VERSION}_linux-x86_64.tar.xz
    log_cmd pushd zephyr-sdk-${ZEPHYR_SDK_VERSION}
    log_cmd ./setup.sh -t riscv64-zephyr-elf -h -c
    log_cmd popd
    end_command_group
}

generate_design() {
    install_system_packages

    enter_venv
    begin_command_group "Install Python dependencies"
    log_cmd make deps
    end_command_group

    begin_command_group "Generate design"
    log_cmd make soc
    end_command_group

    install_zephyr

    begin_command_group "Build Zephyr firmware"
    log_cmd make firmware
    end_command_group
}

generate_design
