#!/usr/bin/env bash
#
# install_xv6_riscv_tools.sh
#
# Installs all tools required to build and run the RISC-V version of xv6 on Ubuntu.

set -e

echo "Updating package lists..."
sudo apt-get update

echo "Installing xv6 (RISC-V) dependencies..."
sudo apt-get install -y \
    build-essential \
    qemu-system-misc \
    gcc-riscv64-unknown-elf \
    gdb-multiarch \
    device-tree-compiler

echo "All required packages for xv6 RISC-V have been installed."

