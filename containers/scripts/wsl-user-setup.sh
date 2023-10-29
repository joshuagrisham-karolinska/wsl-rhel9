#!/bin/bash

# This script is used as initial user setup for the default WSL user
# It should be executed automatically the first time a new WSL instance is created with 
# this image, and then will never be need to used after that in the same instace.

# In rare cases it should not cause any major harm to execute the script again if you wish
# to switch the default user account of an existing instance.

set -e

echo
echo "Please create a default Linux user account. The username does not need to match your Windows username."
echo "For mor information visit: https://aka.ms/wslusers"
echo

read -p "Enter new Linux username: " username

adduser -G wheel $username
crudini --set /etc/wsl.conf user default $username
passwd $username

cd /home/$username

# Download and execute "oh my zsh" to set up zsh
curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | runuser -u $username -- sh -
# Change user's default shell to zsh
chsh --shell /bin/zsh $username
# Add username to zsh prompt
echo >> /home/$username/.zshrc
echo export PROMPT=\"\%\{\$fg\[cyan\]\%\}\%n\%\{\$reset_color\%\} \$PROMPT\" >> /home/$username/.zshrc

# Let wsl-vpnkit always try to be started if it is not already running
echo >> ~/.bashrc
echo "# Let wsl-vpnkit always try to be started if it is not already running" >> ~/.bashrc
echo "wsl.exe -d wsl-vpnkit --cd /app service wsl-vpnkit start 2>/dev/null" >> ~/.bashrc
echo >> ~/.zshrc
echo "# Let wsl-vpnkit always try to be started if it is not already running" >> ~/.zshrc
echo "wsl.exe -d wsl-vpnkit --cd /app service wsl-vpnkit start 2>/dev/null" >> ~/.zshrc

# Set up Git defaults
runuser -u $username -- git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe"
# Use Windows .gitconfig as default for entire WSL instance (both with bash and zsh)
export GIT_CONFIG_SYSTEM=$USERPROFILE/.gitconfig
echo "export GIT_CONFIG_SYSTEM=$USERPROFILE/.gitconfig" >> /etc/profile
echo "export GIT_CONFIG_SYSTEM=$USERPROFILE/.gitconfig" >> /etc/zprofile

# Start user's session
echo "Welcome to Linux, $username!"
su $username
