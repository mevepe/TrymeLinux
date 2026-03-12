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
