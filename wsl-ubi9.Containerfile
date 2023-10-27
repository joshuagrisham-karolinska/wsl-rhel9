FROM ubi9:base

# Install Helm
ADD https://get.helm.sh/helm-v3.13.1-linux-amd64.tar.gz /tmp/helm/
RUN tar xzf /tmp/helm/helm*.tar.gz -C /tmp/helm/ && \
    cp /tmp/helm/linux-amd64/helm /usr/local/bin/helm && \
    rm -rf /tmp/helm

# Install HashiCorp utilities
RUN dnf config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo && \
    dnf -y install terraform vault

ADD scripts/* /usr/local/bin/
RUN chmod +x /usr/local/bin/*
RUN cp /root/.bashrc /root/.bashrc.bak
RUN echo "# Initial WSL default user setup script" >> /root/.bashrc
RUN echo ". /usr/local/bin/wsl-user-setup.sh" >> /root/.bashrc
