#!/bin/bash
set -ouex pipefail
echo "add vscodium rpm keys and repo"
rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=download.vscodium.com\nbaseurl=https://download.vscodium.com/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg\nmetadata_expire=1h\n" | sudo tee -a /etc/yum.repos.d/vscodium.repo
echo "installing vscodium"
dnf5 install -y codium
echo "disabling vscodium repo"
dnf5 config-manager setopt gitlab.com_paulcarroty_vscodium_repo.enabled=0
# add ghostty as AppImage
# Ghostty as appimage :(
while [[ -z "${GHOSTTY:-}" || "${GHOSTTY:-}" == "null" ]]; do
    GHOSTTY="$(curl -L https://api.github.com/repos/pkgforge-dev/ghostty-appimage/releases/latest | jq -r '.assets[] | select(.name| test("Ghostty-[0-9].*-x86_64.AppImage$")).browser_download_url')" || (true && sleep 5)
done
curl --retry 3 -Lo /tmp/ghostty.appimage "$GHOSTTY"
cd /tmp/
chmod +x /tmp/ghostty.appimage
/tmp/ghostty.appimage --appimage-extract
mkdir -p /usr/share/icons/hicolor/256x256/apps/
cp /tmp/AppDir/"$(readlink /tmp/squashfs-root/*.png)" /usr/share/icons/hicolor/256x256/apps/
cp /tmp/AppDir/"$(readlink /tmp/squashfs-root/*.desktop)" /usr/share/applications/
install -m 0755 /tmp/ghostty.appimage /usr/bin/ghostty
