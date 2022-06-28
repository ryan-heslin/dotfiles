" Plugins
call plug#begin(stdpath('data') . '/plugged')
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-unimpaired'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-fugitive'
    Plug 'puremourning/vimspector'
    Plug 'nvim-lua/plenary.nvim'
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
    Plug 'uga-rosa/cmp-dictionary'
    Plug 'nvim-lua/lsp-status.nvim'
    "Plug 'lukas-reineke/lsp-format.nvim'
    Plug 'neovim/nvim-lspconfig'
    Plug 'REditorSupport/languageserver'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-calc'
    Plug 'wsdjeg/luarefvim'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/cmp-nvim-lua'
    Plug 'ray-x/lsp_signature.nvim'
    Plug 'f3fora/cmp-spell'
    Plug 'kdheepak/cmp-latex-symbols'
    Plug 'windwp/nvim-autopairs'
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
    Plug 'onsails/lspkind-nvim'
    Plug 'quangnguyen30192/cmp-nvim-ultisnips'
    Plug 'quangnguyen30192/cmp-nvim-tags'
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
  require("custom_utils")
  require('autocommands')
  require('options')
  require('commands')
  require('config/cmp_dictionary')
  require('config/lsp')
  --Local variable represents module, but also created global for configuration ugh
  require('config/nvim-cmp')
  require('config/lualine')
  require('config/autopairs')
  require('config/formatting')
  require('config/lsp_signature')
  require('config/Nvim-R')
  require('config/UltiSnips')
  require('config/vim-slime')
  require('config/ale')
  require('abbrev')
  require('mappings')
  require('syntax')
 vim.cmd[[
 augroup sql
 autocmd!
 autocmd FileType sql,mysql,plsql,sqlite lua require('cmp').setup.buffer { sources = { { name = 'vim-dadbod'} } }
 augroup END
 ]]
EOF

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
let $NVIM_PYTHON_LOG_FILE="/tmp/nvim_log"
let $NVIM_PYTHON_LOG_LEVEL="DEBUG"
let $BASH_ENV="~/dotfiles/bash/.bash_profile"

" General settings
filetype plugin indent on

" Backups
" fzf
let g:fzf_tags_command = 'ctags -R'

" vi-slime settings
"let g:slime_target="neovim"
"let g:slime_paste_file="$HOME/.slime_paste"
""let g:slime_default_config = {"socket_name": "default", "target_pane": "{last}"}
"let g:slime_dont_ask_default = 1

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
    \ 'python': ['pylint']
    \}
   "\ 'r': ['lintr'],
   "\  'rmd': ['lintr', 'tex'],
 "\}
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
let g:ale_r_lintr_options='lintr::with_defaults()'
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
"autocmd TermEnter * :lua set_term_opts()
