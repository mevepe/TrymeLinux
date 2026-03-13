# CMakeList.txt : Top-level CMake project file, do global configuration
# and include sub-projects here.
#
cmake_minimum_required (VERSION 3.10)

set(ROOTFS "/mnt/e/armbian-rootfs")

project ("TrymeLinux")

# Include sub-projects.
add_subdirectory ("TrymeLinux")