" Plugins
call plug#begin(stdpath('data') . '/plugged')
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-unimpaired'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-fugitive'
    Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }
    Plug 'kassio/neoterm'
    Plug 'jpalardy/vim-slime', { 'for': 'python' }
    Plug 'sillybun/vim-repl'
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
    Plug 'makerj/vim-pdf'
call plug#end()

lua <<EOF
  -- Set up nvim-cmp.
  local custom_utils=require("custom_utils")
  --local lspkind = require("lspkind")
  require('options')
  require('autocommands')
  require('commands')
  require('config/lsp')
  --Local variable represents module, but also created global for configuration ugh
  require('config/nvim-cmp')
  require('config/lualine')
  require('config/autopairs')
  require('config/formatting')
  require('abbrev')
  require('mappings')

  vim.cmd [[
  autocmd FileType md,rmd,anki_vim,txt lua cmp_config.setup.buffer {
      \ sources = table.insert(sources,
          \ {name = 'spell',
          \ max_item_count = 5,
          \ keyword_length = 3}
          \)
  \}
  ]]

 vim.cmd[[
 augroup sql
 autocmd!
 autocmd FileType sql,mysql,plsql,sqlite lua require('cmp').setup.buffer { sources = { { name = 'vim-dadbod'} } }
 augroup END
 ]]
EOF

let g:session_dir="~/.vim/sessions"

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
let R_buffer_opts = "winfixwidth nonumber"
let R_editing_mode= "vi"
let R_csv_app = 'terminal:vd'
let R_clear_line = 1
let R_assign = 0
let R_nvimpager="tab"
let R_rmdchunk=0
let R_objbr_openlist = 1
let R_hifun_globenv = 2
let g:python3_host_prog='/usr/bin/python3'
let R_set_omnifunc = []
let R_auto_omni = []
let R_Rconsole_width = 15
let R_nvim_wd = 1
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
" Statusline
"set laststatus=2

"set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite,.Rdata,*.git,.Rhistory,*.RDS,__pycache__,
" Error log files
let $NVIM_PYTHON_LOG_FILE="/tmp/nvim_log"
let $NVIM_PYTHON_LOG_LEVEL="DEBUG"
let $BASH_ENV="~/dotfiles/bash/.bash_profile"

" General settings
filetype plugin indent on

" Backups

" fzf
let g:fzf_tags_command = 'ctags -R'

" vi-slime settings
let g:slime_target="neovim"
let g:slime_paste_file="$HOME/.slime_paste"
"let g:slime_default_config = {"socket_name": "default", "target_pane": "{last}"}
let g:slime_dont_ask_default = 0

"Linting
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


" Cursor configuration
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
  \,i-r-cr:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
  \,sm:block-blinkwait175-blinkoff150-blinkon175

" From https://github.com/Matt-A-Bennett/linux_config_files/blob/master/minimal_vimrc


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

if(argc() == 0)
	autocmd! VimEnter * nested :call functions#LoadSession()
endif

" From https://superuser.com/questions/345520/vim-number-of-total-buffers
" Remove all trailing whitespace by pressing C-S
"nnoremap <C-S> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
