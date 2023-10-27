#!/bin/bash

# This script is used as initial user setup for the default WSL user
# It should be executed automatically the first time a new WSL instance is created with 
# this image, and then will never be need to used after that in the same instace.

# In rare cases it should not cause any major harm to execute the script again if you wish
# to switch the default user account of an existing instance.

set -e

echo "Please create a default Linux user account. The username does not need to match your Windows username."
echo "For mor information visit: https://aka.ms/wslusers"
echo

read -p "Enter new Linux username: " username

adduser -G wheel $username
crudini --set /etc/wsl.conf user default $username

passwd $username

# Assume that we should now restore the original root bashrc so this script will not be executed again
yes | cp /root/.bashrc.bak /root/.bashrc

# Setup for user

cd /home/$username

# Let wsl-vpnkit always try to be started if it is not already running
echo >> ~/.bashrc
echo "# Let wsl-vpnkit always try to be started if it is not already running" >> ~/.bashrc
echo "wsl.exe -d wsl-vpnkit --cd /app service wsl-vpnkit start 2>/dev/null" >> ~/.bashrc

# Set up git to use Windows Git Credential Manager
runuser -u $username -- git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe"

# Download and execute "oh my zsh" to set up zsh
curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | runuser -u $username -- sh -
# Change user's default shell to zsh
chsh --shell /bin/zsh $username

# Start user's session
echo "Welcome to Linux, $username!"
su $username
