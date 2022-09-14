-- Copied from https://github.com/wbthomason/packer.nvim
local packer = require("packer")
packer.init({
    max_jobs = 9,
})
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

packer.startup(function(use)
    use("wbthomason/packer.nvim")
    use("tpope/vim-unimpaired")
    use("tpope/vim-repeat")
    use("tpope/vim-fugitive")
    use("puremourning/vimspector")
    use({
        "kkoomen/vim-doge",
        run = function()
            vin.fn([[doge#install]])()
        end,
    })
    use("kassio/neoterm")
    use("jpalardy/vim-slime")
    use("sillybun/vim-repl")
    use("hanschen/vim-ipython-cell")
    use({ "jalvesaq/Nvim-R", branch = "stable" })
    use("jalvesaq/zotcite")
    use({
        "junegunn/fzf",
        run = function()
            vim.fn([[fzf#install]])()
        end,
    })
    use("junegunn/fzf.vim")
    use("lervag/vimtex")
    use("uga-rosa/cmp-dictionary")
    use("nvim-lua/lsp-status.nvim")
    use("kylechui/nvim-surround")
    --use 'lukas-reineke/lsp-format.nvim'
    use("jez/vim-better-sml")
    use("neovim/nvim-lspconfig")
    use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
    use("REditorSupport/languageserver")
    use("hrsh7th/nvim-cmp")
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-calc")
    use("wsdjeg/luarefvim")
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/cmp-path")
    use("hrsh7th/cmp-cmdline")
    use("hrsh7th/cmp-nvim-lua")
    use("ray-x/lsp_signature.nvim")
    use("f3fora/cmp-spell")
    use("kdheepak/cmp-latex-symbols")
    use("windwp/nvim-autopairs")
    use("SirVer/ultisnips")
    use("honza/vim-snippets")
    use("onsails/lspkind-nvim")
    use("quangnguyen30192/cmp-nvim-ultisnips")
    use("quangnguyen30192/cmp-nvim-tags")
    use("ncm2/ncm2")
    use("roxma/nvim-yarp")
    use("chrisbra/csv.vim")
    use("vim-pandoc/vim-pandoc")
    use("vim-pandoc/vim-pandoc-syntax")
    use("nvim-lualine/lualine.nvim")
    use("kyazdani42/nvim-web-devicons")
    -- Filetypes that lack language servers
    use({
        "dense-analysis/ale",
        ft = {
            "c",
            "cpp",
            "cmake",
            "html",
            "markdown",
            "racket",
            "sml",
            "tex",
            "vim",
        },
        cmd = "ALEEnable",
        config = "vim.cmd('ALEEnable')",
    })
    use({
        "glacambre/firenvim",
        run = function()
            vim.fn["firenvim#install"](0)
        end,
    })
    use("jupyter-vim/jupyter-vim")
    use("rafi/awesome-vim-colorschemes")
    use("nvim-lua/plenary.nvim")
    use({ "nvim-telescope/telescope.nvim", tag = "0.1.0" })
    use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
    use("tpope/vim-dadbod")
    use("frazrepo/vim-rainbow")
    use("jose-elias-alvarez/null-ls.nvim")
    use("makerj/vim-pdf")
    use({
        "phaazon/hop.nvim",
        branch = "v2", -- optional but strongly recommended
        config = function()
            -- you can configure Hop the way you like here; see :h hop-config
            require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
        end,
    })
    -- Automatically set up your configuration after cloning packer.nvim
    if packer_bootstrap then
        packer.sync()
    end
end)

require("custom_utils")
require("autocommands")
require("options")
require("commands")
require("config/cmp-dictionary")
require("config/lsp")
require("config/nvim-cmp")
require("config/lualine")
require("config/autopairs")
require("config/formatting")
require("config/lsp_signature")
require("config/Nvim-R")
require("config/UltiSnips")
require("config/vim-slime")
require("config/treesitter")
require("config/hop")
require("quarto")
require("config/nvim-surround")
require("abbrev")
require("vimscript")
require("mappings")
require("syntax")

-- From https://superuser.com/questions/345520/vim-number-of-total-buffers
-- Remove all trailing whitespace by pressing C-S
--nnoremap <C-S> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
