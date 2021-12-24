" Plugins
call plug#begin(stdpath('data') . '/plugged')
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-unimpaired'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-fugitive'
    Plug 'kassio/neoterm'
    Plug 'jpalardy/vim-slime', { 'for': 'python' }
    Plug 'sillybun/vim-repl'
    Plug 'metakirby5/codi.vim'
    Plug 'hanschen/vim-ipython-cell', { 'for': 'python' }
    Plug 'jalvesaq/Nvim-R', {'branch': 'stable'}
    Plug 'jalvesaq/zotcite'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'lervag/vimtex'
    Plug 'nvim-lua/lsp-status.nvim'
    Plug 'neovim/nvim-lspconfig'
    Plug 'REditorSupport/languageserver'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'wsdjeg/luarefvim'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/cmp-nvim-lua'
    Plug 'f3fora/cmp-spell'
    Plug 'kdheepak/cmp-latex-symbols'
    Plug 'windwp/nvim-autopairs'
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
    Plug 'onsails/lspkind-nvim'
    Plug 'quangnguyen30192/cmp-nvim-ultisnips'
    Plug 'ncm2/ncm2'
    Plug 'roxma/nvim-yarp'
    Plug 'chrisbra/csv.vim'
    Plug 'vim-pandoc/vim-pandoc'
    Plug 'vim-pandoc/vim-pandoc-syntax'
    Plug 'nvim-lualine/lualine.nvim'
    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'dense-analysis/ale'
    Plug 'rafi/awesome-vim-colorschemes'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
    Plug 'tpope/vim-dadbod'
    Plug 'frazrepo/vim-rainbow'
    Plug 'jose-elias-alvarez/null-ls.nvim'
call plug#end()

" LSP setup - largely copied from various repoes
lua <<EOF
  -- Set up nvim-cmp.
  local custom_utils=require("custom_utils")
  --local lspkind = require("lspkind")
  require('config/lsp')

  --Local variable represents module, but also created global for configuration ugh
  require('config/nvim_cmp')
  require('config/lualine')
  require('config/autopairs')
  require('config/formatting')
  require('abbrev')
  require('mappings')

  vim.cmd [[
  autocmd FileType rmd lua cmp_config.setup.buffer {
      \ sources = table.insert(sources, {
          \ {name = 'spell',
          \ max_item_count = 5,
          \ keyword_length = 3},
          \})
  \}
  ]]
 vim.cmd[[
 augroup sql
 autocmd!
 autocmd FileType sql,mysql,plsql,sqlite lua require('cmp').setup.buffer { sources = { { name = 'vim-dadbod'} } }
 augroup END
 ]]

-- Copied from https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua
EOF

colorscheme OceanicNext
let g:session_dir="~/.vim/sessions"
set termguicolors
" Plugin settings

let g:codi#interpreters = { 'r': {
    \'bin': '/usr/bin/R',
    \'prompt': '^\(>\) ',
\}
\}
" UltiSnips
let g:UltiSnipsExpandTrigger="<F2>"
let g:UltiSnipsJumpForwardTrigger="<Tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-Tab>"
let g:UltiSnipsSnippetDirectories=["UltiSnips", "custom_snippets"]
let g:UliSnipsListSnippets="<F2>"
let g:UltiSnipsRemoveSelectModeMappings = 0
let g:UltiSnipsEditSplit="context"
let g:UltiSnipsSnipperStorageDirectoryForUltiSnipsEdit=stdpath("config") . "/custom_snippets"

" From https://gist.github.com/TheCedarPrince/7b9b51af4c146880f17c39407815b594
inoremap <expr> <c-x><c-f> fzf#vim#complete#path('rg --files')
cnoremap <expr> <c-x><c-f> fzf#vim#complete#path('rg --files')
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit',
  \ 'ctrl-o': ':r !echo',
  \ 'ctrl-c': '!bat'
  \ }
let g:vimsyn_embed="lP"
" Nvim-R
let rout_follow_colorscheme = 1
let Rout_more_colors = 1

" Disable default assign shortcut
"let R_esc_term = 0
let R_buffer_opts = "winfixwidth nonumber"
"let R_editing_mode= "vi"
"let R_args = ['--no-readline']
let R_csv_app = '/usr/bin/libreoffice  --calc'
let R_clear_line = 1
let R_assign = 0
let R_nvimpager="tab"
let R_rmdchunk=0
let R_objbr_openlist = 1
let R_hifun_globenv = 2
let g:python3_host_prog='/usr/bin/python3'
let R_set_omnifunc = []
let R_auto_omni = []
" let R_external_term = 'xterm -title R -e'
let R_Rconsole_width = 15
autocmd VimResized * let R_Rconsole_width = winwidth(0) / 4
let R_min_editor_width = 25

" Syntax options
" NB vim assumes Oracle SQL
let rmd_syn_hl_chunk = 1
let rrst_syn_hl_chunk = 1
let readline_has_bash = 1
let g:is_bash = 1
let python_highlight_all = 1
" Special highlighting for globalenv functions
augroup Colors
    autocmd!
    autocmd ColorScheme * highlight NormalFloat guibg=#1f2335
    \ | highlight! FloatBorder guifg=white guibg=#1f2335
    \ | highlight! Pmenu guibg=#1f2335
    \ | highlight! PmenuSel guibg=#cca300
    \ | highlight! PmenuSBar guibg=white
    \ | highlight! PmenuThumb guibg=#cca300
    \ | highlight! rGlobEnvFun ctermfg=117 guifg=#87d7ff cterm=italic gui=italic
    \ | highlight! LspReferenceRead guifg=LightGreen guibg=Yellow
    \ | highlight! LspReferenceWrite guifg=Yellow guibg=Yellow
    \ | highlight! LspSignatureActiveParameters guifg=Green
    \ | highlight! ColorColumn  guibg=wheat guifg=wheat
    \ | highlight! CmpItemAbbr guifg=wheat
    \ | highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6
    \ | highlight! CmpItemAbbrMatchFuzzy guibg=NONE guifg=#569CD6
    \ | highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0
    \ | highlight! CmpItemKindMethod guibg=NONE guifg=#C586C0
    \ | highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE
    \ | highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4
    \ | highlight! CmpItemMenu guibg=#507b96
    \ | let g:rainbow_active = 1
    \ | let g:rainbow_guifgs = ['RoyalBlue3', 'DarkOrange3', 'DarkOrchid3', 'FireBrick']
    \ | let g:rainbow_ctermfgs = ['lightblue', 'lightgreen', 'yellow', 'red', 'magenta']
augroup end
" Remember cursor position color
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" |

autocmd BufEnter * if &buftype == 'terminal' | :startinsert | endif
autocmd TermEnter * :lua set_term_opts()
" Statusline
let g:airline_theme="badwolf"
set laststatus=2
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline_skip_empty_sections = 1

set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite,.Rdata,*.git,.Rhistory,*.RDS
" Error log files
let $NVIM_PYTHON_LOG_FILE="/tmp/nvim_log"
let $NVIM_PYTHON_LOG_LEVEL="DEBUG"
let $BASH_ENV="~/dotfiles/bash/.bash_profile"

" General settings
filetype plugin indent on
set background=dark
set mouse=i                   " Enable mouse support in insert mode.
set breakindent
set breakindentopt=shift:2
set showbreak=\\\\\

set clipboard+=unnamed,unnamedplus
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

set statusline=%F%m%r%h%w%=(%{&ff}/%Y)\ (line\ %l\/%L,\ col\ %c)\

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
"nnoremap n nzzzv
"nnoremap N Nzzzv
"Parenthesize paragraph
"nnoremap <leader>PP mz(I(<esc>)A)<Esc>`z
" Highlight long lines
" From https://www.youtube.com/watch?v=aHm36-na4-4
"autocmd BufEnter * if &buftype == "" | :bufdo set colorcolumn=80 | endif

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

"pear_tree
let g:pear_tree_pairs = {
            \ '(': {'closer': ')'},
            \ '[': {'closer': ']'},
            \ '{': {'closer': '}'},
            \ "'": {'closer': "'"},
            \ '"': {'closer': '"'},
            \ "<!--": {'closer': "-->"},
            \ "`" : {'closer' : '`'},
            \ "<" : {'closer' : '>'}
            \ }
" fzf
let g:fzf_tags_command = 'ctags -R'

" vi-slime settings
let g:slime_target="neovim"
let g:slime_paste_file="$HOME/.slime_paste"
"let g:slime_default_config = {"socket_name": "default", "target_pane": "{last}"}
let g:slime_dont_ask_default = 0

"Linting
 "let g:ale_lint_on_text_changed=1
 let g:ale_fix_on_save=1
 let g:ale_lint_on_save=0
 let g:ale_fixers = {
 \ 'r': ['styler'],
 \ 'rmarkdown': ['styler'],
 \ 'rmd': ['styler'],
 \ '*': ['remove_trailing_lines', 'trim_whitespace'],
 \   'python': ['isort', 'black']
 \}
 let g:ale_linters = {
   \ 'sh': ['shell'],
    \ 'bash':  ['language_server'],
   \ 'python': ['pylint'],
   \ 'r': ['lintr'],
   \  'rmd': ['lintr', 'tex'],
 \}
 let g:ale_warn_about_trailing_whitespace=0
 let g:ale_warn_about_trailing_blank_lines=0
 "let g:ale_r_lintr_options='lintr::with_defaults(absolute_path_linter = absolute_path_linter(lax = FALSE),
                              "\ cyclocomp_linter = cyclocomp_linter(20),
                              "\ implicit_integer_linter = implicit_integer_linter(),
                              "\ line_length_linter(120),
                              "\ object_usage_linter = object_usage_linter(),
                              "\ spaces_left_parentheses_linter = spaces_left_parentheses_linter(),
                              "\ unneeded_concatenation_linter = unneeded_concatenation_linter()
                            "\ )'
highlight ALEErrorSign guifg=Red
highlight ALEWarningSign guifg=Yellow

autocmd FileType text setlocal textwidth=78

" Cursor configuration
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
  \,i-r-cr:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
  \,sm:block-blinkwait175-blinkoff150-blinkon175

" From https://github.com/Matt-A-Bennett/linux_config_files/blob/master/minimal_vimrc
augroup cursor_behaviour
    autocmd!
    let &t_EI = "\e[2 q"
    " highlight current line when in insert mode
    autocmd InsertEnter * set cursorline
    " turn off current line hightlighting when leaving insert mode
    autocmd InsertLeave * set nocursorline
augroup END


augroup R
    autocmd!
    autocmd FileType rmarkdown,rmd,r setlocal cinwords=if,else,for,while,repeat,function
    autocmd FileType rmarkdown,rmd nnoremap \kk :call functions#InlineSend()<CR>
  augroup end

augroup shell
  autocmd!
  autocmd FileType shell nnoremap <leader>sh :1normal #!/usr/bin/bash<CR>
augroup end
" Remove all trailing whitespace by pressing C-S
"nnoremap <C-S> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>
"autocmd FileType help windo normal 6-<CR>
" General macros

autocmd User TelescopePreviewerLoaded setlocal wrap

command!  -range Embrace <line1>,<line2>s/\v(_|\^)\s*([^{}_\^ \$]+)/\1{\2}/g
command! -nargs=1 -range=% Sed <line1>,<line2>s/<args>//g
command! -nargs=1 -range=% Grab <line1>,<line2>g/<args>/yank Z
"command! -nargs=1 -range
" Switch window to buffer already open
"TODO autocomplete something for zotref
command! -nargs=1 -complete=buffer E edit <args>
" From https://unix.stackexchange.com/questions/72051/vim-how-to-increase-each-number-in-visual-block
" Increments all by 1 in visual selection
command!-range Inc <line1>,<line2>s/\%V\d\+\%V/\=submatch(0)+1/g

" Maybe useful later?
function! CompleteBufname(ArgLead, CmdLine, CursorPos)
    let dicts = getbufinfo({'bufloaded' : 1, 'buflisted' : 1})
    let complete = ''
    let joiner = ''
    for dict in dicts
        let complete = complete . joiner .dict['name']
        let joiner = '\n'
    endfor
    return complete

endfunction
"New regex  "s/\v([a-zA-Z]+)(\d+)/\1 \2/g
" Delete buffer without closing widow
command! BD :bprevious | split | bnext | bdelete

autocmd! User TelescopePreviewerLoaded setlocal wrap
autocmd! BufWritePost if get(b:, b:source_on_save) == 1  | lua refresh(vim.fn.expand('%:p')) | endif
autocmd! FileType anki_vim let b:UltiSnipsSnippetDirectories = g:UltiSnipsSnippetDirectories


if(argc() == 0)
	au VimEnter * nested :call functions#LoadSession()
endif

" From https://superuser.com/questions/345520/vim-number-of-total-buffers
au VimLeavePre * if (luaeval("count_bufs_by_type(true)['normal']") > 1) && (luaeval("summarize_option('ft')['anki_vim'] == nil") == 1) | :call functions#SaveSession() | endif
