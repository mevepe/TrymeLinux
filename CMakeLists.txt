# CMakeList.txt : Top-level CMake project file, do global configuration
# and include sub-projects here.
#
cmake_minimum_required (VERSION 3.10)

project ("TrymeLinux")

# Include sub-projects.
add_subdirectory ("TrymeLinux")

# Deploy settings (can be overridden in CMake GUI / presets)
set(DEPLOY_PRESET "arm64-wsl" CACHE STRING "CMake preset to build before deploy")
set(DEPLOY_REMOTE_USER "mevepe" CACHE STRING "Remote SSH user for deploy")
set(DEPLOY_REMOTE_KEY "~/.ssh/wsl-remote-debug" CACHE STRING "Path to private key for SSH")
set(DEPLOY_REMOTE_HOST "192.168.0.100" CACHE STRING "Remote host for deploy")
set(DEPLOY_REMOTE_DIR "/home/mevepe/app" CACHE STRING "Remote directory to copy files to")

add_custom_target(deploy_armbian
WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
COMMAND ${CMAKE_SOURCE_DIR}/deploy/deploy_armbian.sh ${DEPLOY_PRESET} ${DEPLOY_REMOTE_USER} ${DEPLOY_REMOTE_KEY} ${DEPLOY_REMOTE_HOST} ${DEPLOY_REMOTE_DIR}
)
