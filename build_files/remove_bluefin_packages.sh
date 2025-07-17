#!/bin/bash
set -ouex pipefail
# remove packages installed with dnf
dnf remove -y \
	code 

# disable power profiles daemon in favor of system76 one
systemctl stop power-profiles-daemon.service
systemctl disable power-profiles-daemon.service
systemctl mask power-profiles-daemon.service
