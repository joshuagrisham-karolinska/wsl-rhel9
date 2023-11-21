FROM rhelubi9:dev-base

# Enable systemd
RUN crudini --set /etc/wsl.conf boot systemd true

# Set up Git at system level to use Windows Git Credential Manager
RUN git config --system credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe"

# Add container extras
ADD extras /etc/extras
# Strip Windows line endings from files just in case they have them
RUN find /etc/extras -type f -exec bash -c '<<< "$(< {})" tr -d "\r" > {}' \;
# Copy extra scripts to /usr/local/bin/
RUN chmod +x /etc/extras/*.sh && cp /etc/extras/*.sh /usr/local/bin/
# Add and enable wsl-vpnkit service
RUN cp /etc/extras/wsl-vpnkit.service /etc/systemd/system/ && \
    systemctl enable wsl-vpnkit
