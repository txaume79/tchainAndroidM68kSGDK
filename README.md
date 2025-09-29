# Cross-Compile M68K Toolchain on Android for SGDK

**Disclaimer:** These scripts are shared *as-is*. They can be freely used and modified, but no support is provided. Good luck!

## What is this?

A set of scripts to build **GCC for the Motorola 68000 CPU** (other M68K variants can be added by tweaking a few lines — I’ll let you guess which ones 😄).

The resulting toolchain is intended for use with **SGDK** to compile Sega Genesis/Mega Drive ROMs.
Tested only with the SGDK **samples** folder.

* GCC **9.3**
* Binutils **2.36.1**
* Newlib **4.1**
* SGDK **2.11**
* Termux **googleplay.2025.01.18**
* proot-distro **6.21 8 (uname -r)**
* ubuntu distro **24.04**
* Andorid 16 - S25 Ultra

## Setup Steps
Note: i do recommend working on an ssh session or a bluetooh keyboard, but up to you.
1. Install **Termux** on your Android device.
2. Open the terminal and install Proot:

   ```sh
   pkg install proot
   ```
3. Install a Debian-based distro (tested with Ubuntu):

   ```sh
   proot-distro install ubuntu
   ```
4. Log into the distro:

   ```sh
   proot-distro login ubuntu
   ```
5. Download this repo. Run the provided `.sh` scripts. All.sh does what you guess. If you want to launch one by one they are numbered in order.


6. Copy the generated ROM out/release/rom.bin to a folder accessible by your emulator (e.g. `/storage/emulated/0/Downloads`) and run it with RetroArch.

Important: 
cp envars to SGDK folder and on each new session, . .envars in order to get the environment. Anyway, if you do not close install console session, all should work properly. 

✅ If it works: enjoy!

## BIG TODO provide an IDE to work with. Keep coming, i will try to use vcode server or maybe an x11 session... still brainless storming

---

## License

This project is licensed under the [CC BY-NC 4.0](https://creativecommons.org/licenses/by-nc/4.0/) license.
See the [LICENSE](LICENSE) file for details.

---

*Author: TheNomCognom (aka txaume79)*
