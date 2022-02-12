vim.cmd('filetype plugin indent on')
vim.cmd('colorscheme OceanicNext')
vim.cmd('syntax enable')

vim.g.session_dir="~/.vim/sessions"
vim.o.termguicolors = true
vim.opt.wildignore:append({'*/tmp/*','*.so','*.swp','*.zip','*.pyc','*.db','*.sqlite','.Rdata','*.git','.Rhistory','*.rds', '__pycache__'})
-- Error log files
vim.o.background='dark'
vim.o.mouse='i'
vim.o.breakindent = true
vim.opt.breakindentopt:append({'shift:2', 'min:10'})

vim.opt.clipboard:append({'unnamed', 'unnamedplus'})
-- Line numbers & indentation
vim.opt.backspace:append({'indent', 'eol', 'start'})
vim.o.hidden = true
vim.o.wrapscan = true
vim.opt.shortmess:append({a = True})
vim.o.showbreak='>>'
vim.o.laststatus=2
vim.o.number = true
vim.opt.sessionoptions:append({'winpos','terminal','globals'})
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
vim.opt.backspace:append({'indent' ,'eol','start'})
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

vim.o.colorcolumn= '80'
vim.o.spell = true
vim.o.spelllang='en_us'
vim.o.showmatch = true
vim.o.mat=2
vim.o.errorbells = false

vim.o.encoding='utf-8'
vim.o.fileencoding='utf-8'

-- Navigation
vim.opt.path:append({'**'})
vim.o.wildmenu = true
vim.opt.wildmode:append({'longest', 'list', 'full'})
vim.o.titlestring='%t'

-- Backups
vim.o.backupdir = vim.fn.stdpath('data') .. '/backup'
vim.o.undodir=vim.fn.stdpath('data') ..  '/undo'
vim.o.backup = true
vim.o.undofile = true
vim.o.confirm = true
vim.o.autowrite = true
vim.o.swapfile = false
vim.g.python3_host_prog = [[/usr/bin/python3]]
--vim.o.guicursor=[[n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
 -- ,i-r-cr:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
  --,sm:block-blinkwait175-blinkoff150-blinkon175]]
vim.g.vimsyn_embed ='lP'
