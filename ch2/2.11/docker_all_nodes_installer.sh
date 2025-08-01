#!/usr/bin/env bash

NODE_COUNT=3

echo "[Step 1/3] Install necessary packages"
apt-get install sshpass -y > /dev/null 2>&1

echo "[Step 2/3] Install docker to all nodes"
for (( i=1; i<=$NODE_COUNT; i++ )); do
  TARGET="192.168.1.10$i"
  echo "working on $TARGET"
    sshpass -p vagrant scp -o StrictHostKeyChecking=no -q ../../ch3/3.2/install_docker.sh root@$TARGET:/tmp
    sshpass -p vagrant ssh root@$TARGET bash /tmp/install_docker.sh > /dev/null 2>&1
   sshpass -p vagrant ssh root@$TARGET chmod 666 /var/run/docker.sock 2>&1
done

echo "[Step 3/3] Successfully completed"
