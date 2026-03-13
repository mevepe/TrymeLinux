# CMakeList.txt : CMake project for TrymeLinux, include source and define
# project specific logic here.
#

# Add source to this project's executable.
add_executable (TrymeLinux "TrymeLinux.cpp")

if (CMAKE_VERSION VERSION_GREATER 3.12)
  set_property(TARGET TrymeLinux PROPERTY CXX_STANDARD 20)
endif()

set_target_properties(TrymeLinux PROPERTIES LINKER_LANGUAGE CXX)
target_include_directories(TrymeLinux PRIVATE ${ROOTFS}/usr/include)
target_link_directories(TrymeLinux PRIVATE ${ROOTFS}/usr/lib/aarch64-linux-gnu)
target_link_libraries(TrymeLinux PRIVATE gpiodcxx gpiod)

# TODO: Add tests and install targets if needed.

# Deploy settings (can be overridden in CMake GUI / presets)
set(DEPLOY_PRESET "arm64-wsl" CACHE STRING "CMake preset to build before deploy")
set(DEPLOY_REMOTE_USER "mevepe" CACHE STRING "Remote SSH user for deploy")
set(DEPLOY_REMOTE_KEY "~/.ssh/wsl-remote-debug" CACHE STRING "Path to private key for SSH")
set(DEPLOY_REMOTE_HOST "192.168.0.100" CACHE STRING "Remote host for deploy")
set(DEPLOY_REMOTE_DIR "/home/mevepe/app" CACHE STRING "Remote directory to copy files to")

add_custom_command(TARGET TrymeLinux POST_BUILD
  COMMAND ${CMAKE_COMMAND} -E echo "Deploying to Remote..."
  COMMAND ssh -i ${DEPLOY_REMOTE_KEY} ${DEPLOY_REMOTE_USER}@${DEPLOY_REMOTE_HOST} "mkdir -p ${DEPLOY_REMOTE_DIR}"
  COMMAND rsync -avz -e "ssh -i ${DEPLOY_REMOTE_KEY}" $<TARGET_FILE:TrymeLinux> ${DEPLOY_REMOTE_USER}@${DEPLOY_REMOTE_HOST}:${DEPLOY_REMOTE_DIR}
  COMMAND ssh -i ${DEPLOY_REMOTE_KEY} ${DEPLOY_REMOTE_USER}@${DEPLOY_REMOTE_HOST} "chmod +x ${DEPLOY_REMOTE_DIR}/$<TARGET_FILE_NAME:TrymeLinux>"
  COMMAND ${CMAKE_COMMAND} -E echo "Deploying done"
)
