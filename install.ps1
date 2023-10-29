$distro = "RHEL9"

# Build "base" RHEL9 UBI image
docker build ./containers -f ./containers/base.Containerfile -t rhelubi9:base

# Build "dev" RHEL9 UBI image
docker build ./containers -f ./containers/dev-base.Containerfile -t rhelubi9:dev-base

# Build "wsl" RHEL9 UBI image
docker build ./containers -f ./containers/wsl.Containerfile -t rhelubi9:wsl

# Remove distro if it already exists
wsl --unregister $distro
rm "$env:USERPROFILE\.wsl\$distro" -r -force

# Create the dirstro folder again
mkdir "$env:USERPROFILE\.wsl\$distro"
cp redhat.png $env:USERPROFILE\.wsl\$distro\

# Create a temporary container and export its filesystem to a tar
$containerid=$(docker create rhelubi9:wsl)
docker export $containerid --output $env:USERPROFILE\.wsl\$distro\rhelubi9-wsl.tar
docker container rm $containerid
Remove-Variable -Name containerid

# Import the tar to a new WSL instance called RHEL9
wsl --import $distro --version 2 "$env:USERPROFILE\.wsl\$distro" $env:USERPROFILE\.wsl\$distro\rhelubi9-wsl.tar

# Update Windows Terminal profile with icon
$terminals = Get-Content $env:LOCALAPPDATA'\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json' -raw | ConvertFrom-Json
$terminals.profiles.list | % {if($_.name -eq $distro){$_.icon="$env:USERPROFILE\.wsl\$distro\redhat.png"}}
$terminals | ConvertTo-Json -depth 32 | set-content $env:LOCALAPPDATA'\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json'

# Fix up Git Windows config file location
if ($env:GIT_CONFIG_GLOBAL -ne "$env:USERPROFILE\.gitconfig")
{
    if ($env:HOMESHARE -ne $env:USERPROFILE)
    {
        Copy-Item -Path $env:HOMESHARE\.gitconfig -Destination $env:USERPROFILE\.gitconfig -Force
    }
    $env:GIT_CONFIG_GLOBAL="$env:USERPROFILE\.gitconfig"
    setx GIT_CONFIG_GLOBAL "$env:USERPROFILE\.gitconfig"
}

# Set USERPROFILE in WSL for use in various configs
$env:WSLENV="WT_SESSION:WT_PROFILE_ID:USERPROFILE/p:"
setx WSLENV "WT_SESSION:WT_PROFILE_ID:USERPROFILE/p:"

# Start distro
wsl -d $distro wsl-user-setup.sh
