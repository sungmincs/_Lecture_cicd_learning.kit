#!/usr/bin/env bash

# make unload command to local machine 
cat <<EOF > /usr/local/bin/launchctl-unload-vmware-utility
sudo launchctl unload -w /Library/LaunchDaemons/com.vagrant.vagrant-vmware-utility.plist
EOF

sudo chmod 744 /usr/local/bin/launchctl-unload-vmware-utility
