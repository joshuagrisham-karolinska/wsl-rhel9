FROM rhelubi9:wsl

ARG MAVEN_VERSION=3.9.5

RUN dnf update -y \
        && \
    dnf install -y \
        java-17-openjdk-devel \
        && \
    dnf clean all -y

# Add default MAVEN_ARGS to default profile
RUN echo 'MAVEN_ARGS="--settings $MAVEN_SETTINGS"' >> /etc/profile && \
    echo export MAVEN_ARGS >> /etc/profile

# Install Maven
ADD https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz /tmp/maven/
RUN tar xzf /tmp/maven/apache-maven-*.tar.gz -C /tmp/maven/ && \
    mv /tmp/maven/apache-maven-${MAVEN_VERSION} /opt/apache-maven && \
    alternatives --install /usr/local/bin/mvn mvn /opt/apache-maven/bin/mvn 1 && \
    rm -rf /tmp/maven && \
    echo "export MAVEN_HOME=/opt/apache-maven" >> /etc/profile && \
    echo "export M2_HOME=\$MAVEN_HOME" >> /etc/profile && \
    echo "export M2=\$M2_HOME/bin" >> /etc/profile
