#!/bin/bash
set -oeux pipefail
# freeze kernel packages just in case
dnf5 versionlock add kernel kernel-devel kernel-devel-matched kernel-core kernel-modules kernel-modules-core kernel-modules-extra kernel-tools kernel-tools-libs
# install system76 support packages
dnf5 -y copr enable szydell/system76
dnf5 install -y \
  system76-driver \
  system76-power \
  system76-firmware \
  firmware-manager
dnf5 -y copr disable szydell/system76
