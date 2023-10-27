# RHEL9 WSL Distribution

> **NOTE:** The following commands should be executed with Powershell

Fetch, import, and start [wsl-vpnkit](https://github.com/sakai135/wsl-vpnkit)

```powershell
wsl --unregister wsl-vpnkit
mkdir "$env:USERPROFILE\.wsl\wsl-vpnkit"
# TODO: update to 4.x+ requires changing to systemd with WSL
wget https://github.com/sakai135/wsl-vpnkit/releases/download/v0.3.8/wsl-vpnkit.tar.gz -OutFile $env:USERPROFILE\.wsl\wsl-vpnkit.tar.gz
wsl --import wsl-vpnkit --version 2 $env:USERPROFILE\.wsl\wsl-vpnkit $env:USERPROFILE\.wsl\wsl-vpnkit.tar.gz
wsl -d wsl-vpnkit --cd /app service wsl-vpnkit start
```

Build "ubi9" base image:

```powershell
docker build . -f ubi9.Containerfile -t ubi9:base
```

Build and import "wsl-ubi9" as "RHEL9"

```powershell
wsl --unregister RHEL9
mkdir "$env:USERPROFILE\.wsl\RHEL9"
cp redhat.png $env:USERPROFILE\.wsl\RHEL9\
docker build . -f wsl-ubi9.Containerfile -t wsl-ubi9:base
$env:WSLUBI9_CONTAINERID=$(docker create wsl-ubi9:base)
docker export $env:WSLUBI9_CONTAINERID --output $env:USERPROFILE\.wsl\RHEL9\wsl-ubi9.tar
docker container rm $env:WSLUBI9_CONTAINERID
wsl --import RHEL9 --version 2 "$env:USERPROFILE\.wsl\RHEL9" $env:USERPROFILE\.wsl\RHEL9\wsl-ubi9.tar
wsl -d RHEL9
```

Bonus if you want to set `redhat.png` as the Icon for Windows Terminal!
