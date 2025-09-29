#!/usr/bin/env bash
set -eu pipefail
echo " "
echo " "
echo " "
echo "GCC STAGE 1: DOWNLOAD-CONFIG-COMPILE FROM SOURCE"

# ---------- CONFIG ----------
PREFIX="$(pwd)/m68k-elf"
TARGET="m68k-elf"
GCC_VER="9.3.0"

# Mirror GNU - change at will - this is fast enough on my location
GNU_MIRROR="https://mirror.koddos.net/gnu"
SRC_DIR="$(pwd)/src-toolchain"
BUILD_DIR="$(pwd)/build-toolchain"
JOBS=$(nproc || echo 1)
MAKEFLAGS=${MAKEFLAGS:-"-j$JOBS"}

echo " "
echo " "
echo " "
echo "Preparing env..."
mkdir -p "$SRC_DIR" "$BUILD_DIR" "$PREFIX"
#export PATH="$(pwd)/bin:$PATH"
export CC=clang
export CXX=clang++
# Avoid some C++17 issues with keyword 'register' among others...
export CFLAGS=" -O2 -fno-pie -std=gnu89  -fPIC"
export CXXFLAGS=" -O2 -fno-pie -std=gnu++98  -fPIC"
export CPPFLAGS=" -fcommon"

# ---------- DOWNLOAD ----------
echo " "
echo " "
echo " "
echo "Downloading sources..."
cd "$SRC_DIR"
[ -f "gcc-$GCC_VER.tar.gz" ] || wget -c "$GNU_MIRROR/gcc/gcc-$GCC_VER/gcc-$GCC_VER.tar.gz"

echo " "
echo " "
echo " "
echo "Unpacking..."
tar -xf "gcc-$GCC_VER.tar.gz"

# ---------- CONFIGURE GCC STAGE 1. JUST C COMPILER ----------
echo " "
echo " "
echo " "
echo "Configuring GCC $GCC_VER (stage 1, just C compiler)"
mkdir -p "$BUILD_DIR/gcc1"
export PATH="$PREFIX/bin:$PATH"
cd "$BUILD_DIR/gcc1"

# Configure: without headers, just C
"$SRC_DIR/gcc-$GCC_VER/configure" \
  --target="$TARGET" \
  --prefix="$PREFIX" \
  --host=aarch64-unknown-linux-gnu \
  --build=aarch64-unknown-linux-gnu \
  --disable-nls \
  --enable-languages=c \
  --without-headers \
  --disable-libssp \
  --disable-libquadmath \
  --disable-shared \
  --disable-threads \
  --disable-libgomp \
  --disable-tls \
  --disable-bootstrap \
  --without-libbacktrace \
  --disable-gcov \
  --disable-multilib \
  CFLAGS_FOR_TARGET="-m68000 -O2"

# ---------- COMPILE GCC STAGE 1 ----------  
echo " "
echo " "
echo " "
echo "Compiling GCC stage 1..."
echo " "
echo " "
# TODO is really needed? at first i needed but the whole thing evolved... 
# Avoid gcov builds that can throw libbacktrace compile (defiensive patch)
# some Makefiles still lists gcov; mod Makefile.in if needed after config.
make all-gcc $MAKEFLAGS  || {
    echo "ERROR: make all-gcc stagw 1 failed. retry with -j1 ..."
    MAKEFLAGS="-j1"
    make all-gcc
}
make install-gcc

# install libgcc minimal target (libgcc needed by newlib build)
make all-target-libgcc $MAKEFLAGS || make all-target-libgcc -j1
make install-target-libgcc

