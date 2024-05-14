#!/usr/bin/env bash

# check open port due to avoid duplicated port 
cat <<EOF > /usr/local/bin/netstat-anvp
netstat -anvp tcp | awk 'NR<3 || /LISTEN/'
EOF

sudo chmod 777 /usr/local/bin/netstat-anvp
