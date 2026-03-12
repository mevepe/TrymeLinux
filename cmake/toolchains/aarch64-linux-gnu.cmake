# Minimal toolchain for aarch64 cross compilation using gcc cross toolchain
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

# Adjust the path to your installed cross compilers in WSL (example for Ubuntu)
set(CROSS_ROOT /usr/bin)
set(CMAKE_C_COMPILER ${CROSS_ROOT}/aarch64-linux-gnu-gcc)
set(CMAKE_CXX_COMPILER ${CROSS_ROOT}/aarch64-linux-gnu-gcc)
set(CMAKE_FIND_ROOT_PATH ${CROSS_ROOT})

# Search for programs in the build host directories
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# For libraries and headers in the target directories
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
