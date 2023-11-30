# Custom Zsh prompt theme
# Adapted from https://github.com/microsoft/vscode-dev-containers/blob/main/script-library/common-redhat.sh

__zsh_prompt() {

    # White arrow if previous command succeeded, otherwise red
    local exitpart="%(?:%{$reset_color%}➜ :%{$fg_bold[red]%}➜ )"

    # Username should be different colors depending on type of user
    # Also set final prompt char to $ for most users but # for root
    local userpart
    local promptpart
    # set default promptpart but override later if root
    promptpart="%{$fg[gray]%}$%{$reset_color%} "
    if [ ! -z "${GITHUB_USER}" ]; then # Github Codespace user should be green
        userpart="%{$fg[green]%}@${GITHUB_USER} "
    elif [ "${USER}" = "root" ]; then # root should be red
        userpart="%{$fg_bold[red]%}%n "
        promptpart="%{$fg[gray]%}#%{$reset_color%} "
    elif [ -z "${WSLENV}" ]; then # If this is not from WSL (WSLENV is not set) then yellow (assume dev container)
        userpart="%{$fg_bold[yellow]%}%n "
    else # Normal user that should be using WSL should be green
        userpart="%{$fg[green]%}%n "
    fi

    # Current path is blue
    local pathpart="%{$fg_bold[blue]%}%(5~|%-1~/…/%3~|%4~)%{$reset_color%}"

    # Git info (formatted using ZSH_THEME_GIT_PROMPT variables below)
    local gitpart='$([ "$(git config --get codespaces-theme.hide-status 2>/dev/null)" != 1 ] && git_prompt_info)'

    # Final PROMPT should be all parts together
    PROMPT="${userpart}${exitpart}${pathpart}${gitpart}${promptpart}"

}

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg_bold[cyan]%}git:(%{$fg_bold[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg_bold[yellow]%}✗%{$fg_bold[cyan]%})"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[cyan]%})"

__zsh_prompt
unset -f __zsh_prompt
