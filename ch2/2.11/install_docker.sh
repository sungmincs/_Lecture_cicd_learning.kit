#!/usr/bin/env bash

# Docker version
docker_V='5:29.3.1-1~ubuntu.24.04~noble'

# install & enable docker
apt-get update
apt-get install docker-ce=$docker_V docker-ce-cli=$docker_V -y

# Disable IPv6 for Docker — Vagrant VM has no IPv6 routing.
# Without this, Docker Hub connections fail with "no route to host" on IPv6 addresses.
cat > /etc/docker/daemon.json << 'EOF'
{
  "ipv6": false
}
EOF
systemctl restart docker
