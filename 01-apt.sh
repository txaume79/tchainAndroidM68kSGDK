#!/usr/bin/env bash
set -eu pipefail
echo " "
echo " "
echo " "
echo "INSTALLING APT NEEDED PACKAGES"

apt update -y
apt install -y -qq clang cmake make binutils gawk bison flex texinfo wget python3 git \
    libgmp-dev libmpfr-dev libmpc-dev android-libbacktrace android-libbacktrace-dev libisl-dev openjdk-21-jre

