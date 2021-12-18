# My Dotfiles

Here are my configuration files for various tools I use. A quick rundown:

* My `.Rprofile`, the standard user configuration file for the R language, contains some functions for purely interactive use, and my options settings
* The `bash` directory contains my `bash` configuration, split across several files.

* `misc` contains a few other files, such as my `zathurarc`, `inputrc`, and `tmux.conf`.

* The `nvim` directory holds my complete `neovim` configuration: a distressingly long `init.vim`, a
few auxiliary files for setting mappings and filetype options, a steadily growing collection
of Lua utility functions, and some other goodies.

* The `setup_dotfiles.sh` script establishes symlinks to my dotfiles in the appropriate places, at least for an Ubuntu 20.04 machine.

While some of my `bash` functions date back to early 2021, I wrote most of the included files in fall
of that year and had lots of fun doing it. This is one repository I hope never to call finished!

Many pieces of files in this repository were copied or repurposed from StackOverflow posts and
the like. I did my best to credit the source whenever I did so.
