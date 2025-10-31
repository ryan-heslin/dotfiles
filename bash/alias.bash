#!/usr/bin/bash
if [ -f "/usr/bin/batcat" ]; then
  alias bat="/usr/bin/batcat"
fi
# Git aliases
alias gs="git status"
alias ga="git add -A"
alias gc="git commit -m"
alias gp="git push"
alias gr="git reflog"
alias gt="git log --all --graph --decorate"
alias mv="mv -i"
alias fd="fdfind"
alias bp="source $HOME/.bash_profile"
alias py="python3"
# ls variant
alias lf="ls -lAtx --color | egrep -v '^d'"
alias ls="ls -Atx --color --file-type -w 100"
alias tree="tree -C"
# VM management
alias VB="VBoxManage"
alias vmon='VBoxManage startvm "$VM_NAME"'
alias vmoff='VBoxManage controlvm "$VM_NAME" poweroff'
alias vmreset='VBoxManage controlvm "$VM_NAME" reset'
alias redo='sudo $(history -p \!\!)'
alias luamake="$HOME/lua-language-server/3rd/luamake/luamake"
alias kitty="env LIBGL_ALWAYS_SOFTWARE=1 $HOME/.local/kitty.app/bin/kitty "
alias nvim="$HOME/Downloads/nvim-linux-x86_64.appimage"

# From https://stackoverflow.com/questions/66382994/how-to-start-fzf-from-another-directory-the-the-current-working-directory
# restore fzf default options ('fzf clear')
alias fzfcl="export FZF_DEFAULT_COMMAND='fd .'"

# reinstate fzf custom options ('fzf-' as in 'cd -' as in 'back to where I was')
alias fzf-="export FZF_DEFAULT_COMMAND='fd . $HOME'"
