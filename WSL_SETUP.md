WSL2 quick setup for this project

1) Install WSL2 (if not already)
   - In PowerShell (Admin):
     wsl --install -d Ubuntu

2) Open an Ubuntu WSL shell and install tools:
   sudo apt update
   sudo apt install -y build-essential cmake ninja-build gdb

3) Build inside WSL:
   cd /mnt/c/Users/mevep/source/repos/TrymeLinux
   mkdir -p build && cd build
   cmake -S .. -B . -G Ninja -DCMAKE_BUILD_TYPE=Debug
   cmake --build .

4) Using CMake presets inside WSL (recommended):
   cd /mnt/c/Users/mevep/source/repos/TrymeLinux
   cmake --preset linux-wsl
   cmake --build --preset linux-wsl

Notes:
- Visual Studio can connect to WSL for debugging if you install the "Linux development with C++" workload and configure remote settings.
- Paths under WSL mount the C: drive at /mnt/c/. Use the project path above or copy the repo into your WSL home for slightly better performance.

Remote cross-build + deploy + debug example (Armbian at 192.168.0.100)

1) In WSL, install cross toolchains and rsync/gdbserver:
   sudo apt update
   sudo apt install -y gcc-aarch64-linux-gnu g++-aarch64-linux-gnu cmake ninja-build rsync gdbserver

2) Ensure SSH access to the remote Armbian:
   ssh-keygen -t ed25519
   ssh-copy-id mevepe@192.168.0.100

3) Build and deploy using the helper script:
   cd /mnt/c/Users/mevep/source/repos/TrymeLinux
   ./deploy/deploy_armbian.sh arm64-wsl mevepe ~/.ssh/wsl-remote-debug 192.168.0.100 /home/mevepe/app

4) For remote debugging: connect from WSL (or remote machine with gdb) to gdbserver (the script can start it):
   gdb out/build/arm64-wsl/TrymeLinux/TrymeLinux
   (gdb) target remote 192.168.0.100:2345

Notes:
- For maximum compatibility, create a sysroot from your Armbian device and put it under `cmake/sysroots/armbian-aarch64` and then use the `armbian-aarch64-sysroot.cmake` toolchain.
- Visual Studio: configure a Remote Linux Debugger connection to 192.168.0.100 and point symbol/binary to the local cross-build output.
