#!/usr/bin/bash
set -eoux pipefail
# install kernel 6.15.6 for system76 driver compatibility
dnf5 -y --setopt=disable_excludes=* install \
    /var/tmp/kernel-rpms/kernel*.rpm \
    /var/tmp/kernel-rpms/kernel-core*.rpm \
    /var/tmp/kernel-rpms/kernel-modules*.rpm \
    /var/tmp/kernel-rpms/kernel-modules-core*.rpm \
    /var/tmp/kernel-rpms/kernel-modules-extra*.rpm
echo "::group::Executing install-kernel-akmods"
trap 'echo "::endgroup::"' EXIT

# install ublue support package
dnf5 install /var/tmp/akmods-rpms/ublue-os/ublue-os-akmods*.rpm

# install system76 drivers
dnf5 -y copr enable ssweeny/system76-hwe

dnf5 versionlock add kernel kernel-devel kernel-devel-matched kernel-core kernel-modules kernel-modules-core kernel-modules-extra kernel-tools kernel-tools-libs

dnf5 -y install \
    /var/tmp/akmods-extra-rpms/kmods/kmod-system76-io*.rpm \
    /var/tmp/akmods-extra-rpms/kmods/kmod-system76*.rpm

dnf5 -y copr disable ssweeny/system76-hwe
