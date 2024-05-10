#!/usr/bin/env bash

# make load command to local machine 
cat <<EOF > /usr/local/bin/launchctl-load-vmware-utility
sudo launchctl load -w /Library/LaunchDaemons/com.vagrant.vagrant-vmware-utility.plist
EOF

sudo chmod 744 /usr/local/bin/launchctl-load-vmware-utility
