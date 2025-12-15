#!/bin/bash

# Define the user and essential commands
USER_NAME="$USER"
BASHRC="$HOME/.bashrc"
KUBECTL_PATH="$HOME/.local/bin"
FLAG_FILE="/tmp/minikube_setup_complete"

# --- 1. Installation Flag Check ---
if [ ! -f "$FLAG_FILE" ]; then

    echo "--- 1. System Setup and Prerequisites ---"
    # The following line will fail if run from user_data without sudo, 
    # but since user_data usually runs as root or a privileged user, 
    # and you are using `sudo`, it should work fine.
    sudo apt update && sudo apt install git maven docker.io openjdk-17-jdk -y
    sudo systemctl start docker
    sudo systemctl enable docker

    # Add user to the docker group
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
    mkdir -p "$KUBECTL_PATH"
    mv ./kubectl "$KUBECTL_PATH/kubectl"

    echo "--- 4. Configure PATH ---"
    # Ensure PATH is added to .bashrc
    if ! grep -q "export PATH=\"$KUBECTL_PATH:\$PATH\"" "$BASHRC"; then
        echo "export PATH=\"$KUBECTL_PATH:\$PATH\"" >> "$BASHRC"
    fi
    
    # Create the temporary flag file to signal completion
    touch "$FLAG_FILE"

    echo ""
    echo "=========================================================="
    echo "✅ Setup Complete. Your user has been added to the docker group."
    echo "❗️ **ACTION REQUIRED:** You must LOG OUT and LOG BACK IN"
    echo "   or start a new shell session (e.g., `exec bash`) for"
    echo "   the Docker and kubectl permissions/PATH to take effect."
    echo "=========================================================="
    
    # Exit the script without trying to run minikube
    exit 0
    
else # This part is for the user to run *after* logging back in

    echo "--- 5. Setup Verification and Minikube Start ---"
    
    # Use 'exec bash' or 'source .bashrc' to ensure PATH is loaded for *this* shell
    source "$BASHRC"

    # Verify Docker permissions are active
    echo "Verifying Docker permissions..."
    docker run hello-world || { 
        echo "ERROR: Docker command failed. Check 'groups' output to confirm 'docker' membership."; 
        # Do not delete the flag, as setup is still complete.
        exit 1;
    }

    echo "Verifying Kubectl installation..."
    # Use the full path for extra safety, though source "$BASHRC" should fix it
    "$KUBECTL_PATH/kubectl" version --client

    echo "--- 6. Starting Minikube ---"
    minikube start --driver=docker

    echo "Checking Minikube status..."
    minikube status
    
    # Clean up the flag file
    rm -f "$FLAG_FILE"
    echo "✅ Minikube setup and start complete!"
fi