#!/usr/bin/bash

# Trick from a StackOverflow post I forget to get the path to the current file
DOTFILES_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# From https://github.com/ajmalsiddiqui/dotfiles/blob/master/bootstrap.exclude.sh
# Array of dotfiles and symlink targets; create any links no already created
declare -A link_pairs
link_pairs+=(["$DOTFILES_PATH/bash/.bashrc"]="$HOME" ["$DOTFILES_PATH/bash/.bash_profile"]="$HOME"
["$DOTFILES_PATH/bash/.functions.bash"]="$HOME" ["$DOTFILES_PATH/bash/config.bash"]="$HOME"
["$DOTFILES_PATH/bash/.alias.bash"]="$HOME" ["$DOTFILES_PATH/bash/.inputrc"]="$HOME"
["$DOTFILES_PATH/R/.Rprofile"]="$HOME" ["$DOTFILES_PATH/R/.Renviron"]="$HOME"
["$DOTFILES_PATH/misc/.tmux.conf"]="$HOME" ["$DOTFILES_PATH/misc/.vintrc.yaml"]="$HOME"
["$DOTFILES_PATH/bat/"]="$HOME/.config/"
["$DOTFILES_PATH/nvim"]="$HOME/.config/")

link () {
for target in "${!link_pairs[@]}"; do
    # Silently ignore errors here because the files may already exist
    ln -svf "$target" "${link_pairs[$target]}" || echo "$target already linked"
  done
}

link
