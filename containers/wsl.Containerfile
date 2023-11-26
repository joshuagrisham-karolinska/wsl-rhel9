FROM rhelubi9:dev-base

# Enable systemd
RUN crudini --set /etc/wsl.conf boot systemd true

# Set up Git at system level to use Windows Git Credential Manager
RUN git config --system credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe"

# Add and enable wsl-vpnkit service
RUN cp /etc/extras/systemd/wsl-vpnkit.service /etc/systemd/system/ && \
    systemctl enable wsl-vpnkit
