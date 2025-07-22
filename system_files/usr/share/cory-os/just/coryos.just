# Install  Homebrews
install-cory-brews:
  #!/usr/bin/env bash
  set -uo pipefail
  echo "Installing Cory's Favorite Homebrews..."
  xargs -a <(curl --retry 3 -sL https://raw.githubusercontent.com/coadkins/cory-os/main/repo_files/brews) brew install
  echo "Homebrews installation complete."

# Install Flatpaks 
install-cory-flatpaks:
  #!/usr/bin/env bash
  set -euo pipefail
  echo "Installing Cory's Favorite Flatpaks..."
  xargs -a <(curl --retry 3 -sL https://raw.githubusercontent.com/coadkins/cory-os/main/repo_files/flatpaks) flatpak -y --system install
  echo "Flatpak installation complete."

# Enable System76
enable-system76:
  #!/usr/bin/env bash
  set -euo pipefail
  # Function to check if a service is active (running)
  is_service_active() {
    systemctl is-active --quiet "$1" 2>/dev/null
   }
  # Function to check if a service is enabled
  is_service_enabled() {
    systemctl is-enabled --quiet "$1" 2>/dev/null
  }
  # Function to check if a service exists
  service_exists() {
    systemctl list-unit-files --type=service | grep -q "^$1"
  }
  echo "=== Managing Tuned Power Profiles ==="
  # Check and manage tuned services
  MASK_SERVICES=("tuned.service tuned-ppd")
  for service in "$MASK_SERVICES"; do
    if service_exists $service; then
      echo "Found $service"
      # Check if service is running and stop it
      if is_service_active $service; then
        echo "Service $service is running, stopping it..."
        sudo systemctl stop $service
        echo "Service $service stopped"
      else
        echo "Service $service is not running"
      fi
       # Check if service is enabled and disable it
      if is_service_enabled $service; then
        echo "Service $service is enabled, disabling it..."
        sudo systemctl disable $service
        echo "Service $service disabled"
      else
         echo "Service $service is not enabled"
      fi
       # Mask the service
       echo "Masking $service..."
       sudo systemctl mask $service
       echo "Service $service masked"
       else
         echo "Service $service not found on this system"
     fi
  done
  echo "=== Managing System76 Services ==="
  # List of System76 services to enable
  SYSTEM76_SERVICES=(
      "com.system76.PowerDaemon.service system76-power-wake system76-firmware-daemon"
      )
  for service in $SYSTEM76_SERVICES; do
    echo "Checking $service..."
    if service_exists $service; then
      echo "Found $service"
      # Check current status
      if is_service_enabled $service; then
        echo "Service $service is already enabled"
      else
        echo "Service $service is not enabled, enabling it..."
        if sudo systemctl enable $service; then
          echo "Service $service enabled"
        else
          echo "Error: Service $service could not be enabled"
        fi
      fi
      # Check if service is running
      if is_service_active $service; then
        echo "Service $service is already running"
      else
        echo "Service $service is not running, starting it..."
        if sudo systemctl start $service; then
          echo "Service $service started"
        else
          echo "Error: Could not start $service"
        fi
      fi
    else
      echo "WARNING: Service $service not found on this system"
    fi
  done
  echo "=== Service Management Complete ==="
  for service in $SYSTEM76_SERVICES; do
    if service_exists $service; then
      echo -n "$service: "
      if is_service_enabled $service; then
        echo -n "enabled, "
      else
        echo -n "disabled, "
      fi
      if is_service_active $service; then
        echo "running"
      else
        echo "stopped"
      fi
      fi
   done
# Enable System76
enable-system76:
  #!/usr/bin/env bash
  set -euo pipefail
  # Function to check if a service is active (running)
  is_service_active() {
    systemctl is-active --quiet "$1" 2>/dev/null
   }
  # Function to check if a service is enabled
  is_service_enabled() {
    systemctl is-enabled --quiet "$1" 2>/dev/null
  }
  # Function to check if a service exists
  service_exists() {
    systemctl list-unit-files --type=service | grep -q "^$1"
  }
  echo "=== Managing Tuned Power Profiles ==="
  # Check and manage tuned services
  MASK_SERVICES=("tuned.service tuned-ppd")
  for service in "$MASK_SERVICES"; do
    if service_exists $service; then
      echo "Found $service"
      # Check if service is running and stop it
      if is_service_active $service; then
        echo "Service $service is running, stopping it..."
        sudo systemctl stop $service
        echo "Service $service stopped"
      else
        echo "Service $service is not running"
      fi
       # Check if service is enabled and disable it
      if is_service_enabled $service; then
        echo "Service $service is enabled, disabling it..."
        sudo systemctl disable $service
        echo "Service $service disabled"
      else
         echo "Service $service is not enabled"
      fi
       # Mask the service
       echo "Masking $service..."
       sudo systemctl mask $service
       echo "Service $service masked"
       else
         echo "Service $service not found on this system"
     fi
  done
  echo "Restarting systemd daemon"
  sudo systemctl daemon-reexec
  echo "=== Managing System76 Services ==="
  # List of System76 services to enable
  SYSTEM76_SERVICES=(
      "com.system76.PowerDaemon.service system76-power-wake system76-firmware-daemon"
      )
  for service in $SYSTEM76_SERVICES; do
    echo "Checking $service..."
    if service_exists $service; then
      echo "Found $service"
      # Check current status
      if is_service_enabled $service; then
        echo "Service $service is already enabled"
      else
        echo "Service $service is not enabled, enabling it..."
        if sudo systemctl enable $service; then
          echo "Service $service enabled"
        else
          echo "Error: Service $service could not be enabled"
        fi
      fi
      # Check if service is running
    else
      echo "WARNING: Service $service not found on this system"
    fi
  done
  echo "=== Service Management Complete ==="
  for service in $SYSTEM76_SERVICES; do
    if service_exists $service; then
      echo -n "$service: "
      if is_service_enabled $service; then
        echo -n "enabled, "
      else
        echo -n "disabled, "
      fi
      if is_service_active $service; then
        echo "running"
      else
        echo "stopped"
      fi
      fi
   done
# Create ds-distrobox
create-ds-distrobox:
  #!/usr/bin/env bash
  set -euo pipefail

  # Get the current working directory name and full path
  PWD_NAME=$(basename "$(pwd)")
  PWD_PATH="$(pwd)"
  
  # Display what we're about to do
  echo "Creating distrobox container with:"
  echo "  Name: $PWD_NAME"
  echo "  Home: $PWD_PATH"
  echo "  Image: ghcr.io/coadkins/ds-distrobox:latest"
  
  # Check if a container with this name already exists
  if distrobox list | grep -q "^$PWD_NAME"; then
    echo "Error: A distrobox container named '$PWD_NAME' already exists."
    echo "Please remove it first with: distrobox rm $PWD_NAME"
    exit 1
  fi
  
  # Run the distrobox create command
  echo "Running distrobox create..."
  distrobox create \
      --image ghcr.io/coadkins/ds-distrobox:latest \
      --name "$PWD_NAME" \
      --home "$PWD_PATH" \
      --init
  
  echo "Container '$PWD_NAME' created successfully!"
  echo "To enter the container, run: distrobox enter $PWD_NAME"
