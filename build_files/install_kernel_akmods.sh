#!/usr/bin/bash
set -eoux pipefail
# install newer kernel
dnf5 -y install \
    /var/tmp/kernel-rpms/kernel-[0-9]*.rpm \
    /var/tmp/kernel-rpms/kernel-core-*.rpm \
    /var/tmp/kernel-rpms/kernel-modules-*.rpm \
    /var/tmp/kernel-rpms/kernel-tools-[0-9]*.rpm \
    /var/tmp/kernel-rpms/kernel-tools-libs-[0-9]*.rpm \
    /var/tmp/kernel-rpms/kernel-devel-*.rpm

echo "::group::Executing install-kernel-akmods"
trap 'echo "::endgroup::"' EXIT

dnf5 -y copr enable ssweeny/system76-hwe

dnf5 versionlock add kernel kernel-devel kernel-devel-matched kernel-core kernel-modules kernel-modules-core kernel-modules-extra kernel-tools kernel-tools-libs

dnf5 -y install \
    /var/tmp/akmods-extra-rpms/kmods/kmod-system76-io*.rpm \
    /var/tmp/akmods-extra-rpms/kmods/kmod-system76*.rpm

dnf5 -y copr disable ssweeny/system76-hwe
