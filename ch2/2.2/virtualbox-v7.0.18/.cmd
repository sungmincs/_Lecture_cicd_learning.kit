# installation 
## Windows 
## https://winget.run/pkg/Oracle/VirtualBox
## winget install -e --id Oracle.VirtualBox
winget install -e --id Oracle.VirtualBox -v 7.0.18

## MacOS 
## https://formulae.brew.sh/cask/tabby
## brew install --cask tabby
## https://raw.githubusercontent.com/Homebrew/homebrew-cask/master/Casks/v/virtualbox.rb
## https://github.com/Homebrew/homebrew-cask/blob/228d2472e2e5a321772e3d7f75045171d26adf57/Casks/v/virtualbox.rb
## virtualbox v7.0.18
brew install --cask virtualbox.rb

#the location of configuration file 
# https://github.com/Eugeny/tabby/wiki/Config-file
## On Windows, %APPDATA%/Tabby
## On macOS: ~/Library/Application Support/tabby
## On Linux: ~/.config/tabby

# Windows 
cp config.yaml $env:APPDATA/tabby 

# MacOS 
cp config.yaml ~/Library/Application\ Support/tabby
