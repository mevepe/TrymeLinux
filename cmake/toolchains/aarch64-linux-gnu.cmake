# Minimal toolchain for aarch64 cross compilation using gcc cross toolchain
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

# Adjust the path to your installed cross compilers in WSL (example for Ubuntu)
# Common installation places compilers under /usr/bin, so set CROSS_ROOT to /usr
set(CROSS_ROOT /usr)
set(CMAKE_C_COMPILER ${CROSS_ROOT}/bin/aarch64-linux-gnu-gcc)
set(CMAKE_CXX_COMPILER ${CROSS_ROOT}/bin/aarch64-linux-gnu-g++)
set(CMAKE_FIND_ROOT_PATH ${CROSS_ROOT})

# Search for programs in the build host directories
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# For libraries and headers in the target directories
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
