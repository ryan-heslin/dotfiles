#!/usr/bin/bash
 
DOTFILES_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
# From https://github.com/ajmalsiddiqui/dotfiles/blob/master/bootstrap.exclude.sh
link () {
for file in $( find . -type f -printf "%P\n" | grep -vE '\$|~|\.exclude*|\.git$|\.gitignore') ; do
    # Silently ignore errors here because the files may already exist
    ln -svf "$DOTFILES_PATH/$file" "$HOME" || true
    #Handle different dotfile name conventions
    if [[   "$file" == 'vim/init.vim' ]]; then
	    if [[ $OSTYPE == 'linux-gnu' ]]; then
		    mv "$HOME/$(basename $file)" "$HOME/.config/nvim/$(basename $file)"
	    else
		    mv "$HOME/$(basename $file)" "$HOME/AppData/Local/nvim/$(basename $file)"
	    fi
    fi
  done
}

link
