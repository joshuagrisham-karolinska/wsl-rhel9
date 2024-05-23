FROM rhelubi9:dev-base
ARG GIT_CREDENTIAL_MANAGER_PATH="/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe"

# Enable systemd
RUN crudini --set /etc/wsl.conf boot systemd true

# Set up Git at system level to use Windows Git Credential Manager
RUN git config --system credential.helper "$GIT_CREDENTIAL_MANAGER_PATH"

# Add and enable wsl-vpnkit service
RUN cp /etc/extras/systemd/wsl-vpnkit.service /etc/systemd/system/ && \
    systemctl enable wsl-vpnkit
