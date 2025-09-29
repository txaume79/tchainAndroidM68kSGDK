#!/usr/bin/env bash
set -eu pipefail
echo " "
echo " "
echo " "
echo "GCC STAGE 2: CONFIG-COMPILE FROM SOURCE"

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
export CFLAGS=" -O2 -fno-pie -std=gnu89 -fPIC"           
export CXXFLAGS=" -O2 -fno-pie -std=gnu++98 -fPIC"
export CPPFLAGS=" -fcommon"

# ---------- CONFIGURE GCC STAGE 2 (adding newlib) ----------
echo " "
echo " "
echo " "
echo "Configuring GCC $GCC_VER (stage 2, with newlib)"
mkdir -p "$BUILD_DIR/gcc2"
cd "$BUILD_DIR/gcc2"

"$SRC_DIR/gcc-$GCC_VER/configure" \
  --target="$TARGET" \
  --prefix="$PREFIX" \
  --host=aarch64-unknown-linux-gnu \
  --build=aarch64-unknown-linux-gnu \
  --disable-multilib \
  --disable-nls \
  --enable-languages=c \
  --with-newlib \
  --disable-libssp \
  --disable-libquadmath \
  --disable-shared \
  --disable-threads \
  --disable-libgomp \
  --disable-tls \
  --disable-bootstrap \
  --without-libbacktrace \
  --disable-gcov \
  --disable-libstdcxx \
  CFLAGS_FOR_TARGET="-m68000 -O2"

# ---------- COMPILE GCC STAGE 2 ----------  
echo " "
echo " "
echo " "
echo "Compiling GCC stage 2..."
echo " "
echo " "
# TODO is really needed? at first i needed but the whole thing evolved... 
# Avoid gcov builds that can throw libbacktrace compile (defiensive patch)
# some Makefiles still lists gcov; mod Makefile.in if needed after config.
if ! make $MAKEFLAGS; then
    echo "ERROR: make stage 2 failed. Applying middle patch to avoid gcov/libbacktrace..."
    cd "$SRC_DIR/gcc-$GCC_VER/gcc"
    touch gcov-tool.c gcov-dump.c gcov-merge.c || true
    # retry with -j1
    cd "$BUILD_DIR/gcc2"
    MAKEFLAGS="-j1"
    make $MAKEFLAGS
fi

make install

# runtime libs
make all-target-libgcc $MAKEFLAGS || make all-target-libgcc -j1
make install-target-libgcc


