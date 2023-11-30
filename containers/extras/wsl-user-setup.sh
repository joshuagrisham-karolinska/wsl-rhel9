#!/bin/bash

# This script is used as initial user setup for the default WSL user
# It should be executed automatically the first time a new WSL instance is created with 
# this image, and then will never be need to used after that in the same instace.

# In rare cases it should not cause any major harm to execute the script again if you wish
# to switch the default user account of an existing instance.

set -e

echo
echo "Please create a default Linux user account. The username does not need to match your Windows username."
echo "For more information visit: https://aka.ms/wslusers"
echo

echo -ne "Enter new Linux username: \033[01;33m"
read username
echo -ne "\033[0m"

adduser -G wheel $username
crudini --set /etc/wsl.conf user default $username
passwd $username

cd /home/$username

# Replace user's $HOME/.gitconfig with a link to Windows .gitconfig (since $HOME/.gitconfig will always be copied and used when starting Dev Containers)
runuser -u $username -- rm --force /home/$username/.gitconfig
runuser -u $username -- ln --symbolic $GIT_CONFIG_GLOBAL /home/$username/.gitconfig

# Remove user's existing Maven $HOME/.m2/settings.xml (it should later be handled by /etc/profile.d/maven.sh)
if [ -n "${MAVEN_SETTINGS}" ]; then
    runuser -u $username -- rm --force /home/$username/.m2/settings.xml
fi

# Set up Zsh based on user response to prompt
read -p "Use Zsh with Oh My Zsh! as your interactive shell? [Y/n]: " use_zsh
case $use_zsh in
        [Nn]* )
          echo "Skipping Zsh setup."
          ;;
        * )
          # Run Zsh setup script as user
          sudo --login --user=$username /etc/extras/zsh-setup.sh
          # Change user's default shell to zsh
          chsh --shell /bin/zsh $username
          ;;
esac

# Start user's session
echo
echo -e "Welcome to Linux, \033[01;33m${username}\033[0m!"
echo "You have now been set as the default user for this instance."
echo "This will take effect only after the instance has been restarted."
echo
