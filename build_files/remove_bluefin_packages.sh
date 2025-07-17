#!/bin/bash
set -ouex pipefail
# remove packages installed with dnf
dnf remove -y \
	code \
	upower
