#!/bin/bash
set -ouex pipefail
LINUX_ARCH=x64
# scrape for latest positron version
POSITRON_V=$(wget -qO- https://positron.posit.co/download.html | grep -oP "Positron-\K[0-9]+\.[0-9]+\.[0-9]+-[0-9]+" | head -1)
# download
POSITRON_URL="https://cdn.posit.co/positron/dailies/rpm/x86_64/Positron-${POSITRON_V}-${LINUX_ARCH}.rpm"
wget "$POSITRON_URL" -O positron.rpm
dnf5 -y install positron.rpm
rm positron.rpm
