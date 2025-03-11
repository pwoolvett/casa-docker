#!/usr/bin/env bash

set -euxo pipefail

Xvfb \
  :0 \
  -ac \
  -listen tcp \
  -screen 0 \
  1920x1080x24 \
& \
sleep 3 \
&& openbox \
  -display :0 \
  -screen 0 \
& \
sleep 3 \
&& x11vnc \
  -display :0 \
  -forever \
&
