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

read -p "Enter new Linux username: " username

adduser -G wheel $username
crudini --set /etc/wsl.conf user default $username
passwd $username

cd /home/$username

# Set a nice blue and green prompt
echo 'export PS1="\[\e[36m\]\u@\h\[\e[32m\]:\$PWD\[\e[m\]\$ "' >> /home/$username/.bashrc

# Replace user's $HOME/.gitconfig with a link to Windows .gitconfig (since $HOME/.gitconfig will always be copied and used when starting Dev Containers)
runuser -u $username -- rm --force /home/$username/.gitconfig
runuser -u $username -- ln --symbolic $GIT_CONFIG_GLOBAL /home/$username/.gitconfig

# Remove user's Maven $HOME/.m2/settings.xml and create profile script to always copy the Windows file in each session (so it can be mounted to child containers)
if [ -n "${MAVEN_SETTINGS}" ]; then
    runuser -u $username -- rm --force /home/$username/.m2/settings.xml
    runuser -u $username -- mkdir -p /home/$username/.m2
    echo "cp --force \$MAVEN_SETTINGS /home/$username/.m2/settings.xml" >> /home/$username/.zshrc
fi

# Start user's session
echo
echo "Welcome to Linux, $username!"
echo "You have now been set as the default user for this instance."
echo "This will take effect only after the instance has been restarted."
echo
echo "Please note that it might also be necessary to adjust Docker Desktop WSL Integration settings for this instance."
echo "You should also restart Docker Desktop to ensure that Docker integration will work properly."
echo

