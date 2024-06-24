#!/usr/bin/env bash

# Docker version 
docker_V='5:26.1.3-1~ubuntu.22.04~jammy' 

# install & enable docker 
apt-get update 
apt-get install docker-ce=$docker_V docker-ce-cli=$docker_V -y 