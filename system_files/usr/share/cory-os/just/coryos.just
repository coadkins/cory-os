# Install  Homebrews
  ds-install-brews:
  #!/usr/bin/env bash
  set -euo pipefail

  echo "Installing Cory's Favorite Homebrews..."
  xargs -a <(curl --retry 3 -sL https://raw.githubusercontent.com/coadkins/cory-os/main/repo_files/brews) brew install
  echo "Homebrews installation complete."




