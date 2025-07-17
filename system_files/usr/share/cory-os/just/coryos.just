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
    
    echo "Container '$PWD_NAME' created successfully!"
    echo "To enter the container, run: distrobox enter $PWD_NAME"
