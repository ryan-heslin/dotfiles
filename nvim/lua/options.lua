vim.cmd('filetype plugin indent on')
vim.cmd('colorscheme OceanicNext')
vim.cmd('syntax enable')

vim.g.session_dir="~/.vim/sessions"
vim.o.termguicolors = true
vim.o.wildignore:append({'*/tmp/*','*.so','*.swp','*.zip','*.pyc','*.db','*.sqlite','.Rdata','*.git','.Rhistory','*.rds'})
-- Error log files
vim.o.background='dark'
vim.o.mouse='i'
vim.o.breakindent = true
vim.o.breakindentopt='shift:2'

vim.o.clipboard:append({'unnamedplus'})
-- Line numbers & indentation
vim.o.backspace:append({'indent', 'eol', 'start'})
vim.o.hidden = true
vim.o.wrapscan = true
vim.o.shortmess:append({'c'})
vim.o.showbreak='>>'
vim.o.laststatus=2
vim.o.number = true
vim.o.sessionoptions:append({'winpos','terminal','globals'})
vim.o.relativenumber = true
vim.o.expandtab = true
vim.o.tabstop=4
vim.o.softtabstop=4
vim.o.shiftwidth=4
vim.o.autoindent = true
vim.o.cursorcolumn = true
vim.o.cmdheight=3
vim.o.si = true  --Smart indentation
vim.o.ruler = true
vim.o.backspace:append({'indent' ,'eol','start'})
-- Search
vim.o.smartcase = true
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.magic = true
vim.o.scrolloff=3

vim.o.title = true
vim.o.titleold='Terminal'
vim.o.titlestring='%F'
vim.o.lazyredraw = true --Faster mappings

vim.o.colorcolumn=80
vim.o.spelllang='en_us'
vim.o.showmatch = true
vim.o.mat=2
vim.o.noerrorbells = true

vim.o.encoding='utf-8'
vim.o.fileencoding='utf-8'

-- Navigation
vim.o.path:append({'**'})
vim.o.wildmenu = true
vim.o.wildmode:append({'longest', 'list', 'full'})
vim.o.titlestring='%t'

-- Backups
vim.o.backupdir = vim.fn.stdpath('data') .. '/backup'
vim.o.undodir=vim.fn.stdpath('data') ..  '/undo'
vim.o.backup = true
vim.o.undofile = true
vim.o.confirm = true
vim.o.autowrite = true
vim.o.noswapfile = true
vim.o.guicursor='n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50'
