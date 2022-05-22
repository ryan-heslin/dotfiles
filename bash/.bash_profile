#!/usr/bin/bash

export DOTFILES_DIR="$HOME/dotfiles"
export R_ENVIRON_USER="$DOTFILES_DIR/R/.Renviron"
. "$DOTFILES_DIR/bash/functions.bash"
for file in $( find $DOTFILES_DIR/bash -type f | grep -vE 'bashrc|profile|~|input|functions' ); do
	. "$file"
done
