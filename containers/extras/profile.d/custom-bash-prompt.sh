# Custom Bash prompt
# Adapted from https://github.com/microsoft/vscode-dev-containers/blob/main/script-library/common-redhat.sh

__bash_prompt() {
    if [ -z "${USER}" ]; then export USER=$(whoami); fi

    # White arrow if previous command succeeded, otherwise red
    local exitpart='`export XIT=$? \
        && [ "$XIT" -ne "0" ] && echo -n "\[\033[01;31m\]➜\[\033[0m\] " || echo -n "\[\033[0m\]➜ "`'

    # Username should be different colors depending on type of user
    # Also set final prompt char to $ for most users but # for root
    local userpart
    local promptpart
    # set default promptpart but override later if root
    promptpart="\[\033[37m\]\$\[\033[0m\] "
    if [ ! -z "${GITHUB_USER}" ]; then # Github Codespace user should be green
        userpart="\[\033[00;32m\]@${GITHUB_USER}\[\033[0m\] "
    elif [ "${USER}" = "root" ]; then # root should be red
        userpart="\[\033[01;31m\]\u\[\033[0m\] "
        promptpart="\[\033[37m\]#\[\033[0m\] "
    elif [ -z "${WSLENV}" ]; then # If this is not from WSL (WSLENV is not set) then yellow (assume dev container)
        userpart="\[\033[01;33m\]\u\[\033[0m\] "
    else # Normal user that should be using WSL should be green
        userpart="\[\033[00;32m\]\u\[\033[0m\] "
    fi

    # Current path is blue
    local pathpart="\[\033[01;34m\]\w\[\033[0m\]"

    # Git info given as text "git:($BRANCH)" with optional X if working tree is not clean
    local gitpart='`\
        if [ "$(git config --get codespaces-theme.hide-status 2>/dev/null)" != 1 ]; then \
            export BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null); \
            if [ "${BRANCH}" != "" ]; then \
                echo -n " \[\033[01;36m\]git:(\[\033[01;31m\]${BRANCH}\[\033[0m\]" \
                && if git ls-files --error-unmatch -m --directory --no-empty-directory -o --exclude-standard ":/*" > /dev/null 2>&1; then \
                        echo -n " \[\033[01;33m\]✗\[\033[0m\]"; \
                fi \
                && echo -n "\[\033[01;36m\])\[\033[0m\]"; \
            fi; \
        fi`'

    # Final PS1 should be all parts together
    PS1="${userpart}${exitpart}${pathpart}${gitpart}${promptpart}"
}

if [ -n "${BASH_VERSION-}" ]; then
    __bash_prompt
fi

unset -f __bash_prompt
