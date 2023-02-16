require("abbrev")
local opts = { noremap = true, silent = true, buffer = true }
dofile(vim.api.nvim_get_runtime_file("ftplugin/r.lua", false)[1])
dofile(vim.api.nvim_get_runtime_file("ftplugin/tex.lua", false)[1])
dofile(vim.api.nvim_get_runtime_file("ftplugin/pandoc.lua", false)[1])

vim.keymap.set("n", [[<Leader>`]], [[I```{r}<CR><CR>```<esc>kI]], opts)
vim.keymap.set("n", [[<Leader>ck]], [[:lua jump("^```{", 1, '')<CR>]], opts)
vim.keymap.set("n", [[<Leader>bk]], [[:lua jump("^```{", 1, 'b')<CR>]], opts)
vim.keymap.set("i", [[;`]], [[<CR>```{r}<CR><CR>```<esc>kI]], opts)
-- Zotcite path
vim.cmd.noreabbrev(
    "zotcite "
    .. os.getenv("HOME")
    .. "/.local/share/nvim/plugged/zotcite/python3/zotref.py"
)

require("nvim-surround").buffer_setup({
    surrounds = {
        -- HTML comment, used in Rmarkdown
        ["<!--"] = {
            add = { "<!--", "-->" },
            find = function()
                return require("nvim-surround.textobjects").get_selection(
                    "<!--"
                )
            end,
            delete = "^(<!-- ?)().-( ?-->)()$",
            change = {
                target = "^(<!-- ?)().-( ?-->)()$",
            },
        },
        ["-->"] = {
            add = { "<!--", "-->" },
            find = function()
                return require("nvim-surround.textobjects").get_selection("-->")
            end,
            delete = "^(<!-- ?)().-( ?-->)()$",
            change = {
                target = "^(<!-- ?)().-( ?-->)()$",
            },
        },
    },
    aliases = {
        ["c"] = "-->",
    },
})
