#!/bin/bash

set -oeux pipefail
# incus web UI
wget https://pkgs.zabbly.com/incus/stable/pool/main/i/incus/incus-ui-canonical_6.16-debian11-202509082238_amd64.deb -O /tmp/incus-ui-canonical.deb
dpkg -x /tmp/incus-ui-canonical.deb /tmp/incus-ui/
mkdir -p /usr/share/incus/
cp -r /tmp/incus-ui/opt/incus/. /usr/share/incus/
