#!/bin/bash
set -ouex pipefail
echo "installing COPR packages"

declare -A RPM_PACKAGES=(
  ["copr:iucar/rstudio"]="rstudio-desktop"
  ["copr:iucar/duckdb"]="duckdb"
  ["copr:ublue-os/packages"]="ublue-brew"
)

# install COPR repos
for repo in "${!RPM_PACKAGES[@]}"; do
  read -ra pkg_array <<<"${RPM_PACKAGES[$repo]}"
    copr_repo=${repo#copr:}
    dnf5 -y copr enable "$copr_repo"
    dnf5 -y install "${pkg_array[@]}"
    dnf5 -y copr disable "$copr_repo"
done
