FROM rhelubi9:base

RUN dnf update -y \
        && \
    dnf install -y \
        passwd \
        sudo \
        man \
        util-linux-user \
        iputils \
        openldap-clients \
        git \
        wget \
        unzip \
        zsh \
        nano \
        crudini \
        podman \
        jq \
        && \
    dnf clean all -y

# Install kubectl
ADD https://dl.k8s.io/release/v1.28.3/bin/linux/amd64/kubectl /tmp/
RUN install -o root -g root -m 0755 /tmp/kubectl /usr/local/bin/kubectl && \
    rm -f /tmp/kubectl

# Install kind
ADD https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64 /tmp/kind
RUN install -o root -g root -m 0755 /tmp/kind /usr/local/bin/kind && \
    rm -f /tmp/kind

# Install oc
ADD https://downloads-openshift-console.apps.tamarin.mta.karolinska.se/amd64/linux/oc.tar /tmp/
RUN tar xf /tmp/oc.tar -C /tmp/ && \
    install -o root -g root -m 0755 /tmp/oc /usr/local/bin/oc && \
    rm -f /tmp/oc*

# Install helm
ADD https://get.helm.sh/helm-v3.13.1-linux-amd64.tar.gz /tmp/helm/
RUN tar xzf /tmp/helm/helm*.tar.gz -C /tmp/helm/ && \
    cp /tmp/helm/linux-amd64/helm /usr/local/bin/helm && \
    rm -rf /tmp/helm

# Install HashiCorp stuff
RUN dnf config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo && \
    dnf -y install terraform vault

# Install awscli
ADD https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip /tmp/awscli/
RUN unzip /tmp/awscli/awscli-exe-linux-x86_64.zip -d /tmp/awscli/ && \
    /tmp/awscli/aws/install && \
    rm -rf /tmp/awscli

# Add container extras
ADD extras /etc/extras
# Strip Windows line endings from files just in case they have them
RUN find /etc/extras -type f -exec bash -c '<<< "$(< {})" tr -d "\r" > {}' \;
# Ensure extra scripts can be executed
RUN chmod +x /etc/extras/*.sh
# Add default user profile config files (directly using /bin/cp to avoid problems with "cp -i" alias)
RUN /bin/cp -rfT /etc/extras/skel /etc/skel
# Add profile scripts (again using /bin/cp to force without prompt)
RUN /bin/cp -rfT /etc/extras/profile.d /etc/profile.d
