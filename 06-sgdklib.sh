#!/usr/bin/env bash
set -eu pipefail
echo " "
echo " "
echo " "
echo "SGDK LIB DOWNLOAD - COMPILE - MAKE HIWORLD"

cd $HOME
# ---------- DOWNLOAD ----------
echo " "
echo " "
echo " "
echo "Downloading sources..."
[ -f "master.zip" ] || wget https://github.com/Stephane-D/SGDK/archive/refs/heads/master.zip

# ---------- UNPACKING ----------
echo " "
echo " "
echo " "
echo "Unpacking..."
unzip master.zip

echo " "
echo " "
echo " "
echo "Preparing env..."
export PATH=$PATH:/root/tchainAndroidM68kSGDK/m68k-elf/bin
cd SGDK-master
sed -i '/m32/d' tools/xgmtool/src/CMakeLists.txt
export GDK=$(pwd) 
export GDK_WIN=$(pwd) 
export SGDK_SRC=$(pwd) 
sed -i '/-m68000/d' tools/xgmtool/src/CMakeLists.txt
cmake ./
sed -i 's#/usr/bin/gcc#/root/tchainAndroidM68kSGDK/m68k-elf/bin/m68k-elf-gcc#g' CMakeFiles/md.dir/build.make

# ---------- MAKE DEPS ----------
echo " "
echo " "
echo " "
echo "Making needed tools and deps"
export C_INCLUDE_PATH=
export PATH=$PATH:/root/tchainAndroidM68kSGDK/m68k-elf/bin
export GDK=$(pwd) 
export GDK_WIN=$(pwd) 
export SGDK_SRC=$(pwd) 
make 
if [ -z "${C_INCLUDE_PATH+x}" ]; then
    export C_INCLUDE_PATH=/$GDK_WIN/res/:/$GDK_WIN/inc/
else
    export C_INCLUDE_PATH=$C_INCLUDE_PATH:/$GDK_WIN/res/:/$GDK_WIN/inc/
fi
cmake ./
sed -i 's#/usr/bin/gcc#/root/tchainAndroidM68kSGDK/m68k-elf/bin/m68k-elf-gcc#g' CMakeFiles/md.dir/build.make

# ---------- MAKE LIB  ----------
echo " "
echo " "
echo " "
echo "Making SGDK lib"
export GDK=$(pwd) 
export GDK_WIN=$(pwd) 
export SGDK_SRC=$(pwd) 
export PATH=$PATH:/root/tchainAndroidM68kSGDK/m68k-elf/bin
export GDK=$(pwd) 
export GDK_WIN=$(pwd) 
export SGDK_SRC=$(pwd) 

sed -i 's#PREFIX ?= m68k-elf-#PREFIX ?= /root/tchainAndroidM68kSGDK/m68k-elf/bin/m68k-elf-#g' common.mk
make -f $GDK_WIN/makelib.gen all   # or release/debug as needed

# ---------- MAKE HELLO WORLD ----------
echo " "
echo " "
echo " "
echo "Making hello world"
cd sample/basics/hello-world
make -f $GDK_WIN/makefile.gen release 

echo " "
echo " "
echo " "
echo " "
[ -e out/release/rom.bin ] && echo "Congrats, rom has been made" && file out/release/rom.bin && echo "copy it to android storage accesible by a native emulator such as RetroArch"|| echo "Ooops! something went wrong, sorry..."




