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
    
    echo "=== Managing Gnome Power Profiles ==="
    
    # Check and manage power-profiles-daemon.service
    SERVICE="power-profiles-daemon.service"
    
    if service_exists "$SERVICE"; then
        echo "Found $SERVICE"
        
        # Check if service is running and stop it
        if is_service_active "$SERVICE"; then
            echo "Service $SERVICE is running, stopping it..."
            sudo systemctl stop "$SERVICE"
            echo "Service $SERVICE stopped"
        else
            echo "Service $SERVICE is not running"
        fi
        
        # Check if service is enabled and disable it
        if is_service_enabled "$SERVICE"; then
            echo "Service $SERVICE is enabled, disabling it..."
            sudo systemctl disable "$SERVICE"
            echo "Service $SERVICE disabled"
        else
            echo "Service $SERVICE is not enabled"
        fi
        
        # Mask the service
        echo "Masking $SERVICE..."
        sudo systemctl mask "$SERVICE"
        echo "Service $SERVICE masked"
    else
        echo "Service $SERVICE not found on this system"
    fi
    
    echo ""
    echo "=== Managing System76 Services ==="
    
    # List of System76 services to enable
    SYSTEM76_SERVICES=(
        "com.system76.PowerDaemon.service"
        "system76-power-wake"
        "system76-firmware-daemon"
    )
    
    for service in "$SYSTEM76_SERVICES[@]}"; do
        echo "Checking $service..."
        
        if service_exists "$service"; then
            echo "Found $service"
            
            # Check current status
            if is_service_enabled "$service"; then
                echo "Service $service is already enabled"
            else
                echo "Service $service is not enabled, enabling it..."
                sudo systemctl enable "$service"
                echo "Service $service enabled"
            fi
            
            # Check if service is running
            if is_service_active "$service"; then
                echo "Service $service is already running"
            else
                echo "Service $service is not running, starting it..."
                sudo systemctl start "$service"
                echo "Service $service started"
            fi
        else
            echo "WARNING: Service $service not found on this system"
        fi
        echo ""
    done
    
    echo "=== Service Management Complete ==="

# Optional: Show final status of all services
echo "Final status check:"
for service in "$SERVICE" "${SYSTEM76_SERVICES[@]}"; do
    if service_exists "$service"; then
        echo -n "$service: "
        if is_service_enabled "$service"; then
            echo -n "enabled, "
        else
            echo -n "disabled, "
        fi
        if is_service_active "$service"; then
            echo "running"
        else
            echo "stopped"
        fi
    fi
done
# Create ds-distrobox
ds-distrobox-create:
    #!/usr/bin/bash
    set -eoux pipefail

    # Get the current working directory name and full path
    PWD_NAME=$(basename "$PWD")
    PWD_PATH="$PWD"
    
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
    
    echo
    echo "Container '$PWD_NAME' created successfully!"
    echo "To enter the container, run: distrobox enter $PWD_NAME"
