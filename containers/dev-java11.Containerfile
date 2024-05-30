FROM rhelubi9:dev-base

ARG USERNAME=java11
ARG MAVEN_VERSION=3.9.7

RUN dnf update -y \
        && \
    dnf install -y \
        java-11-openjdk-headless \
        && \
    dnf clean all -y

# Install Maven to /opt/apache-maven
ADD https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz /tmp/maven/
RUN tar xzf /tmp/maven/apache-maven-*.tar.gz -C /tmp/maven/ && \
    mv /tmp/maven/apache-maven-${MAVEN_VERSION} /opt/apache-maven && \
    alternatives --install /usr/local/bin/mvn mvn /opt/apache-maven/bin/mvn 1 && \
    rm -rf /tmp/maven

# Add dev username
RUN adduser -G wheel $USERNAME

USER $USERNAME
WORKDIR /home/$USERNAME
