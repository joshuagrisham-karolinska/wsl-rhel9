FROM rhelubi9:dev-base

ARG USERNAME=java17

RUN dnf update -y \
        && \
    dnf install -y \
        java-17-openjdk-headless \
        maven \
        && \
    dnf clean all -y

# Add dev username
RUN adduser -G wheel $USERNAME

# Add and configure zsh
RUN curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | runuser -u $USERNAME -- sh -
RUN chsh --shell /bin/zsh $USERNAME
# Add username to zsh prompt
RUN echo >> /home/$USERNAME/.zshrc && echo export PROMPT=$DEV_CONTAINER_ZSH_PROMPT >> /home/$USERNAME/.zshrc

USER $USERNAME
WORKDIR /home/$USERNAME