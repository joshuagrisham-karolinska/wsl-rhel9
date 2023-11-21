FROM rhelubi9:base

ENV DEV_CONTAINER_ZSH_PROMPT="\"%{\$fg_bold[yellow]%}%n%{\$reset_color%} \$PROMPT\""

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

# Add default .aws/config
ADD /extras/aws.config /etc/skel/.aws/config
# And remove Windows line endings from it in case it has them
RUN sh -c '<<< "$(< /etc/skel/.aws/config)" tr -d "\r" > /etc/skel/.aws/config'
