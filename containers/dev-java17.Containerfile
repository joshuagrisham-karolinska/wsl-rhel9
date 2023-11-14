FROM rhelubi9:dev-base

ARG USERNAME=java17
ARG MAVEN_VERSION=3.9.5

RUN dnf update -y \
        && \
    dnf install -y \
        java-17-openjdk-headless \
        && \
    dnf clean all -y

# Install Maven
ADD https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz /tmp/maven/
RUN tar xzf /tmp/maven/apache-maven-*.tar.gz -C /tmp/maven/ && \
    mv /tmp/maven/apache-maven-${MAVEN_VERSION} /opt/apache-maven && \
    alternatives --install /usr/local/bin/mvn mvn /opt/apache-maven/bin/mvn 1 && \
    rm -rf /tmp/maven && \
    echo "export MAVEN_HOME=/opt/apache-maven" >> /etc/profile && \
    echo "export M2_HOME=\$MAVEN_HOME" >> /etc/profile && \
    echo "export M2=\$M2_HOME/bin" >> /etc/profile

# Add dev username
RUN adduser -G wheel $USERNAME

# Add and configure zsh
RUN curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | runuser -u $USERNAME -- sh -
RUN chsh --shell /bin/zsh $USERNAME
# Add username to zsh prompt
RUN echo >> /home/$USERNAME/.zshrc && echo export PROMPT=$DEV_CONTAINER_ZSH_PROMPT >> /home/$USERNAME/.zshrc

USER $USERNAME
WORKDIR /home/$USERNAME
