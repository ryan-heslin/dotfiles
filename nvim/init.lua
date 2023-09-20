-- Copied from https://github.com/wbthomason/packer.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    "tpope/vim-unimpaired",
    "tpope/vim-repeat",
    "tpope/vim-fugitive",
    "puremourning/vimspector",
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {
            plugins = {
                marks = true, -- shows a list of your marks on ' and `
                registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
                -- the presets plugin, adds help for a bunch of default keybindings in Neovim
                -- No actual key bindings are created
                spelling = {
                    enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
                    suggestions = 20, -- how many suggestions should be shown in the list?
                },
                presets = {
                    operators = true, -- adds help for operators like d, y, ...
                    motions = true, -- adds help for motions
                    text_objects = true, -- help for text objects triggered after entering an operator
                    windows = true, -- default bindings on <c-w>
                    nav = true, -- misc bindings to work with windows
                    z = true, -- bindings for folds, spelling and others prefixed with z
                    g = true, -- bindings for prefixed with g
                },
            },
            -- add operators that will trigger motion and text object completion
            -- to enable all native operators, set the preset / operators plugin above
            operators = { gc = "Comments" },
            key_labels = {
                -- override the label used to display some keys. It doesn't effect WK in any other way.
                -- For example:
                ["<space>"] = "<Space>",
                ["<cr>"] = "<CR>",
                ["<tab>"] = "<Tab>",
            },
            motions = {
                count = true,
            },
            icons = {
                breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
                separator = "➜", -- symbol used between a key and it's label
                group = "+", -- symbol prepended to a group
            },
            popup_mappings = {
                scroll_down = "<C-d>", -- binding to scroll down inside the popup
                scroll_up = "<C-u>", -- binding to scroll up inside the popup
            },
            window = {
                border = "none", -- none, single, double, shadow
                position = "bottom", -- bottom, top
                margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]. When between 0 and 1, will be treated as a percentage of the screen size.
                padding = { 1, 2, 1, 2 }, -- extra window padding [top, right, bottom, left]
                winblend = 0, -- value between 0-100 0 for fully opaque and 100 for fully transparent
                zindex = 1000, -- positive value to position WhichKey above other floating windows.
            },
            layout = {
                height = { min = 4, max = 20 }, -- min and max height of the columns
                width = { min = 20, max = 40 }, -- min and max width of the columns
                spacing = 3, -- spacing between columns
                align = "left", -- align columns left, center or right
            },
            ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
            hidden = {
                "<silent>",
                "<cmd>",
                "<Cmd>",
                "<CR>",
                "^:",
                "^ ",
                "^call ",
                "^lua ",
            }, -- hide mapping boilerplate
            show_help = true, -- show a help message in the command line for using WhichKey
            show_keys = true, -- show the currently pressed key and its label as a message in the command line
            triggers = "auto", -- automatically setup triggers
            -- triggers = {"<leader>"} -- or specifiy a list manually
            -- list of triggers, where WhichKey should not wait for timeoutlen and show immediately
            triggers_nowait = {
                -- marks
                "`",
                "'",
                "g`",
                "g'",
                -- registers
                '"',
                "<c-r>",
                -- spelling
                "z=",
            },
            triggers_blacklist = {
                -- list of mode / prefixes that should never be hooked by WhichKey
                -- this is mostly relevant for keymaps that start with a native binding
                i = { "j", "k" },
                v = { "j", "k" },
            },
            -- disable the WhichKey popup for certain buf types and file types.
            -- Disabled by default for Telescope
            disable = {
                buftypes = { "terminal" },
                filetypes = { "help" },
            },
        } -- refer to the configuration section below
        , -- your configuration comes here -- or leave it empty to use the default settings
    },
    {
        "kkoomen/vim-doge",
        -- init = function()
        --     vim.fn["doge#install"]()
        -- end,
    },
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()
        end,
    },
    "jpalardy/vim-slime",
    "hanschen/vim-ipython-cell",
    { "jalvesaq/Nvim-R", branch = "stable" },
    --"jalvesaq/zotcite",
    -- {
    --     "junegunn/fzf",
    --     init = function()
    --         vim.fn["fzf#install"]()
    --     end,
    -- },
    "junegunn/fzf.vim",
    "uga-rosa/cmp-dictionary",
    "kylechui/nvim-surround",
    "neovim/nvim-lspconfig",
    { "nvim-treesitter/nvim-treesitter", build = "TSUpdate" },
    "nvim-treesitter/nvim-treesitter-textobjects",
    "nvim-treesitter/playground",
    "REditorSupport/languageserver",
    { "hrsh7th/nvim-cmp", config = "InsertEnter" },
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-calc",
    "wsdjeg/luarefvim",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-nvim-lsp-document-symbol",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "dmitmel/cmp-cmdline-history",
    "ray-x/cmp-treesitter",
    "ray-x/lsp_signature.nvim",
    "f3fora/cmp-spell",
    "kdheepak/cmp-latex-symbols",
    "windwp/nvim-autopairs",
    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        --version = "<CurrentMajor>.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp",
        opts = {
            enable_autosnippets = true,
            update_events = "TextChanged,TextChangedI",
            store_selection_keys = "<Alt>",
        },
    },
    "saadparwaiz1/cmp_luasnip",
    "honza/vim-snippets",
    "onsails/lspkind-nvim",
    "quangnguyen30192/cmp-nvim-tags",
    "ncm2/ncm2",
    "chrisbra/csv.vim",
    "vim-pandoc/vim-pandoc",
    "vim-pandoc/vim-pandoc-syntax",
    "nvim-lualine/lualine.nvim",
    "kyazdani42/nvim-web-devicons",
    "rareitems/anki.nvim",
    -- Filetypes that lack language servers
    {
        "dense-analysis/ale",
        ft = {
            "c",
            "cpp",
            "cmake",
            "html",
            --"quarto",
            --"markdown",
            "racket",
            "sml",
            "tex",
            "vim",
        },
        cmd = "ALEEnable",
        config = "vim.cmd('ALEEnable')",
    },
    {
        "quarto-dev/quarto-nvim",
        dependencies = {
            "jmbuhr/otter.nvim",
            "neovim/nvim-lspconfig",
        },
        config = function()
            require("quarto").setup({
                lspFeatures = {
                    enabled = true,
                    languages = { "r", "python", "julia" },
                    diagnostics = {
                        enabled = true,
                        triggers = { "BufWrite" },
                    },
                    completion = {
                        enabled = true,
                    },
                },
            })
        end,
    },
    "jmbuhr/otter.nvim",
    "jupyter-vim/jupyter-vim",
    "folke/tokyonight.nvim",
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope.nvim", tag = "0.1.0" },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "mrjones2014/nvim-ts-rainbow",
    "jose-elias-alvarez/null-ls.nvim",
    "LostNeophyte/null-ls-embedded",
    "makerj/vim-pdf",
    "kosayoda/nvim-lightbulb",
    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end,
    },
    "ggandor/leap.nvim",
    "mfussenegger/nvim-dap",
    "mfussenegger/nvim-dap-python",
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
}
local opts = { git = { log = { "-10" } } }
require("lazy").setup(plugins, opts)
-- My custom configuration files
vim.g.mapleader = ","
--U = require("custom_utils")
U = {}
local home = string.gsub(
    vim.fn.system("dirname " .. vim.fn.shellescape(vim.fn.expand("$MYVIMRC"))),
    "\n",
    ""
)
local files = {}
local modules = vim.fn.glob(home .. "/lua/modules/*.lua")
local pattern = "([^\n]+)"
for str in string.gmatch(modules, pattern) do
    table.insert(files, str)
end

for _, file in ipairs(files) do
    local name = string.match(file, "^.*/modules/(.*)%.lua$")
    U[name] = dofile(file)
end

require("options")
require("config/cmp-dictionary")
require("config/nvim-cmp")
require("config/lualine")
require("config/autopairs")
require("config/null-ls")
require("config/Nvim-R")
require("config/LuaSnip")
require("config/vim-slime")
require("config/nvim-treesitter")
require("config/nvim-treesitter-textobjects")
require("config/leap")
require("config/anki")
require("config/nvim-dap")
require("config/nvim-dap-ui")
require("config/nvim-dap-python")
require("config/nvim-dap-virtual-text")
require("config/playground")
require("quarto-utils")
require("config/nvim-surround")
require("config/lsp")
require("config/lsp_signature")
require("autocommands")
require("abbrev")
require("vimscript")
require("mappings")
require("syntax")
require("commands")

-- Manually reset operatorfunc
U.data.restore_default("operatorfunc")
