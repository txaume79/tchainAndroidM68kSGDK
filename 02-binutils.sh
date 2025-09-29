#!/usr/bin/env bash
set -eu pipefail
echo " "
echo " "
echo " "
echo "BINUTILS DOWNLOAD-CONFIG-COMPILE FROM SOURCE"

# ---------- CONFIG ----------
PREFIX="$(pwd)/m68k-elf"
TARGET="m68k-elf"
BINUTILS_VER="2.36.1"

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
#export PATH="$HOME/bin:$PATH"
export CC=clang
export CXX=clang++

# ---------- DOWNLOAD ----------
echo " "
echo " "
echo " "
echo "Downloading sources..."
cd "$SRC_DIR"
[ -f "binutils-$BINUTILS_VER.tar.gz" ] || wget -c "$GNU_MIRROR/binutils/binutils-$BINUTILS_VER.tar.gz"

echo " "
echo " "
echo " "
echo "Unpacking..."
tar xvzf "binutils-$BINUTILS_VER.tar.gz"

# ---------- CONFIGURE BINUTILS ----------
echo " "
echo " "
echo " "
echo "Configuring binutils $BINUTILS_VER..."
mkdir -p "$BUILD_DIR/binutils"
cd "$BUILD_DIR/binutils"

"$SRC_DIR/binutils-$BINUTILS_VER/configure" \
  --target="$TARGET" \
  --prefix="$PREFIX" \
  --host=aarch64-unknown-linux-gnu \
  --build=aarch64-unknown-linux-gnu \
  --disable-nls \
  --disable-werror \
  --disable-libctf \
  --disable-multilib \
  CFLAGS_FOR_TARGET="-m68000 -O2"

# ---------- COMPILE BINUTILS ----------  
echo " "
echo " "
echo " "
echo "Compiling binutils $BINUTILS_VER..."
make $MAKEFLAGS
make install