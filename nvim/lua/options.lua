--TODO cursorbind: scroll multiple windows at once
local o = vim.o
local opt = vim.opt
vim.cmd("filetype plugin indent on")
vim.cmd.syntax("enable")
text_extensions = { "rmd", "tex", "txt", "pandoc", "" }
--For now, enabling this (to use lua filetype detection file in addition to .vim
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

vim.g.session_dir =
    U.utils.join_paths({ vim.fn.expand("$HOME"), ".vim", "sessions" })
o.termguicolors = true
opt.wildignore:append({
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

o.background = "dark"
o.mouse = "i"
o.breakindent = true
opt.breakindentopt:append({ "shift:2", "min:10", "list:2" })
opt.display:append({ "uhex" })
opt.foldopen:append({ "insert", "jump" })
o.foldtext = "{<{}>}"

opt.clipboard:append({ "unnamed", "unnamedplus" })

-- Line numbers & indentation
opt.backspace:append({ "indent", "eol", "start" })
o.hidden = true
o.wrapscan = true
opt.shortmess:append({ a = true })
o.showbreak = ">>"
o.laststatus = 2
o.number = true
o.numberwidth = 3
opt.sessionoptions:append({
    "winpos",
    "terminal",
    "globals",
    "options",
    "tabpages",
})
o.relativenumber = true
o.expandtab = true
o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
o.autoindent = true
o.cursorcolumn = true
o.cmdheight = 1
o.si = true         --Smart indentation
o.ruler = true
o.updatetime = 2000 --Milliseconds, for cursor hold events
opt.backspace:append({ "indent", "eol", "start" })
o.allowrevins = true
o.shellslash = true

-- Search
o.smartcase = true
o.hlsearch = true
o.incsearch = true
o.magic = true
o.scrolloff = 3
o.title = true
o.titleold = "Terminal"
o.titlestring = "%F"
o.lazyredraw = true --Faster mappings

o.colorcolumn = "80"
o.spell = true
o.spelllang = "en_us"
o.showmatch = true
o.mat = 2
o.errorbells = false

o.encoding = "utf-8"
--o.fileencoding = "utf-8"

-- Navigation
opt.path:append({ "**" })
o.wildmenu = true
opt.wildmode:append({ "longest", "list", "full" })
o.titlestring = "%t"
opt.switchbuf:append({ "uselast", "useopen" })
o.bufhidden = "hide"

o.virtualedit = "block"

-- Press to wrap
o.whichwrap = "b,s,<,>,~,[,]"

o.winblend = 20

-- Backups
local data = vim.fn.stdpath("data")
o.backupdir = data .. "/backup//"
o.undodir = data .. "/undo//"
o.directory = data .. "/swap//"
o.backup = true
o.undofile = true
o.confirm = true
o.autowrite = true
--vim.o.swapfile = false
--vim.g.python3_host_prog = vim.fn.system("which python3")
--Cursor customization
vim.cmd([[
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
  \,i-r-cr:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
  \,sm:block-blinkwait175-blinkoff150-blinkon175
]])
vim.g.vimsyn_embed = "lP"
o.helpheight = 15

o.splibelow = true
o.spliright = true
opt.gdefault = true

-- default g for substitute command; unfortunately deprecated
--vim.o.gdefault = true
--Of interest:
--tags (tags filenames)
--guioptions
--jumplist
--scrolljump
