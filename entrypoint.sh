#!/usr/bin/env bash
set -euxo pipefail

sudo chown -R  ${USER_UID}:${USER_GID} /home/${USERNAME}

# ensure configured paths exist
TARGET_DIR="/home/${USERNAME}/data"
mkdir -p "$TARGET_DIR"
sudo chown -R ${USER_UID}:${USER_GID} "$TARGET_DIR"


exec "$@"
