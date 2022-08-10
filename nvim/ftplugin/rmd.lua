require("abbrev")
dofile(vim.api.nvim_get_runtime_file("ftplugin/r.lua", false)[1])
dofile(vim.api.nvim_get_runtime_file("ftplugin/tex.lua", false)[1])
dofile(vim.api.nvim_get_runtime_file("ftplugin/md.lua", false)[1])

local opts = { noremap = true, silent = true, buffer = true }

vim.keymap.set("n", [[\kk]], [[:lua M.inline_send()<CR>]], opts)
vim.keymap.set("n", [[<leader>`]], [[I```{r}<CR><CR>```<esc>kI]], opts)
vim.keymap.set("n", [[<Leader>ck]], [[:lua jump("^```{", 1, '')<CR>]], opts)
vim.keymap.set("n", [[<Leader>bk]], [[:lua jump("^```{", 1, 'b')<CR>]], opts)
vim.keymap.set("i", [[;`]], [[<CR>```{r}<CR><CR>```<esc>kI]], opts)
-- Zotcite path
vim.cmd(
    [[noreabbrev zotcite '/home/rheslin/.local/share/nvim/plugged/zotcite/python3/zotref.py']]
)
require("nvim-surround").buffer_setup({
    surrounds = {
        -- HTML comment
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
