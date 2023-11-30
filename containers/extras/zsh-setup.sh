#!/bin/bash

# Zsh Custom Setup script
# Fetches and installs Oh My Zsh!, applies a custom theme, and adds a selection of extra plugins if desired
# Note: Downloading extra plugins requires a working git client

set -e

read -p "Download and install extra plugins? (requires git) [Y/n]: " should_git_extras
case $should_git_extras in
        [Nn]* )
          WITHEXTRAPLUGINS=0
          ;;
        * )
          WITHEXTRAPLUGINS=1
          ;;
esac

if [ -z "${USER}" ]; then export USER=$(whoami); fi
if [ -z "${HOME}" ]; then export HOME="/home/$USER"; fi
export ZSH="$HOME/.oh-my-zsh"

# Download and execute Oh My Zsh! to set up zsh themes
curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh -

# Back up Oh My Zsh!'s .zshrc
mv $HOME/.zshrc $HOME/.zshrc-oh-my-zsh

# Add custom Oh My Zsh! theme
cp /etc/extras/custom.zsh-theme $ZSH/custom/themes/custom.zsh-theme

# Build first part of user's new .zshrc
cat <<EOF > $HOME/.zshrc
# Use custom Oh My Zsh! theme and selected default plugins

export ZSH="\$HOME/.oh-my-zsh"

ZSH_THEME="custom"

EOF

# Install extra plugins if requested and add them to .zshrc
if [ "${WITHEXTRAPLUGINS}" = "1" ]; then

    echo
    echo "Adding custom Oh My Zsh! plugins."
    git clone https://github.com/zsh-users/zsh-autosuggestions.git               $ZSH/custom/plugins/zsh-autosuggestions
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git  $ZSH/custom/plugins/fast-syntax-highlighting
    git clone https://github.com/marlonrichert/zsh-autocomplete.git              $ZSH/custom/plugins/zsh-autocomplete
    echo "Finished adding Oh My Zsh! plugins."
    echo

    # Add these plugins to user's .zshrc
    cat <<EOF >> $HOME/.zshrc

plugins=(
  zsh-autocomplete
  zsh-autosuggestions
  fast-syntax-highlighting
  git
  docker
  helm
  kubectl
  oc
)
EOF

else
    # Add standard plugins by default anyway
    cat <<EOF >> $HOME/.zshrc

plugins=(
  git
  docker
  helm
  kubectl
  oc
)
EOF
fi

# Complete user's .zshrc
cat <<EOF >> $HOME/.zshrc

source \$ZSH/oh-my-zsh.sh
EOF
