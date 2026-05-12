#!/usr/bin/env bash

# control plane(local)에서 root로 실행. cp + 워커 노드 3대에 docker 설치.

NODE_COUNT=3

echo "[Step 1/3] Install necessary packages"
apt-get install sshpass -y > /dev/null 2>&1

echo "[Step 2/3] Install docker to control plane (local) and worker nodes"

# Control plane (local)
echo "working on cp (192.168.1.10, local)"
bash ./install_docker.sh > /dev/null 2>&1

# Worker nodes via sshpass
for (( i=1; i<=$NODE_COUNT; i++ )); do
  TARGET="192.168.1.10$i"
  echo "working on w$i ($TARGET)"
  sshpass -p vagrant scp -o StrictHostKeyChecking=no -q ./install_docker.sh root@$TARGET:/tmp
  sshpass -p vagrant ssh root@$TARGET bash /tmp/install_docker.sh > /dev/null 2>&1
done

echo "[Step 3/3] Successfully completed"
