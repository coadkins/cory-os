# Install  Homebrews
cory-install-brews:
  #!/usr/bin/bash
  set -eoux pipefail
  echo "Installing Cory's Favorite Homebrews..."
  xargs -a <(curl --retry 3 -sL https://raw.githubusercontent.com/coadkins/cory-os/main/repo_files/brews) brew install
  echo "Homebrews installation complete."

# Install Flatpaks 
cory-install-flatpaks:
    #!/usr/bin/bash
    set -eoux pipefail
    echo "Installing Cory's Favorite Flatpaks..."
    xargs -a <(curl --retry 3 -sL https://raw.githubusercontent.com/coadkins/cory-os/main/repo_files/flatpaks) flatpak -y --system install
    echo "Flatpak installation complete."

# Enable System76
cory-enable-system76:
    #!/usr/bin/bash
    set -eoux pipefail
    echo "Disabling Gnome Power Profiles"
    sudo systemctl stop power-profiles-daemon.service
    sudo systemctl disable power-profiles-daemon.service
    sudo systemctl mask power-profiles-daemon.service
    echo "Enabling System76 background services..."
    sudo systemctl enable com.system76.PowerDaemon.service \
    system76-power-wake \
    echo "enabled!"

# Create ds-distrobox
# TBD: create with home in working directory

# Remove old r versions
# TBD: remove old r versions
