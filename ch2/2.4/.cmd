# vmware-fusion (1/3)
## installation 
### MacOS(arm64)
### https://formulae.brew.sh/cask/virtualbox 
### brew install --cask virtualbox 
### https://github.com/Homebrew/homebrew-cask/blob/master/Casks/v/virtualbox.rb
### virtualbox v7.1.10
brew install --cask ./virtualbox-v7.1.10/virtualbox.rb

# vagrant (2/3)
## installation 
### MacOS 
### https://formulae.brew.sh/cask/vagrant
### brew install --cask vagrant
### https://github.com/Homebrew/homebrew-cask/blob/master/Casks/v/vagrant.rb
### vagrant v2.4.7
brew install --cask ./vagrant-v2.4.7/vagrant.rb

### (optional) uninstall vagrant-vmware-desktop
vagrant plugin uninstall vagrant-vmware-desktop


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
cp ./tabby-v1.0.207/config.yaml $env:APPDATA/tabby/ 

## MacOS
cp ./tabby-v1.0.207/config.yaml ~/Library/Application\ Support/tabby/


# K8s 클러스터 구성 (vagrant up)
## Run from the directory containing the Vagrantfile (ch2/2.4/)
cd ~/_Lecture_cicd_learning.kit/ch2/2.4
vagrant up

## Wait for provisioning to complete (~15-20 minutes)
## The following are installed automatically:
## - Kubernetes 1.35.2 (1 control-plane + 3 workers)
## - MetalLB v0.15.3 (LoadBalancer)
## - NGINX Gateway Fabric v2.3.0 (HTTP routing — LB IP: 192.168.1.99)
## - Helm v4.0.4
## - metrics-server v0.8.0
## - NFS StorageClass (default)


# Verify cluster (SSH into control-plane)
sshpass -p "vagrant" ssh root@192.168.1.10

## Check nodes
kubectl get nodes

## Check NGINX Gateway Fabric and MetalLB
kubectl get pods -A | grep -E "nginx-gateway|metallb"

## Check LoadBalancer IP (should show 192.168.1.99 for nginx-gateway-nginx)
kubectl get svc -A | grep LoadBalancer

## Check Gateway object
kubectl get gateway -A
