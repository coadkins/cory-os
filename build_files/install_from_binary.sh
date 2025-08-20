#!/bin/bash

set -oeux pipefail

# min browser
wget https://github.com/minbrowser/min/releases/download/v1.35.1/min-1.35.1-x86_64.rpm -O /tmp/minbrowser.rpm
dnf5 install -y /tmp/minbrowser.rpm

# incus web UI
wget https://pkgs.zabbly.com/incus/stable/pool/main/i/incus/incus-ui-canonical_6.15-ubuntu24.04-202508170325_amd64.deb -O /tmp/incus-ui-canonical.deb
dpkg -x /tmp/incus-ui-canonical.deb /tmp/incus-ui/
mkdir -p /usr/share/incus/
cp -r /tmp/incus-ui/opt/incus/. /usr/share/incus/
