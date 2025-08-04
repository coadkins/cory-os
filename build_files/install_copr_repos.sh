#!/bin/bash
set -ouex pipefail
echo "installing COPR packages"

declare -A RPM_PACKAGES=(
  ["copr:iucar/rstudio"]="rstudio-desktop"
  ["copr:iucar/duckdb"]="duckdb"
  ["copr:ublue-os/packages"]="ublue-brew"
  ["terra"]="zed ghostty"
)

# install COPR repos
for repo in "${!RPM_PACKAGES[@]}"; do
  read -ra pkg_array <<<"${RPM_PACKAGES[$repo]}"
  if [[ $repo == copr:* ]]; then
  # Handle COPR packages
    copr_repo=${repo#copr:}
    dnf5 -y copr enable "$copr_repo"
    dnf5 -y install "${pkg_array[@]}"
    dnf5 -y copr disable "$copr_repo"
else
  # Handle regular packages
  enable_opt="--enable-repo=$repo"
  cmd=(dnf5 -y install)
  [[ -n "enable_opt " ]] && cmd+=("$enable_opt")
  cmd+=("${pkg_array[@]}")
  "${cmd[@]}"
fi
done
