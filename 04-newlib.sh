#!/usr/bin/env bash
set -eu pipefail
echo " "
echo " "
echo " "
echo "NEWLIB DOWNLOAD-CONFIG-COMPILE FROM SOURCE"

# ---------- CONFIG ----------
PREFIX="$(pwd)/m68k-elf"
TARGET="m68k-elf"
NEWLIB_VER="4.1.0"

NEWLIB_URL="https://sourceware.org/pub/newlib/newlib-$NEWLIB_VER.tar.gz"
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

# ---------- DOWNLOAD ----------
echo " "
echo " "
echo " "
echo "Downloading sources..."
cd "$SRC_DIR"
[ -f "newlib-$NEWLIB_VER.tar.gz" ] || wget -c "$NEWLIB_URL" -O "newlib-$NEWLIB_VER.tar.gz"

echo " "
echo " "
echo " "
echo "Unpacking..."
tar -xf "newlib-$NEWLIB_VER.tar.gz"

export PATH="$PREFIX/bin:$PATH"

# ---------- CONFIGURE NEWLIB ----------
echo " "
echo " "
echo " "
echo "Configuring newlib $NEWLIB_VER..."
mkdir -p "$BUILD_DIR/newlib"
cd "$BUILD_DIR/newlib"

"$SRC_DIR/newlib-$NEWLIB_VER/configure" \
    --target="$TARGET" \
    --prefix="$PREFIX" \
    --disable-multilib \
    CFLAGS_FOR_TARGET="-m68000 -O2"

# ---------- COMPILE NEWLIB ----------  
echo " "
echo " "
echo " "
echo "Compiling  newlib $NEWLIB_VER..."    
make $MAKEFLAGS
make install

