#!/bin/bash
set -e

# --- SPECIFY YOUR VERSION HERE ---
VERSION="v1.31.2"
VERSION="${VERSION//$'\r'/}"

# Automatically detect package manager and install curl if missing
if [ -x "$(command -v apt-get)" ]; then
    echo "Ubuntu/Debian detected. Updating packages and installing curl..."
    sudo apt-get update && sudo apt-get install -y curl
elif [ -x "$(command -v yum)" ]; then
    echo "YUM-based system detected. Installing curl..."
    sudo yum install -y curl
else
    echo "Error: Neither apt-get nor yum found. Please install curl manually."
    exit 1
fi

# --- Downloading kubectl binary version ${VERSION}...
curl -fLO "https://dl.k8s.io/release/${VERSION}/bin/linux/amd64/kubectl"

# --- Validating the downloaded binary...
curl -fLO "https://dl.k8s.io/release/${VERSION}/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

# --- "Installing kubectl to /usr/local/bin..."
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# --- Cleaning up temporary files...
rm kubectl kubectl.sha256

# --- Verification...
/usr/local/bin/kubectl version --client
