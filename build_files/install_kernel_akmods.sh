#!/usr/bin/bash

set -eoux pipefail

echo "::group::Executing install-kernel-akmods"
trap 'echo "::endgroup::"' EXIT

dnf5 -y remove --no-autoremove kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra kernel-tools kernel-tools-libs kernel-uki-virt

dnf5 -y --setopt=disable_excludes=* install \
    /var/tmp/kernel-rpms/kernel-[0-9]*.rpm \
    /var/tmp/kernel-rpms/kernel-core-*.rpm \
    /var/tmp/kernel-rpms/kernel-modules-*.rpm \
    /var/tmp/kernel-rpms/kernel-tools-[0-9]*.rpm \
    /var/tmp/kernel-rpms/kernel-tools-libs-[0-9]*.rpm \
    /var/tmp/kernel-rpms/kernel-devel-*.rpm

dnf5 versionlock add kernel kernel-devel kernel-devel-matched kernel-core kernel-modules kernel-modules-core kernel-modules-extra kernel-tools kernel-tools-libs

dnf5 -y install \
    /var/tmp/akmods-rpms/ublue-os/ublue-os-akmods-addons*.rpm \
    /var/tmp/akmods-extra-rpms/kmods/system76-driver-kmod-common*.rpm \
    /var/tmp/akmods-extra-rpms/kmods/system76-io-kmod-common*.rpm \
    /var/tmp/akmods-extra-rpms/kmods/kmod-system76-io*.rpm \
    /var/tmp/akmods-extra-rpms/kmods/kmod-system76*.rpm
