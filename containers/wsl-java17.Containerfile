FROM rhelubi9:wsl

ARG MAVEN_VERSION=3.9.7
ARG TINKEY_VERSION=1.10.1

RUN dnf update -y \
        && \
    dnf install -y \
        java-17-openjdk-devel \
        && \
    dnf clean all -y

# Install Maven to /opt/apache-maven
ADD https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz /tmp/maven/
RUN tar xzf /tmp/maven/apache-maven-*.tar.gz -C /tmp/maven/ && \
    mv /tmp/maven/apache-maven-${MAVEN_VERSION} /opt/apache-maven && \
    alternatives --install /usr/local/bin/mvn mvn /opt/apache-maven/bin/mvn 1 && \
    rm -rf /tmp/maven

# Install Google Tinkey
ADD https://storage.googleapis.com/tinkey/tinkey-${TINKEY_VERSION}.tar.gz /tmp/tinkey/
RUN tar xzf /tmp/tinkey/tinkey-*.tar.gz -C /tmp/tinkey/ && \
    install -o root -g root -m 0755 /tmp/tinkey/tinkey /usr/local/bin/tinkey && \
    install -o root -g root -m 0755 /tmp/tinkey/tinkey_deploy.jar /usr/local/bin/tinkey_deploy.jar && \
    rm -rf /tmp/tinkey
