FROM rhelubi9:dev-base

# Enable systemd
RUN crudini --set /etc/wsl.conf boot systemd true

# Set up Git at system level to use Windows Git Credential Manager
RUN git config --system credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe"

# Add container scripts
ADD scripts/* /usr/local/bin/
RUN chmod +x /usr/local/bin/*

# Add and enable wsl-vpnkit service
RUN mv /usr/local/bin/wsl-vpnkit.service /etc/systemd/system/ && \
    systemctl enable wsl-vpnkit
