#!/usr/bin/env bash
# Build (cross) in WSL and deploy to remote Armbian device
set -euo pipefail

# User-configurable
PRESET=${1:-arm64-wsl}
REMOTE_USER=${2:-mevepe}
REMOTE_PRIVATE_KEY=${3:-~/.ssh/wsl-remote-debug}
REMOTE_HOST=${4:-192.168.0.100}
REMOTE_DIR=${5:-/home/${REMOTE_USER}/app}
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="${PROJECT_DIR}/out/build/${PRESET}"

echo "Using preset: ${PRESET}"

# Configure and build using cmake presets
cmake --preset ${PRESET}
cmake --build --preset ${PRESET}

# Find the produced binary (assumes target is named TrymeLinux)
BIN_PATH="${BUILD_DIR}/TrymeLinux/TrymeLinux"
if [ ! -f "${BIN_PATH}" ]; then
  echo "Binary not found at ${BIN_PATH}"
  exit 1
fi

# Create remote dir and copy
ssh -i ${REMOTE_PRIVATE_KEY} ${REMOTE_USER}@${REMOTE_HOST} "mkdir -p ${REMOTE_DIR}"
rsync -avz -e "ssh -i ${REMOTE_PRIVATE_KEY}" --progress "${BIN_PATH}" ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}/
ssh -i ${REMOTE_PRIVATE_KEY} ${REMOTE_USER}@${REMOTE_HOST} "chmod +x ${REMOTE_DIR}/TrymeLinux"

# Run under gdbserver for remote debugging
# start gdbserver on remote on port 2345
ssh -i ${REMOTE_PRIVATE_KEY} -f ${REMOTE_USER}@${REMOTE_HOST} "cd ${REMOTE_DIR} && nohup gdbserver :2345 ./TrymeLinux > gdbserver.log 2>&1 &"
echo "gdbserver started on ${REMOTE_HOST}:2345"
echo "To connect from WSL:"
echo "  gdb ${BIN_PATH}"
echo "  (gdb) target remote ${REMOTE_HOST}:2345"

echo "Deployed to ${REMOTE_HOST}:${REMOTE_DIR}"
