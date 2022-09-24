vim.bo.tabstop = 2
local inline_send = function()
    if not os.getenv("NVIMR_ID") then
        print("Nvim-R is not running")
        return
    end
    vim.cmd("RSend " .. vim.fn.getreg("z"))
end
--My utility functions
inline_send = M.with_register(M.with_position(inline_send),"z")

local opts = { noremap = true, silent = true, buffer = true }
vim.keymap.set("n", [[\kk]], inline_send, opts)
vim.keymap.set("i", [[--]], [[<Space><-<Space>]], opts)
vim.keymap.set("i", [[;fun]], [[<Space><- function(){<esc>o}<esc>kf)i]], opts)
vim.keymap.set("i", [[++]], [[<Space><bar>><Space>]], opts)
vim.keymap.set(
    "n",
    [[<leader>pd]],
    [[^yiWoprint(paste("<C-o>p<space>=",<space><C-o>p))<Esc>k^]],
    opts
)

vim.keymap.set(
    "n",
    [[<leader>ss]],
    [[execute "RSend source('" . expand('%:p') . "')"]],
    opts
)

vim.keymap.set(
    "n",
    [[<leader>ss]],
    [[execute "RSend source('" . expand('%:p') . "')"]],
    opts
)
vim.keymap.set("n", [[<leader>p-]], [[ d$k$bdaWj]], opts)
--  Delete pipeline - proud of this one
vim.keymap.set(
    { "n", "v" },
    [[<leader>dp]],
    [[:s/\v\s*((\|\>)|(\%\>\%))\s*(\_.^[^`].*((\|\>)|(\%\>\%))\s*)*(\_.^.+$)?/<CR>]],
    opts
)

--Break substrings after commas into new lines
vim.cmd([[autocmd! VimResized * vim.g.R_Rconsole_width = winwidth(0) / 4]])
vim.cmd([[
inoreabbrev T TRUE
inoreabbrev FA FALSE
]])


--vim.b.ale_set_balloons = 1
--vim.b.ale_change_sign_column_color = 1
--vim.b.ale_set_highlights = 1
--vim.b.ale_virtualtext_cursor = 1
