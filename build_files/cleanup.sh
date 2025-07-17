#!/bin/bash
set -oeux pipefail

# Clean /var directory while preserving essential files
find /var/* -maxdepth 0 -type d \! -name cache \! -name usrlocal -exec rm -fr {} \;
find /var/cache/* -maxdepth 0 -type d \! -name libdnf5 \! -name rpm-ostree -exec rm -fr {} \;

# restore and set up /var/tmp
mkdir -p /var/tmp
chmod -R 1777 /var/tmp
