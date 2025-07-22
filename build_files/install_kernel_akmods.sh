#!/usr/bin/bash

set -eoux pipefail

echo "::group::Executing install-kernel-akmods"
trap 'echo "::endgroup::"' EXIT

dnf5 -y copr enable ssweeny/system76-hwe

dnf5 versionlock add kernel kernel-devel kernel-devel-matched kernel-core kernel-modules kernel-modules-core kernel-modules-extra kernel-tools kernel-tools-libs

dnf5 -y install \
    /var/tmp/akmods-extra-rpms/kmods/kmod-system76-io*.rpm \
    /var/tmp/akmods-extra-rpms/kmods/kmod-system76*.rpm

dnf5 -y copr disable ssweeny/system76-hwe

# To Do: get rid of akmods that I don't want
