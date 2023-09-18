-- Copied from https://github.com/wbthomason/packer.nvim
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath("data")
        .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({
            "git",
            "clone",
            "--depth",
            "1",
            "https://github.com/wbthomason/packer.nvim",
            install_path,
        })
        vim.cmd([[packadd packer.nvim]])
        return true
    end
    return false
end
local packer_bootstrap = ensure_packer()
local packer = require("packer")
packer.init({
    max_jobs = 9,
})

packer.startup(function(use)
    use("wbthomason/packer.nvim")
    use("tpope/vim-unimpaired")
    use("tpope/vim-repeat")
    use("tpope/vim-fugitive")
    use("puremourning/vimspector")
    use({
        "kkoomen/vim-doge",
        run = function()
            vim.fn([[doge#install]])()
        end,
    })
    --use("kassio/neoterm")
    use({
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()
        end,
    })
    use("jpalardy/vim-slime")
    --use("sillybun/vim-repl")
    use("hanschen/vim-ipython-cell")
    use({ "jalvesaq/Nvim-R", branch = "stable" })
    --use("jalvesaq/zotcite")
    use({
        "junegunn/fzf",
        run = function()
            vim.fn([[fzf#install]])()
        end,
    })
    use("junegunn/fzf.vim")
    use("uga-rosa/cmp-dictionary")
    use("kylechui/nvim-surround")
    use("neovim/nvim-lspconfig")
    use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
    use("nvim-treesitter/nvim-treesitter-textobjects")
    use("nvim-treesitter/playground")
    use("REditorSupport/languageserver")
    use("hrsh7th/nvim-cmp")
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-calc")
    use("wsdjeg/luarefvim")
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/cmp-path")
    use("hrsh7th/cmp-cmdline")
    use("hrsh7th/cmp-nvim-lua")
    use("hrsh7th/cmp-nvim-lsp-document-symbol")
    use("hrsh7th/cmp-nvim-lsp-signature-help")
    use("dmitmel/cmp-cmdline-history")
    use("ray-x/cmp-treesitter")
    use("ray-x/lsp_signature.nvim")
    use("f3fora/cmp-spell")
    use("kdheepak/cmp-latex-symbols")
    use("windwp/nvim-autopairs")
    use({
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        --version = "<CurrentMajor>.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp",
        enable_autosnippets = true,
        update_events = "TextChanged,TextChangedI",
        store_selection_keys = "<Alt>",
    })
    use("saadparwaiz1/cmp_luasnip")
    use("honza/vim-snippets")
    use("onsails/lspkind-nvim")
    --use("quangnguyen30192/cmp-nvim-ultisnips")
    use("quangnguyen30192/cmp-nvim-tags")
    use("ncm2/ncm2")
    --use("roxma/nvim-yarp")
    use("chrisbra/csv.vim")
    use("vim-pandoc/vim-pandoc")
    use("vim-pandoc/vim-pandoc-syntax")
    use("nvim-lualine/lualine.nvim")
    use("kyazdani42/nvim-web-devicons")
    use("rareitems/anki.nvim")
    -- Filetypes that lack language servers
    use({
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
    })
    use({
        "quarto-dev/quarto-nvim",
        requires = {
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
    })
    use("jmbuhr/otter.nvim")
    use("jupyter-vim/jupyter-vim")
    --use("rafi/awesome-vim-colorschemes")
    use("folke/tokyonight.nvim")
    use("nvim-lua/plenary.nvim")
    use({ "nvim-telescope/telescope.nvim", tag = "0.1.0" })
    use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
    use("mrjones2014/nvim-ts-rainbow")
    use("jose-elias-alvarez/null-ls.nvim")
    use("LostNeophyte/null-ls-embedded")
    use("makerj/vim-pdf")
    use("kosayoda/nvim-lightbulb")
    use({
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end,
    })
    use("ggandor/leap.nvim")
    use("mfussenegger/nvim-dap")
    use("mfussenegger/nvim-dap-python")
    use("rcarriga/nvim-dap-ui")
    use("theHamsta/nvim-dap-virtual-text")
    -- Automatically set up configuration after cloning packer.nvim
    if packer_bootstrap then
        packer.sync()
    end
end)

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
