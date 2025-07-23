#!/bin/bash
set -ouex pipefail
# remove packages installed with dnf
dnf5 -y remove \
	code
