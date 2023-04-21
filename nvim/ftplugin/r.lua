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
km = vim.keymap

km.set("n", [[\kk]], inline_send, opts)
km.set("i", [[--]], [[<Space><-<Space>]], opts)
km.set("i", [[++]], [[<Space><bar>><Space>]], opts)
km.set(
    "n",
    [[<leader>pd]],
    [[^yiWoprint(paste("<C-o>p<space>=",<space><C-o>p))<Esc>k^]],
    opts
)

km.set(
    "n",
    [[<leader>ss]],
    [[execute "RSend source('" . expand('%:p') . "')"]],
    opts
)

km.set("n", [[<leader>p-]], [[ d$k$bdaWj]], opts)
--  Delete pipeline - proud of this one, kind of
km.set(
    { "n", "v" },
    [[<leader>dp]],
    [[:s/\v\s*((\|\>)|(\%\>\%))\s*(\_.^[^`].*((\|\>)|(\%\>\%))\s*)*(\_.^.+$)?/<CR>]],
    opts
)
-- Clear R console after failure
km.set({ "n" }, "\\cl", ":RSend 0<CR>", opts)
km.set({ "n" }, "\\cq", ":RSend Q<CR>", opts)
km.set({ "n" }, "\\ck", ':RSend .. U.t("<C-c>") <CR>', opts)
km.set({ "n" }, "<Leader>s", ":w <bar> source %<CR>", opts)
-- Give info on R objects
km.set({ "n" }, "\ra", function()
    U.r_exec("args")
end, opts)
km.set({ "n" }, "\rt", function()
    U.r_exec("str")
end, opts)
km.set({ "n" }, "\re", function()
    vim.cmd("RSend " .. U.surround_string(vim.fn.getline("."), "(", ")"))
end, opts)
-- Save R history
km.set({ "n" }, "<Leader>tr", function()
    U.term_edit('savehistory("/tmp/history.txt")', "r")
end, opts)

--vim.cmd([[autocmd! VimResized * vim.g.R_Rconsole_width = winwidth(0) / 4]])
vim.cmd.inoreabbrev("T TRUE")
vim.cmd.inoreabbrev("FA FALSE")
