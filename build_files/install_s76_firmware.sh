#!/bin/bash
set -oeux pipefail
# install system76 support packages
dnf5 -y copr enable szydell/system76
dnf install -y \
  system76-driver \
  system76-dkms \
  system76-power \
  system76-firmware \
  firmware-manager \
  system76-acpi-dkms
dnf copr disable szydell/system76


