#!/bin/bash

set -ouex pipefail

echo "installing packages from official fedora repos"
dnf5 install -y \
	neovim \
	emacs-pgtk \
	rsync \
	make \
    unixODBC-devel \
	libcurl-devel \
	openssl-devel \
	glpk-devel \
	incus \
	dpkg


