#!/usr/bin/env bash
set -euxo pipefail

sudo chown -R  ${USER_UID}:${USER_GID} /home/${USERNAME}

# Entry 1: ensure configured measurespath exists.
TARGET_DIR="/home/${USERNAME}/.casa/data"
mkdir -p "$TARGET_DIR"
sudo chown -R ${USER_UID}:${USER_GID} "$TARGET_DIR"

# Entry 2: ensure raw/science data folder exists and is owned by user in container.
mkdir -p "/home/${USERNAME}/casa/data"
sudo chown -R ${USER_UID}:${USER_GID} "/home/${USERNAME}/casa/data"

# Entry 3: ensure logs folder exists and is owned by user in container.
mkdir -p "/home/${USERNAME}/casa/logs"
sudo chown -R ${USER_UID}:${USER_GID} "/home/${USERNAME}/casa/logs"

exec "$@"
