# vmware-fusion (1/3)
## installation 
### MacOS(arm64)
### https://formulae.brew.sh/cask/vmware-fusion
### brew install --cask vmware-fusion
### brew install --cask virtualbox 
### https://github.com/Homebrew/homebrew-cask/blob/master/Casks/v/vmware-fusion.rb
### vmware-fusion v13.5.1
brew install --cask ./vmware-fusion-v13.5.1/vmware-fusion.rb

### vmware plugin 
vagrant plugin install vagrant-vmware-desktop

## configure vmware-fusion 
### copy commands for vmware-fusion 
sudo ./scripts/copy_launchctl-all-vmware-utility.sh 
sudo ./scripts/copy_netstat-anvp.sh

### run launchctl load vmware-utility.plist
source ~/.zshrc 
launchctl-load-vmware-utility

# create vnet2 nic for k8s cluster int 
sudo ./scripts/vf_net_create_vnet2


# vagrant (2/3)
## installation 
### MacOS 
### https://formulae.brew.sh/cask/vagrant
### brew install --cask vagrant
### https://github.com/Homebrew/homebrew-cask/blob/master/Casks/v/vagrant.rb
### vagrant v2.4.1 
brew install --cask ./vagrant-v2.4.1/vagrant.rb


# tabby (3/3)
## installation
### MacOS 
### https://formulae.brew.sh/cask/tabby
### brew install --cask tabby
### https://github.com/Homebrew/homebrew-cask/blob/master/Casks/t/tabby.rb
### tabby v1.0.207
brew install --cask ./tabby-v1.0.207/tabby.rb

## the location of configuration file 
### https://github.com/Eugeny/tabby/wiki/Config-file
### On Windows, %APPDATA%/Tabby
### On macOS: ~/Library/Application Support/tabby
### On Linux: ~/.config/tabby

## Windows 
cp ./tabby-v1.0.207/config.yaml $env:APPDATA/tabby 

## MacOS 
cp ./tabby-v1.0.207/config.yaml ~/Library/Application\ Support/tabby
