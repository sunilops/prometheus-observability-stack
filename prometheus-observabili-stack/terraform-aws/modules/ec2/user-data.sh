#!/bin/bash
set -euxo pipefail

# --- Update packages ---
apt-get update -y

# --- Add 2GB swap (small instance types like t3.micro run out of memory fast) ---
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "/swapfile none swap sw 0 0" >> /etc/fstab

# --- Install Docker ---
apt-get install -y ca-certificates curl gnupg
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# --- Allow the default user to run docker without sudo ---
usermod -aG docker ubuntu

# --- Enable docker on boot ---
systemctl enable docker
systemctl start docker

echo "Bootstrap complete: Docker + Docker Compose installed, 2GB swap enabled."
docker version
docker compose version
