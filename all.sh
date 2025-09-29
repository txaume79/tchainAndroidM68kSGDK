#!/usr/bin/env bash
set -eu pipefail
echo " "
echo " "
echo " "
echo "STARTING TOOLCHAIN ANDROID-M68k COMPILE PROCESS"
sleep 5
echo "...be patient..."
sleep 5

sh 01-apt.sh
sh 02-binutils.sh
sh 03-gcc1.sh
sh 04-newlib.sh
sh 05-gcc2.sh
sh 06-sgdklib.sh

echo " "
echo " " 
echo " Toolchain m68k-elf (binutils + gcc + newlib) installed"
echo
echo " Add on ~/.profile or ~/.bashrc in Termux - giving you have used $HOME to build the toolchain:"
echo "   export PATH=\$HOME/m68k-elf/bin:\$PATH"
echo
echo " Wanna test? "
echo "   m68k-elf-gcc -v"
echo "   echo 'int main(){return 0;}' > test.c"
echo "   m68k-elf-gcc -nostdlib -Ttext 0x0000 test.c -o test.elf"
echo "   m68k-elf-objcopy -O binary test.elf test.bin"


echo " "
echo " "
echo " "
echo "No fails? now follow the README.md steps. Good luck..."

