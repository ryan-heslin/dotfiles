
filetype plugin indent on
colorscheme OceanicNext
let g:session_dir="~/.vim/sessions"
set termguicolors
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite,.Rdata,*.git,.Rhistory,*.rds
" Error log files
let $NVIM_PYTHON_LOG_FILE="/tmp/nvim_log"
let $NVIM_PYTHON_LOG_LEVEL="DEBUG"
set background=dark
set mouse=i                   " Enable mouse support in insert mode.
set breakindent
set breakindentopt=shift:2
set showbreak=\\\\\

set clipboard+=unnamedplus
" Line numbers & indentation
set backspace=indent,eol,start
set ma                          " To set mark a at current cursor location.
set hidden
set wrapscan
set shortmess+=c
let &showbreak=">>"
set laststatus=2
set number
set sessionoptions+=winpos,terminal,globals
set relativenumber
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set cursorcolumn
set cmdheight=3
set si "Smart indentation
set ruler
set backspace=indent,eol,start
" Search
set smartcase
set hlsearch
set incsearch
set magic
set scrolloff=3

set title
set titleold="Terminal"
set titlestring=%F
set lazyredraw "Faster mappings

set colorcolumn=80
set spell spelllang=en_us
set showmatch
set mat=2
set noerrorbells

syntax enable
set encoding=utf-8
set fileencoding=utf-8

" Navigation
set path+=**
set wildmenu
set wildmode=longest,list,full
set titlestring=%t

" Backups
execute 'set backupdir=' . join([stdpath('data'), 'backup'], "/")
execute 'set undodir=' . join([stdpath('data'), 'undo'], "/")
set backup
set undofile
set confirm
set autowrite
set noswapfile
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
set statusline=%F%m%r%h%w%=(%{&ff}/%Y)\ (line\ %l\/%L,\ col\ %c)\
!p "\`\`\`" if len(snip.buffer) == snip.line +1 or snip.buffer[snip.line + 1] != "\`\`\`"`
