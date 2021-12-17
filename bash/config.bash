#!/usr/bin/bash

# CONFIG
shopt -s extglob cdable_vars globstar
export PATH="$PATH:/home/rheslin/.local/bin:/usr/bin:/opt/zotero:/usr/local/bin"
export EDITOR="nvim"
export INPUTRC=$HOME/.inputrc
export R_SNIPPETS_PATH="/c/Users/rheslin/AppData/Roaming/RStudio/snippets/"
export R_KEYRING_BACKEND="secret_service"
export PYTHONIOENCODING=UTF-8
export WEBDRIVER="C:\Users\heslinr1\geckodriver\geckodriver.exe"
export VM_NAME="Ubuntu"
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
set -a
#export AOC_COOKIE="session=53616c7465645f5fc3d443e0f30952d8d52fa202dfceb2daf7b7d58825e056bc912592cb68a4e5e2ca3620701e5dd05d"
#Concealed for security
[ -e "$HOME/AoC_cookie.env" ] && . "$HOME/AoC_cookie.env" || echo 'You should totally do Advent of Code!'
set +a
#export FZF_CTRL_T_COMMAND="FZF_DEFAULT_COMMAND"
#export FZF_ALT_C_COMMAND="fdfind -t d . $HOME"

# Suggested by https://askubuntu.com/questions/33440/tab-completion-doesnt-work-for-commands
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
# Customize prompt
if [ $OSTYPE == "linux-gnu" ]; then
    PS1="\$(new_line_ps1)\[\033[1;34m\]UbuntuVM\[\033[0;15m\]|\[\033[0;31m\]\w\[\033[0;33m\]\$(parse_git_branch)\[\033[1;15m\]> \[\033[0m\]"
else
  PS1="\[\033[1;34m\]rheslin\[\033[0;15m\]|\[\033[0;31m\]\w\[\033[0;33m\]$(__git_ps1 " (%s)")\[\033[1;15m\]> \[\033[0m\]"
fi
