--TODO cursorbind: scroll multiple windows at once
vim.cmd("filetype plugin indent on")
vim.cmd.syntax("enable")
vim.cmd.colorscheme("OceanicNext")
text_extensions = { "rmd", "tex", "txt", "pandoc", "" }
--For now, enabling this (to use lua filtetype detection file in addition to .vim
--version) just slows startup
--vim.g.do_filetype_lua = 1
-- Needed since move to packer
--U.setenv("NVIM_PYTHON_LOG_FILE", "/tmp/nvim_log")
--U.setenv("NVIM_PYTHON_LOG_LEVEL", "DEBUG")
--U.setenv("BASH_ENV", vim.fn.expand("$HOME/dotfiles/bash/.bash_profile"))
vim.cmd([[
let $NVIM_PYTHON_LOG_FILE="/tmp/nvim_log"
let $NVIM_PYTHON_LOG_LEVEL="DEBUG"
let $BASH_ENV="~/dotfiles/bash/.bash_profile"
]])
--vim.g["$BASH_ENV"] = vim.fn.expand("$HOME/dotfiles/bash/.bash_profile")

vim.o.runtimepath = vim.o.runtimepath
    .. ","
    .. vim.fn.expand("$HOME/.local/share/nvim/site/pack/packer")
vim.g.session_dir = vim.fn.expand("$HOME/.vim/sessions")
vim.o.termguicolors = true
vim.opt.wildignore:append({
    "*.db",
    "*.git",
    "*.pyc",
    "*.rds",
    "*.so",
    "*.swp",
    "*.zip",
    "*/tmp/*",
    ".Rdata",
    ".Rhistory",
    "__pycache__",
})

vim.o.background = "dark"
vim.o.mouse = "i"
vim.o.breakindent = true
vim.opt.breakindentopt:append({ "shift:2", "min:10", "list:2" })
vim.opt.display:append({ "uhex" })
vim.opt.foldopen:append({ "insert", "jump" })
vim.o.foldtext = "{<{}>}"

vim.opt.clipboard:append({ "unnamed", "unnamedplus" })

-- Line numbers & indentation
vim.opt.backspace:append({ "indent", "eol", "start" })
vim.o.hidden = true
vim.o.wrapscan = true
vim.opt.shortmess:append({ a = true })
vim.o.showbreak = ">>"
vim.o.laststatus = 2
vim.o.number = true
vim.o.numberwidth = 3
vim.opt.sessionoptions:append({
    "winpos",
    "terminal",
    "globals",
    "options",
    "tabpages",
})
vim.o.relativenumber = true
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.autoindent = true
vim.o.cursorcolumn = true
vim.o.cmdheight = 1
vim.o.si = true --Smart indentation
vim.o.ruler = true
vim.o.updatetime = 2000 --Milliseconds, for cursor hold events
vim.opt.backspace:append({ "indent", "eol", "start" })
vim.o.allowrevins = true
vim.o.shellslash = true

-- Search
vim.o.smartcase = true
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.magic = true
vim.o.scrolloff = 3
vim.o.title = true
vim.o.titleold = "Terminal"
vim.o.titlestring = "%F"
vim.o.lazyredraw = true --Faster mappings

vim.o.colorcolumn = "80"
vim.o.spell = true
vim.o.spelllang = "en_us"
vim.o.showmatch = true
vim.o.mat = 2
vim.o.errorbells = false

vim.o.encoding = "utf-8"
vim.o.fileencoding = "utf-8"

-- Navigation
vim.opt.path:append({ "**" })
vim.o.wildmenu = true
vim.opt.wildmode:append({ "longest", "list", "full" })
vim.o.titlestring = "%t"
vim.opt.switchbuf:append({ "uselast", "useopen" })
vim.o.bufhidden = "hide"

vim.o.virtualedit = "block"

-- Press to wrap
vim.o.whichwrap = "b,s,<,>,~,[,]"

vim.o.winblend = 20

-- Backups
vim.o.backupdir = vim.fn.stdpath("data") .. "/backup"
vim.o.undodir = vim.fn.stdpath("data") .. "/undo"
vim.o.backup = true
vim.o.undofile = true
vim.o.confirm = true
vim.o.autowrite = true
vim.o.swapfile = false
vim.g.python3_host_prog = "/usr/bin/python3"
vim.cmd([[
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
  \,i-r-cr:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
  \,sm:block-blinkwait175-blinkoff150-blinkon175
]])
vim.g.vimsyn_embed = "lP"
vim.o.helpheight = 15

vim.o.splibelow = true
vim.o.spliright = true

-- default g for substitute command; unfortunately deprecated
--vim.o.gdefault = true
--Of interest:
--tags (tags filenames)
--guioptions
--jumplist
--scrolljump
