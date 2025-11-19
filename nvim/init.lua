--Convert plugin name to config file name
to_config_name = function(plugin)
    return "config/"
        .. string.gsub(string.gsub(plugin, "^.+/", ""), "%.nvim$", "")
end

configure = function(plugin, opts)
    table.insert(opts, 1, plugin)
    -- Just plugin name, not author
    opts["config"] = function()
        require(to_config_name(plugin))
    end
    return opts
end

text_extensions = { ".txt", ".md", ".Rmd", ".qmd", "" }
-- Copied from https://github.com/folke/lazy.nvim.git
local lazypath = vim.fn.stdpath("data") .. "lazy/lazy.nvim"
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
local r_filetypes = { "r", "rmd", "qmd", "rnoweb", "rhelp" }

local plugins = {
    "tpope/vim-unimpaired",
    "tpope/vim-repeat",
    --"tpope/vim-fugitive",
    "puremourning/vimspector",
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("config/which-key")
        end,
    },
    {
        {
            "quarto-dev/quarto-nvim",
            dependencies = {
                "jmbuhr/otter.nvim",
                "nvim-treesitter/nvim-treesitter",
            },
        },
    },
    {
        "kkoomen/vim-doge",
    },
    {
        "olimorris/codecompanion.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "hrsh7th/nvim-cmp",
            {
                "stevearc/dressing.nvim",
                opts = {},
            },
            "nvim-telescope/telescope.nvim",
        },
        config = true,
    },
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()
        end,
    },
    configure("jpalardy/vim-slime", {}),
    "hanschen/vim-ipython-cell",
    configure("jalvesaq/Nvim-R", { ft = r_filetypes }),
    --"jalvesaq/zotcite",
    -- {
    --     "junegunn/fzf",
    --     init = function()
    --         vim.fn["fzf#install"]()
    --     end,
    -- },
    "junegunn/fzf.vim",
    "echasnovski/mini.icons",
    configure("uga-rosa/cmp-dictionary", {}),
    configure("kylechui/nvim-surround", {}),
    "neovim/nvim-lspconfig",
    configure("nvim-treesitter/nvim-treesitter", {}),
    configure("nvim-treesitter/nvim-treesitter-textobjects", {}),
    configure("nvim-treesitter/playground", {}),
    { "REditorSupport/languageserver", lazy = true, ft = r_filetypes },
    configure("hrsh7th/nvim-cmp", { config = "InsertEnter" }),
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-calc",
    { "wsdjeg/luarefvim" },
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-nvim-lsp-document-symbol",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    --{ "jalvesaq/cmp_nvim_r", filetypes = r_filetypes, doc_width = 55 },
    "jalvesaq/cmp-nvim-r",
    "dmitmel/cmp-cmdline-history",
    "ray-x/cmp-treesitter",
    configure("ray-x/lsp_signature.nvim", {}),
    "f3fora/cmp-spell",
    "kdheepak/cmp-latex-symbols",
    configure("windwp/nvim-autopairs", {}),
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
    { "chrisbra/csv.vim",      lazy = true, ft = "csv" },
    { "vim-pandoc/vim-pandoc", lazy = true, ft = { "pandoc", "rmd", "qmd" } },
    {
        "vim-pandoc/vim-pandoc-syntax",
        lazy = true,
        ft = { "pandoc", "rmd", "qmd" },
    },
    configure("nvim-lualine/lualine.nvim", {}),
    "kyazdani42/nvim-web-devicons",
    configure("rareitems/anki.nvim", { lazy = true, ft = "anki" }),
    -- Filetypes that lack language servers
    -- {
    --     "dense-analysis/ale",
    --     ft = {
    --         "c",
    --         --"cpp",
    --         "cmake",
    --         "html",
    --         --"quarto",
    --         "racket",
    --         "sml",
    --         "tex",
    --         "vim",
    --     },
    --     cmd = "ALEEnable",
    --     config = function()
    --         vim.cmd("ALEEnable")
    --     end,
    --     lazy = true,
    -- },
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
        lazy = true,
        ft = "qmd",
    },
    configure("williamboman/mason.nvim", {}),
    { "jmbuhr/otter.nvim",      lazy = true, ft = "qmd" },
    { "jupyter-vim/jupyter-vim" },
    "folke/tokyonight.nvim",
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    --"mrjones2014/nvim-ts-rainbow",
    configure("stevearc/conform.nvim", {}),
    "makerj/vim-pdf",
    "kosayoda/nvim-lightbulb",
    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end,
    },
    configure("ggandor/leap.nvim", {}),
    configure("mfussenegger/nvim-dap", {}),
    configure("mfussenegger/nvim-dap-python", {}),
    configure("rcarriga/nvim-dap-ui", {}),
    "theHamsta/nvim-dap-virtual-text",
    "MunifTanjim/nui.nvim",
    "nvim-neotest/nvim-nio",
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
            {
                "s1n7ax/nvim-window-picker",
                version = "2.*",
                dependencies = {
                    "nvim-lua/plenary.nvim",
                    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
                    "MunifTanjim/nui.nvim",
                    "3rd/image.nvim",
                },
                config = function()
                    require("window-picker").setup({
                        filter_rules = {
                            include_current_win = false,
                            autoselect_one = true,
                            -- filter using buffer options
                            bo = {
                                -- if the file type is one of following, the window will be ignored
                                filetype = {
                                    "neo-tree",
                                    "neo-tree-popup",
                                    "notify",
                                },
                                -- if the buffer type is one of following, the window will be ignored
                                buftype = { "terminal", "quickfix" },
                            },
                        },
                    })
                    require("config/neotree")
                end,
            },
        },
    },
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
require("config/lsp")
require("quarto-utils")
require("autocommands")
require("abbrev")
require("vimscript")
require("mappings")
require("syntax")
require("commands")
-- Manually reset operatorfunc
U.data.restore_default("operatorfunc")
vim.cmd.colorscheme("tokyonight-storm")
