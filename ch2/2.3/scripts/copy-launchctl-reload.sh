#!/usr/bin/env bash

# make reload command to local machine 
cat <<EOF > /usr/local/bin/launchctl-reload
sudo launchctl unload -w /Library/LaunchDaemons/com.vagrant.vagrant-vmware-utility.plist
sudo launchctl load -w /Library/LaunchDaemons/com.vagrant.vagrant-vmware-utility.plist
EOF

sudo chmod 744 /usr/local/bin/launchctl-reload
