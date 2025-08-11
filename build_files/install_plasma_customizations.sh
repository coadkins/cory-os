#!/bin/bash

set -e

# set up 3rd party plasmoids in /etc/skel
mkdir -p /etc/skel/.local/share.plasma/plasmoids

# Install 'kara' virtual desktop pills
git clone https://github.com/dhruv8sh/kara.git /var/tmp/kara
cd /var/tmp/kara
cp -r . /etc/skel/.local/share/plasma/plasmoids/org.dhruv8sh.kara

