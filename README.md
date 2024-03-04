# RHEL9 WSL Distribution

This is a sample WSL distribution of Red Hat Universal Base Image 9 with some specific configurations for usage at Karolinska Hospital:

- Adds various Region Stockholm and Inera SITHS certificate authorities to the trust store.
- Installs and configures the following utilities:
  - `terraform`
  - `vault`
  - `helm`
  - `kubectl`
  - `oc` (requires download from Karolinska's test OpenShift cluster)
- Sets up a default developer user (that's you who are using this in your envirnoment!)
- Installs and configures [zsh](https://www.zsh.org/) as the default shell for this default user, plus adds [Oh My Zsh!](https://github.com/ohmyzsh/ohmyzsh) with some extra plugins depending on response to a few prompts.
- Assumes you are running WSL version 2.0.14.0 or later.
- Assumes you are NOT running version 4.27.x of Docker Desktop, because it contains a bug preventing installation. Both earlier versions, as in 4.26.x and below, and later versions from 4.28.x, works well.
- Assumes you have installed v0.4.x+ of [wsl-vpnkit](https://github.com/sakai135/wsl-vpnkit) and configures the RHEL9 WSL distrubtion with a systemd service to keep it running in the background as long as RHEL9 is running (see [Installing](#installing) below).
- Assumes you have installed [Git for Windows](https://git-scm.com/download/win) >= v2.39.0 and that you have set up all of your config as needed with Git for Windows including Git Credential Manager.

## Git Setup

This solution assumes that you will run all environments from one centrally-managed `.gitconfig` in Windows, that will then be referenced and occasionally copied depending on the scenario. Recommended settings for Git in Windows include the following:

- `git config --global user.name "YourGitHubUsername"` (your own actual GitHub username)
- `git config --global user.email "YourGitHubVisibleEmailAddress"` (your "visible" email address per your own [GitHub Email settings](https://github.com/settings/emails))
- `git config --global init.defaultbranch main`
- `git config --global pull.rebase false`
- You have authenticated at least once using `git` from Windows and successfully completed the browser-based authentication flow with GitHub (and thus have your credentials stored in Git Credential Manager).

The path of Git Credential Manager is currently expected to be `C:\Program Files\Git\mingw64\bin\git-credential-manager.exe`, which is the default path for Git for Windows starting with v2.39.0 and higher.

The following scenarios have been tested as working with no other intervention or login required by the user (assuming everything is set up and working in Windows):

- Git CLI from Windows
- Git CLI from this WSL distro (RHEL9)
- VS Code launched from Windows, and opening one of the RHEL9-based "dev" containers from this repository using the [Dev Containers extension](https://code.visualstudio.com/docs/devcontainers/containers) (note this approach is not recommended by Microsoft due to file performance issues).
- VS Code launched from this WSL distro (RHEL9), and again opening one of the RHEL9-based "dev" containers from this repository (this is the recommended approach from Microsoft).

## Installing

1. Fetch, import, and start [wsl-vpnkit](https://github.com/sakai135/wsl-vpnkit) by running the script [install-vpnkit.ps1](./install-vpnkit.ps1).

2. Build and install the "RHEL9" WSL distribution by running one of the following scripts depending on your needs:
-  [install-wsl.ps1](./install-wsl.ps1) (Base WSL image)
-  [install-wsl-java17.ps1](./install-wsl-java17.ps1) (Base + JDK 17 and Maven)

> **NOTE:** This script will wipe and remove any existing distribution with the name "RHEL9" distrubution if you already have one!

## Other Containers

Some other containers are available here, with the idea that they can be used as Dev Containers (for example in GitHub Codespaces or with VS Code), but more testing and configuration may be needed.

Here are some commands you can use to build them:

```powershell
# Build the base image
docker build ./containers -f ./containers/base.Containerfile -t rhelubi9:base
# Build the base dev image
docker build ./containers -f ./containers/dev-base.Containerfile -t rhelubi9:dev-base

# Build Java dev containers
docker build ./containers -f ./containers/dev-java11.Containerfile -t rhelubi9:dev-java11
docker build ./containers -f ./containers/dev-java17.Containerfile -t rhelubi9:dev-java17
```

To use one of these images in VS Code, set the above image tags in the `.devcontainer/devcontainer.json` file, like this for example:

```json
{
	"name": "java11",
	"image": "rhelubi9:dev-java11"
}
```
