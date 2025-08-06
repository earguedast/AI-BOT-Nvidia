#!/bin/bash
#Nvidia-drivers
#eargueda@cisco.com


# Setup the Script Variables
echo "Setting up the Script Variables..."
set -o nounset
disable_apparmor=true
disable_firewall=true
# enable_rootless_docker=true
# enable_system_startup_for_rootless_docker=true


# Start the Private AI Quick Pre-Setup
echo "Starting the Private AI Quick Pre-Setup..."


# Disable AppArmor
if [ "$disable_apparmor" = "true" ]; then
    echo "Disabling AppArmor..."
    sudo systemctl stop apparmor
    sudo systemctl disable apparmor
fi

# Disable Firewall
if [ "$disable_firewall" = "true" ]; then
    echo "Disabling the Firewall..."
    sudo systemctl stop ufw
    sudo systemctl disable ufw
fi

# Install the NVIDIA CUDA Toolkit
echo "Installing the NVIDIA CUDA Toolkit..."
sudo apt install -y linux-headers-$(uname -r) build-essential
sudo apt update -y
#sudo apt install -y linux-headers-$(uname -r) build-essential dkms
#sudo apt update -y
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo apt-get update
sudo apt-get install -y cuda-toolkit-12-8

# Install the NVIDIA Driver (as of 2-12-25, will also automatically install latest NVIDIA open kernel driver (nvidia-open))
if grep -qiE "(microsoft|wsl)" /proc/version; then
    echo "Microsoft WSL has been detected, skipping NVIDIA driver installation for Ubuntu, as host Windows NVIDIA drivers should be used..."
else
    echo "Installing the NVIDIA Driver..."
    sudo apt-get install -y cuda-drivers-570
fi
nvidia-smi

sudo apt install nvidia-fabricmanager-570
sudo systemctl enable nvidia-fabricmanager.service
sudo systemctl start nvidia-fabricmanager.service
#pip install --upgrade vllm
# sudo apt install python3-pip
# pip install accelerate --break-system-packages
# pip install tensorflow --break-system-packages
# pip install torch --break-system-packages
nvidia-smi topo -m
echo "Drivers and libs are installed"
systemctl status nvidia-fabricmanager.service



