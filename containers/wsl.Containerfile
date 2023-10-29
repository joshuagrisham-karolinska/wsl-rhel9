FROM rhelubi9:devbase

ADD scripts/* /usr/local/bin/
RUN chmod +x /usr/local/bin/*

# wsl-vpnkit should always try to be started if it is not already running (in both bash and zsh)
RUN echo "wsl.exe -d wsl-vpnkit --cd /app service wsl-vpnkit start 2>/dev/null" >> /etc/profile && \
    echo "wsl.exe -d wsl-vpnkit --cd /app service wsl-vpnkit start 2>/dev/null" >> /etc/zprofile

# Set up Git at system level to use Windows Git Credential Manager
RUN git config --system credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe"

# Use Windows .gitconfig as system-wide Git global config (in both bash and zsh)
RUN echo "export GIT_CONFIG_GLOBAL=\$USERPROFILE/.gitconfig" >> /etc/profile && \
    echo "export GIT_CONFIG_GLOBAL=\$USERPROFILE/.gitconfig" >> /etc/zprofile
