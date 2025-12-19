#!/bin/bash

# --- Essential Definitions ---
# Ensure HOME is set, which is crucial for KUBECTL_PATH to resolve correctly.
# This fixes the 'mkdir: cannot create directory ‘’: No such file or directory' error.
if [ -z "$HOME" ]; then
    HOME=$(getent passwd "$USER" | cut -d: -f6)
fi

USER_NAME="$USER"
BASHRC="$HOME/.bashrc"
KUBECTL_PATH="$HOME/.local/bin"
FLAG_FILE="/tmp/minikube_setup_complete"


# --- 1. Installation Flag Check ---
if [ ! -f "$FLAG_FILE" ]; then

    echo "--- 1. System Setup and Prerequisites ---"
    # Update and install essentials
    sudo apt update && sudo apt install git maven docker.io openjdk-17-jdk -y
    sudo systemctl start docker
    sudo systemctl enable docker

    # Add user to the docker group (Requires new session to activate)
    echo "Adding user '$USER_NAME' to the docker group..."
    sudo usermod -aG docker "$USER_NAME"

    echo "--- 2. Install Minikube ---"
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
    rm minikube-linux-amd64

    echo "--- 3. Install Kubectl ---"
    KUBE_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
    curl -LO "https://dl.k8s.io/release/${KUBE_VERSION}/bin/linux/amd64/kubectl"
    chmod +x kubectl
    
    # Use sudo here to create the directory just in case permissions are strict, 
    # but the path is still defined using the user's HOME.
    mkdir -p "$KUBECTL_PATH" 
    mv ./kubectl "$KUBECTL_PATH/kubectl"

    echo "--- 4. Configure PATH ---"
    # Ensure PATH is added to .bashrc
    if ! grep -q "export PATH=\"$KUBECTL_PATH:\$PATH\"" "$BASHRC"; then
        echo "export PATH=\"$KUBECTL_PATH:\$PATH\"" >> "$BASHRC"
    fi
    
    # Create the temporary flag file to signal completion (using sudo to ensure it's deletable)
    sudo touch "$FLAG_FILE"

    echo ""
    echo "--- 5. Rerunning Script to Apply Permissions and PATH ---"
    echo "This script will now execute 'newgrp docker' and re-execute itself to load permissions."
    
    # Use 'newgrp' to create a new session with updated group permissions 
    # and then execute the script again (recursively)
    exec newgrp docker "$0"
    
else # Script will continue execution from here after 'newgrp docker'

    echo "--- 5. Permissions and PATH Activated ---"
    # Re-source the bashrc to ensure the PATH is active in the new shell
    source "$BASHRC"

    # Verify Docker permissions are active
    echo "Verifying Docker permissions..."
    docker run hello-world || { 
        echo "ERROR: Docker permission still denied. Please try logging out and logging back in."; 
        # Attempt to remove flag with sudo if current user can't
        sudo rm -f "$FLAG_FILE";
        exit 1;
    }

    echo "Verifying Kubectl installation..."
    # Verify both the executable location and command execution
    if [ -x "$KUBECTL_PATH/kubectl" ]; then
        "$KUBECTL_PATH/kubectl" version --client
    else
        echo "ERROR: Kubectl executable not found at '$KUBECTL_PATH/kubectl'."
        sudo rm -f "$FLAG_FILE";
        exit 1;
    fi

    echo "--- 6. Starting Minikube ---"
    # The warning about memory is normal, but let's use a safe setting.
    # minikube start --driver=docker --memory=3072mb
    minikube start --cpus 6 --memory 24576mb --driver=docker 
    minikube addons enable metrics-server

    echo "Checking Minikube status..."
    minikube status
    
    # Clean up the flag file
    sudo rm -f "$FLAG_FILE"
    echo "✅ Minikube setup and start complete!"
fi