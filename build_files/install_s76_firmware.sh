#!/bin/bash
set -oeux pipefail
# install system76 support packages
dnf5 -y copr enable szydell/system76
dnf install -y \
  system76-firmware \
dnf copr disable szydell/system76
systemctl enable system76-firmware-daemon
