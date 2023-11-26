$distro = "RHEL9"
$imagetag = $args[0]

if (!($imagetag))
{
    Throw "This script should be executed with a single parameter specifying a specific tag of the rhelubi9 you wish to install as your WSL instance. Please pass it as a parameter to this script or run one of the pre-built install script variants. The script will now exit."
    Exit
}


# Fix up Git Windows config file location
if ($env:GIT_CONFIG_GLOBAL -ne "$env:USERPROFILE\.gitconfig")
{
    if ($env:HOMESHARE -ne $env:USERPROFILE)
    {
        Copy-Item -Path $env:HOMESHARE\.gitconfig -Destination $env:USERPROFILE\.gitconfig -Force
        # If succeeded in copying the file to $env:USERPROFILE\.gitconfig then remove the original one at $env:HOMESHARE\.gitconfig
        if (Test-Path $env:USERPROFILE\.gitconfig)
        {
            Remove-Item -Path $env:HOMESHARE\.gitconfig -Force
        }
    }
    $env:GIT_CONFIG_GLOBAL="$env:USERPROFILE\.gitconfig"
    setx GIT_CONFIG_GLOBAL "$env:USERPROFILE\.gitconfig"
}

if (!(Test-Path $env:USERPROFILE\.gitconfig))
{
    Throw "Could not find .gitconfig at '$env:USERPROFILE\.gitconfig'. The script will now exit."
    Exit
}

# Fix up Maven Windows config file location (if mvn exists)
if (Get-Command "mvn")
{
    if ($env:MAVEN_SETTINGS -ne "$env:USERPROFILE\.m2\settings.xml")
    {
        if (Test-Path $env:USERPROFILE\.m2\settings.xml)
        {
            $env:MAVEN_SETTINGS="$env:USERPROFILE\.m2\settings.xml"
            setx MAVEN_SETTINGS "$env:USERPROFILE\.m2\settings.xml"
            # Configure Maven Windows to always use this settings file
            $env:MAVEN_ARGS="--settings $env:MAVEN_SETTINGS"
            setx MAVEN_ARGS "--settings $env:MAVEN_SETTINGS"
        }
    }
}

# Pass GIT_CONFIG_GLOBAL and MAVEN_SETTINGS to WSL so that Windows config will be used for both (with /p to convert path)
$env:WSLENV="GIT_CONFIG_GLOBAL/p:MAVEN_SETTINGS/p:"
setx WSLENV "GIT_CONFIG_GLOBAL/p:MAVEN_SETTINGS/p:"

# Build "base" RHEL9 UBI image
docker build ./containers -f ./containers/base.Containerfile -t rhelubi9:base

# Build "dev" RHEL9 UBI image
docker build ./containers -f ./containers/dev-base.Containerfile -t rhelubi9:dev-base

# Build "wsl" RHEL9 UBI image
docker build ./containers -f ./containers/wsl.Containerfile -t rhelubi9:wsl

# Build "wsl-java17" RHEL9 UBI image
docker build ./containers -f ./containers/wsl-java17.Containerfile -t rhelubi9:wsl-java17

# Remove distro if it already exists
wsl --unregister $distro
rm "$env:USERPROFILE\.wsl\$distro" -r -force

# Create the dirstro folder again
mkdir "$env:USERPROFILE\.wsl\$distro"
cp redhat.png $env:USERPROFILE\.wsl\$distro\

# Create a temporary container and export its filesystem to a tar
$containerid=$(docker create rhelubi9:$imagetag)
docker export $containerid --output $env:USERPROFILE\.wsl\$distro\rhelubi9-wsl.tar
docker container rm $containerid
Remove-Variable -Name containerid

# Import the tar to a new WSL instance called RHEL9
wsl --import $distro --version 2 "$env:USERPROFILE\.wsl\$distro" $env:USERPROFILE\.wsl\$distro\rhelubi9-wsl.tar

# Update Windows Terminal profile with icon
$terminals = Get-Content $env:LOCALAPPDATA'\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json' -raw | ConvertFrom-Json
$terminals.profiles.list | % {if($_.name -eq $distro){$_.icon="$env:USERPROFILE\.wsl\$distro\redhat.png"}}
$terminals | ConvertTo-Json -depth 32 | set-content $env:LOCALAPPDATA'\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json'

# Set distro as the new WSL Default
wsl --set-default $distro

# Start distro with default user setup script
wsl --distribution $distro /etc/extras/wsl-user-setup.sh

# Shutdown entire WSL to help avoid issues with wsl-vpnkit failing to start the first time with the error:
#  "cannot create tap device: ioctl: device or resource busy"
Write-Host "Please note that it might be necessary to adjust Docker Desktop WSL Integration settings for this distribution."
Write-Host "You may also need to restart Docker Desktop to ensure that Docker integration will work properly."
Write-Host
Write-Host 'If you see further "cannot create tap device: ioctl: device or resource busy" errors from wsl-vpnkit then it can'
Write-Host 'be helpful to restart WSL or even your entire Windows environment.'
Write-Host
Write-Host "Shutting down all WSL distributions..."
wsl --shutdown
Write-Host "Starting $distro..."
wsl --distribution $distro
