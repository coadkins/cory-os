#!/bin/bash
set -ouex pipefail
echo "add vscodium rpm keys and repo"
rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=download.vscodium.com\nbaseurl=https://download.vscodium.com/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg\nmetadata_expire=1h\n" | sudo tee -a /etc/yum.repos.d/vscodium.repo
echo "installing vscodium"
dnf5 install -y codium
echo "disabling vscodium repo"
dnf5 config-manager setopt gitlab.com_paulcarroty_vscodium_repo.enabled=0

