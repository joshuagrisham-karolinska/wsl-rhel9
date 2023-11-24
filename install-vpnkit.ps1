# Remove wsl-vpnkit if it already exists
wsl --unregister wsl-vpnkit
rm "$env:USERPROFILE\.wsl\wsl-vpnkit" -r -force

# Create a new folder for wsl-vpnkit and download the image to it
mkdir "$env:USERPROFILE\.wsl\wsl-vpnkit"
wget https://github.com/sakai135/wsl-vpnkit/releases/download/v0.4.1/wsl-vpnkit.tar.gz -OutFile $env:USERPROFILE\.wsl\wsl-vpnkit\wsl-vpnkit.tar.gz

# Import the tar to a new WSL instance called wsl-vpnkit
wsl --import wsl-vpnkit --version 2 $env:USERPROFILE\.wsl\wsl-vpnkit $env:USERPROFILE\.wsl\wsl-vpnkit\wsl-vpnkit.tar.gz

# enable [automount] in wsl.conf for wsl-vpnkit distro and kill it so that it will restart correctly
wsl --distribution wsl-vpnkit --cd /app sed -i '/^\[automount\]$/,/^\[/ s/^enabled[ ]\{0,\}=.*/enabled=true/' /etc/wsl.conf
wsl --terminate wsl-vpnkit

# copy wsl-gvproxy.exe to C:\git (otherwise it will be blocked by AppLocker)
mkdir "C:\git\wsl-vpnkit"
wsl --distribution wsl-vpnkit cp /app/wsl-gvproxy.exe /mnt/c/git/wsl-vpnkit/
