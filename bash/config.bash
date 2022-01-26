#!/usr/bin/bash

# CONFIG
shopt -s extglob cdable_vars globstar
eval "$(dircolors -b)"

export PATH="$PATH:/home/$USER/.local/bin:/usr/bin:/opt/zotero:/usr/local/bin:$HOME/.local/bin/lua-language-server/bin"
export EDITOR="nvim"
export INPUTRC="$HOME/.inputrc"
export R_KEYRING_BACKEND="secret_service"
export PYTHONIOENCODING=UTF-8
export VM_NAME="Ubuntu"

export R_USER_LIBRARY="$HOME/R/x86_64-pc-linux-gnu-library/4.1/"
export FZF_DEFAULT_OPTS="-m --cycle --height 70% --reverse --border --tabstop=4 --ansi --preview 'file {} && [ -f {} ] && bat {} --color=always --style=numbers --line-range :500' --preview-window=right:50%:wrap --color 'fg:#bbccdd,fg+:#ddeeff,bg:#334455,preview-bg:#223344,border:#778899'"
export VIM_SESSION_DIR="$HOME/.vim/sessions"
export FZF_DEFAULT_COMMAND="fdfind . $HOME --follow --exclude .git"
#From bat repo - use bat as man pager
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export BATPAGER="less -RF"
export VISUAL="/usr/local/bin/nvim"
export CDPATH=":~/.config/nvim"
# For R cli package
export DOWNLOAD_STATIC_LIBV8=1
export ZoteroSQLpath="$HOME/Zotero/zotero.sqlite"
export HISTCONTROL='ignorespace'
set -a
#Concealed for security
[ -e "$HOME/AoC_cookie.env" ] && . "$HOME/AoC_cookie.env" || echo 'You should totally do Advent of Code!'
set +a
#export FZF_CTRL_T_COMMAND="FZF_DEFAULT_COMMAND"
#export FZF_ALT_C_COMMAND="fdfind -t d . $HOME"

# Suggested by https://askubuntu.com/questions/33440/tab-completion-doesnt-work-for-commands
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Caps lock remap
[ -f "$HOME/sh_utils/remap_caps.sh" ] && . "$HOME/sh_utils/remap_caps.sh"
# Customize prompt
if [ $OSTYPE == "linux-gnu" ]; then
    PS1="\$(new_line_ps1)\[\033[1;34m\]Ubuntu\[\033[0;15m\]|\[\033[0;31m\]\w\[\033[0;33m\]\$(parse_git_branch)\[\033[1;15m\]> \[\033[0m\]"
else
    PS1="\[\033[1;34m\]$USER\[\033[0;15m\]|\[\033[0;31m\]\w\[\033[0;33m\]$(__git_ps1 " (%s)")\[\033[1;15m\]> \[\033[0m\]"
fi
