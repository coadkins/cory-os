#!/bin/bash
set -ouex pipefail
# skip install if rstudio/positron quarto is present
if [ -x "$(command -v quarto)" ]; then
	true
    else

# get download url
ARCH="amd64"
QUARTO_DL_URL=$(wget -qO- https://quarto.org/docs/download/_download.json | grep -oP "(?<=\"download_url\":\s\")https.*linux-${ARCH}\.tar.gz")

# download and install
# use /usr/share (not /opt, /usr/local, etc) 
# so that quarto gets updated on the host 
# system when the image updates
wget $QUARTO_DL_URL -O /tmp/quarto.tar.gz
tar -C /usr/share -xvzf /tmp/quarto.tar.gz

# create symlink
EXECUTABLE_PATH=$(find /usr/share -type d -maxdepth 1 -name "quarto-*")
ln -s $EXECUTABLE_PATH/bin/quarto /usr/bin/quarto

# clean up
rm -r /tmp/quarto.tar.gz
fi
