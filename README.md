# RHEL9 WSL Distribution

This is a sample WSL distribution of Red Hat Universal Base Image 9 with some specific configurations for usage at Karolinska Hospital:

- Adds various Region Stockholm and Inera SITHS certificate authorities to the trust store.
- Installs and configures the following utilities:
  - helm
  - kubectl
  - oc
  - terraform
  - vault
- Sets up a default developer user (that's you who are using this in your envirnoment!)
- Installs and configures [zsh](https://www.zsh.org/) as the default shell for the default users, plus adds [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh) with the default theme.
- Configures Git with the following defaults:
  - `pull.rebase` is set to `false`
  - default branch name for new repositories will be `main` instead of `master`
  - `credential.helper` is added with the expectation that the Git For Windows Credential Manager is used and has a path of `C:\Program Files\Git\mingw64\bin\git-credential-manager.exe`
- Assumes you have installed v0.3.X (v0.4.X is not currently compatible) of [wsl-vpnkit](https://github.com/sakai135/wsl-vpnkit) and subsequently configures it to be executed automatically when you open a new session of the RHEL9 WSL distrubtion.

## Installing

Fetch, import, and start [wsl-vpnkit](https://github.com/sakai135/wsl-vpnkit) by running the script [install-vpnkit.ps1](./install-vpnkit.ps1).

Build and install the "RHEL9" WSL distribution by running the script [install.ps1](./install.ps1).

> **NOTE:** This script will wipe and remove any existing distribution with the name "RHEL9" distrubution if you already have one!

## Other Containers

Some other containers are available here, with the idea that they can be used as Dev Containers but more testing and configuration may be needed.

Here are some commands you can use to build them:

```powershell
# Build the base image
docker build ./containers -f ./containers/base.Containerfile -t rhelubi9:base
# Build the base dev image
docker build ./containers -f ./containers/dev-base.Containerfile -t rhelubi9:dev-base

# Java dev containers
docker build ./containers -f ./containers/dev-java11.Containerfile -t rhelubi9:dev-java11
docker build ./containers -f ./containers/dev-java17.Containerfile -t rhelubi9:dev-java17
```

To use one of these images in VS Code, set the above image tags in the `.devcontainer/devcontainer.json` file, like this as an example:

```json
{
	"name": "Java11",
	"image": "rhelubi9:dev-java11"
}
```
