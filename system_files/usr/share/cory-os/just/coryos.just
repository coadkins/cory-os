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
    if [ "$(systemctl is-enabled $service 2>/dev/null)" = "masked" ]; then
      echo Unmasking $service
      systemctl unmask "$service"
    fi
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
# Disable system76 services
disable-system76:
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
  echo "=== Managing System76 Power Profiles ==="
  # Check and manage tuned services
  MASK_SERVICES=("com.system76.PowerDaemon.service")
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
  echo "=== Managing Tuned Power Profiles ==="
  # List of tuned services to enable
  TUNED_SERVICES=(
      "tuned.service tuned-ppd"
      )
  for service in $TUNED_SERVICES; do
    if [ "$(systemctl is-enabled $service 2>/dev/null)" = "masked" ]; then
      echo "Unmasking $service"
      systemctl unmask $service
    fi

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
  for service in $TUNED_SERVICES; do
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

# setup-incus: Configure the system and initialize Incus.
setup-incus:
#!/usr/bin/env bash
  # This recipe wraps the original bash script to be run via `just`.
  # It ensures the script is not run as root, sources necessary helper scripts,
  # performs privileged operations using pkexec, and guides the user
  # through the Incus initialization process.

  set -euxo pipefail

  # Ensure the script is not run as the root user.
  if [ "$EUID" -eq 0 ]; then
      echo "This script should not be run as root"
      exit 1
  fi

  # Source the ujust helper functions.
  # This file must exist at the specified path for the recipe to work.
  source /usr/lib/ujust/ujust.sh

  # Add the current user to the 'incus-admin' group.
  echo "Adding user '$USER' to the 'incus-admin' group..."
  pkexec usermod -aG incus-admin $USER

  # Check for and add necessary entries to /etc/subuid and /etc/subgid.
  echo -e "\nChecking for necessary entries in /etc/subuid and /etc/subgid..."

  # Define the required root range for subuids/subgids.
  ROOT_RANGE="root:1000000:1000000000"
  USER_SUBID="root:$UID:1"

  # Check and configure /etc/subuid
  if grep -q "^${ROOT_RANGE}$" /etc/subuid; then
      echo "  * subuid root range already exists."
  else
      echo "Adding subuid root range..."
      echo "$ROOT_RANGE" | pkexec tee -a /etc/subuid
  fi

  if grep -q "^${USER_SUBID}$" /etc/subuid; then
      echo "  * subuid root->user mapping already exists."
  else
      echo "Adding subuid root->user mapping..."
      echo "$USER_SUBID" | pkexec tee -a /etc/subuid
  fi

  # Check and configure /etc/subgid
  if grep -q "^${ROOT_RANGE}$" /etc/subgid; then
      echo "  * subgid root range already exists."
  else
      echo "Adding subgid root range..."
      echo "$ROOT_RANGE" | pkexec tee -a /etc/subgid
  fi

  if grep -q "^${USER_SUBID}$" /etc/subgid; then
      echo "  * subgid root->user mapping already exists."
  else
      echo "Adding subgid root->user mapping..."
      echo "$USER_SUBID" | pkexec tee -a /etc/subgid
  fi

  # Enable and start Incus services.
  echo -e "\nEnabling and starting Incus services..."
  pkexec /usr/bin/bash <<EOF
  systemctl enable --now incus-workaround.service
  systemctl enable --now lxcfs
  systemctl enable --now incus.socket
  systemctl start incus.service
  systemctl enable incus-startup
  EOF
  echo "Incus services enabled."

  # Initialize Incus based on user choice.
  echo -e "\nInitializing Incus..."
  echo "Choose your Incus installation type:"
  OPTION=$(Choose Minimal Custom Cancel)

  if [[ "${OPTION,,}" =~ ^minimal ]]; then
      echo "Performing minimal Incus initialization..."
      pkexec incus admin init --minimal
      echo -e "\nAdding the incus bridge to the trusted firewall zone..."
      pkexec firewall-cmd --zone=trusted --change-interface=incusbr0 --permanent
      pkexec firewall-cmd --reload
  elif [[ "${OPTION,,}" =~ ^custom ]]; then
      echo "Starting custom Incus initialization..."
      pkexec incus admin init
      echo ""
      cat <<EOF
  Add the incus bridge to the trusted firewall zone with:
  \`\`\`bash
    sudo firewall-cmd --zone=trusted --change-interface=your-bridge --permanent
    sudo firewall-cmd --reload
  \`\`\`
  EOF
  elif [[ "${OPTION,,}" =~ ^cancel ]]; then
      echo "You have chosen to cancel the Incus initialization process."
      exit 0
  fi

  echo -e "\nIncus has been installed. You can now run 'incus' to manage your containers."
