local opts = { noremap = true, silent = true, buffer = true }
local inline_send_impl = function()
    if not os.getenv("NVIMR_ID") then
        print("Nvim-R is not running")
        return
    end
    U.inline_send()
    vim.cmd("RSend " .. vim.fn.getreg("z"))
end

--My utility functions
local inline_send = U.with_register(U.with_position(inline_send_impl))
vim.bo.tabstop = 2

vim.keymap.set("n", [[\kk]], inline_send, opts)
vim.keymap.set("i", [[--]], [[<Space><-<Space>]], opts)
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

vim.keymap.set("n", [[<leader>p-]], [[ d$k$bdaWj]], opts)
--  Delete pipeline - proud of this one, kind of
vim.keymap.set(
    { "n", "v" },
    [[<leader>dp]],
    [[:s/\v\s*((\|\>)|(\%\>\%))\s*(\_.^[^`].*((\|\>)|(\%\>\%))\s*)*(\_.^.+$)?/<CR>]],
    opts
)

--vim.cmd([[autocmd! VimResized * vim.g.R_Rconsole_width = winwidth(0) / 4]])
vim.cmd.inoreabbrev("T TRUE")
vim.cmd.inoreabbrev("FA FALSE")
