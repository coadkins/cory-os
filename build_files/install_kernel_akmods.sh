#!/usr/bin/bash

set -eoux pipefail

echo "::group::Executing install-kernel-akmods"
trap 'echo "::endgroup::"' EXIT

dnf5 -y copr enable ssweeny/system76-hwe

dnf5 versionlock add kernel kernel-devel kernel-devel-matched kernel-core kernel-modules kernel-modules-core kernel-modules-extra kernel-tools kernel-tools-libs

dnf5 -y install \
    /var/tmp/akmods-extra-rpms/kmods/kmod-system76-io*.rpm \
    /var/tmp/akmods-extra-rpms/kmods/kmod-system76*.rpm

dnf5 -y remove \
    kmod-kvmfr \
    kmod-xone \
    kmod-openrazer \
    kmod-v412loopback \
    kmod-wl \
    kmod-framework-laptop \
    kmod-nct6887 \
    kmod-gcadapter_oc \
    kmod-vhba \
    kmod-gpd-fan \
    kmod-ayaneo-platform \
    kmod-ayn-platform \
    kmod-bmi260

dnf5 -y copr disable ssweeny/system76-hwe
