local opts = { noremap = true, silent = true }
local km = vim.keymap
local utils = U.utils

km.set("n", "<space>e", vim.diagnostic.open_float, opts)
km.set("n", "[d", vim.diagnostic.goto_prev, opts)
km.set("n", "]d", vim.diagnostic.goto_next, opts)
km.set("n", "<space>q", vim.diagnostic.setloclist, opts)

-- Terminal mappings
-- Repeat last terminal command. See https://vi.stackexchange.com/questions/21449/send-keys-to-a-terminal-buffer/21466
km.set({ "n" }, "<leader>!!", function()
    U.terminal.term_exec("\x1b\x5b\x41")
end, opts)
-- Toggle terminal
km.set({ "n", "v" }, "<leader>tt", U.terminal.term_toggle)
-- Put in last window
km.set({ "n", "v" }, "<leader>p", function()
    utils.win_put(nil, vim.v.register)
end, opts)
-- Write, then repeat last command
km.set({ "n", "v" }, "<leader>w", ":w | normal @:<CR>", opts)
-- Send line under cursor to terminal
km.set({ "n" }, "<Leader>sl", function()
    U.terminal.term_exec(vim.fn.getline("."))
end, opts)
-- Interact with terminal buffer
km.set({ "n" }, "<Leader>te", U.terminal.term_edit, opts)

-- Visual selection to terminal
km.set({ "v" }, "<Leader>ts", function()
    U.terminal.term_exec(vim.fn.getreg("*"))
end, opts)

-- Send line to terminal
km.set({ "n" }, "<Leader>ts", function()
    U.terminal.term_exec(U.buffer.yank_visual())
end, opts)

-- Scroll last window of any type
km.set({ "n", "v" }, "<S-PageUp>", function()
    utils.win_exec("normal 3k", U.recents["window"])
end, opts)
km.set({ "n", "v" }, "<S-PageDown>", function()
    utils.win_exec("normal 3j", U.recents["window"])
end, opts)

-- Scroll last terminal window up-down
km.set({ "n", "v" }, "<C-PageDown>", function()
    if term_state ~= nil then
        utils.win_exec("normal 3j", term_state["last_terminal_win_id"])
    end
end, opts)
km.set({ "n", "v" }, "<C-PageUp>", function()
    if term_state ~= nil then
        utils.win_exec("normal 3k", term_state["last_terminal_win_id"])
    end
end, opts)
--
--all these to scroll window by position up/down
km.set({ "n" }, "<Leader>kk", function()
    utils.win_exec("normal k", "k")
end, opts)
km.set({ "n" }, "<Leader>kj", function()
    utils.win_exec("normal j", "k")
end, opts)
km.set({ "n" }, "<Leader>lk", function()
    utils.win_exec("normal k", "l")
end, opts)
km.set({ "n" }, "<Leader>lj", function()
    utils.win_exec("normal j", "l")
end, opts)
km.set({ "n" }, "<Leader>jk", function()
    utils.win_exec("normal k", "j")
end, opts)
km.set({ "n" }, "<Leader>jj", function()
    utils.win_exec("normal j", "j")
end, opts)
km.set({ "n" }, "<Leader>hk", function()
    utils.win_exec("normal k", "h")
end, opts)
km.set({ "n" }, "<Leader>hj", function()
    utils.win_exec("normal j", "h")
end, opts)

-- Quit windows in direction
km.set({ "n", "v" }, "<Leader>kq", function()
    utils.win_exec("q", "k")
end, opts)
km.set({ "n", "v" }, "<Leader>hq", function()
    utils.win_exec("q", "h")
end, opts)
km.set({ "n", "v" }, "<Leader>lq", function()
    utils.win_exec("q", "l")
end, opts)
km.set({ "n", "v" }, "<Leader>jq", function()
    utils.win_exec("q", "j")
end, opts)
-- Enter arbitrary command
km.set({ "n", "v" }, "<Leader>wc", function()
    U.utils.win_exec(
        "normal " .. vim.fn.input("Command: "),
        vim.fn.input("Window: ")
    )
end, opts)

-- Set up terminal
km.set({ "n" }, "<Leader>te", U.terminal.term_setup, opts)

-- Add line above/below without leaving Normal
km.set({ "n" }, "<Leader>o", "o<Esc>k", opts)
km.set({ "n" }, "<Leader>O", "O<Esc>j", opts)

-- FZF finding
km.set(
    { "i" },
    "<c-x><c-f>",
    'fzf#vim#complete#path("rg --files")',
    { noremap = true, silent = true, expr = true }
)
km.set(
    { "c" },
    "<c-x><c-f>",
    'fzf#vim#complete#path("rg --files")',
    { noremap = true, silent = true, expr = true }
)

-- Tabs & navigation
km.set({ "n" }, "<Leader>nt", ":tabnew<CR>", opts)
km.set({ "n" }, "<Leader>to", ":tabonly<CR>", opts)
km.set({ "n" }, "<Leader>tc", ":tabclose<CR>", opts)
km.set({ "n" }, "<Leader>tm", ":tabmove<CR>", opts)
km.set({ "n" }, "<Leader>tn", ":tabnext<CR>", opts)
km.set({ "n" }, "<Leader>tl", ":tabprev<CR>", opts)

km.set({ "n" }, "<Leader>]", ":cnext", opts)
km.set({ "n" }, "<Leader>[", ":cprev", opts)

-- Splits
km.set({ "n" }, "<Leader>h", ":<C-u>split<CR>", opts)

km.set("n", "cc", '"_cc', opts)
km.set({ "n" }, "<Leader>q", ":q<CR>", opts)
km.set({ "n" }, "<Leader>w", ":w<CR>", opts)
-- Quit and save all writeable buffers
km.set({ "n" }, "<Leader>qa", ":wa <bar> qa<CR>", opts)
-- From https://vi.stackexchange.com/questions/21449/send-keys-to-a-terminal-buffer/21466

-- Easier window switching
local window = utils.t("<C-w>")
local chars = { "h", "j", "k", "l" }
for _, char in ipairs(chars) do
    km.set({ "n" }, "<Tab>" .. char, function()
        vim.cmd.normal(window .. char)
    end, opts)
    local upper = string.upper(char)
    km.set({ "n" }, "<Tab>" .. upper, "<C-w>" .. upper, opts)
end

--Easier window manipulation
km.set({ "n" }, "<Tab>+", "<C-w>+", opts)
km.set({ "n" }, "<Tab>-", "<C-w>-", opts)
km.set({ "n" }, "<Tab><", function()
    utils.repeat_cmd("wincmd <", vim.v.count1)
end, opts)
km.set({ "n" }, "<Tab>>", function()
    utils.repeat_cmd("wincmd >", vim.v.count1)
end, opts)
km.set({ "n" }, "<Tab>_", "<C-w>_", opts)
km.set({ "n" }, "<Tab><bar>", "<C-w><bar>", opts)
km.set({ "n" }, "<Tab>=", "<C-w>=", opts)

-- Spelling remap suggested by https://stackoverflow.com/questions/19072561/spellcheck-entire-file-in-vim
vim.api.nvim_set_keymap("n", "<k5>", "z=", opts)
vim.api.nvim_set_keymap("n", "<k1>", "[s", opts)
vim.api.nvim_set_keymap("n", "<k3>", "]s", opts)
vim.api.nvim_set_keymap("n", "<k8>", "zg", opts)
vim.api.nvim_set_keymap("n", "<k9>", "zug", opts)

-- init.lua access
km.set({ "n", "v" }, "<Leader>s", utils.refresh)
km.set({ "n" }, "<Leader>ev", ":split $MYVIMRC<CR>", opts)
km.set({ "n" }, "<Leader>sv", ":source $MYVIMRC<CR>", { noremap = true })
km.set({ "n" }, "<space>", "<space> <c-^>", opts)
km.set({ "n" }, "<leader>tt", function()
    U.buffer.switch_to_buffer("term")
end, opts)

-- Default Telescope
km.set({ "n" }, "<Leader>ff", function()
    require("telescope.builtin").find_files()
end, opts)
km.set({ "n" }, "<Leader>fg", function()
    require("telescope.builtin").live_grep()
end, opts)
km.set({ "n" }, "<Leader>fb", function()
    require("telescope.builtin").buffers()
end, opts)
km.set({ "n" }, "<Leader>fh", function()
    require("telescope.builtin").help_tags()
end, opts)
km.set({ "n" }, "<Leader>rr", function()
    require("telescope.builtin").registers()
end, opts)
-- Results of previous picker
km.set({ "n" }, "<Leader>pp", function()
    require("telescope.builtin").resume()
end, opts)
km.set({ "n" }, "<Leader>rl", function()
    require("telescope.builtin").lsp_references()
end, opts)
km.set({ "n" }, "<Leader>ls", function()
    require("telescope.builtin").lsp_document_symbols()
end, opts)
km.set({ "n" }, "<Leader>ws", function()
    require("telescope.builtin").lsp_dynamic_workspace_symbols()
end, opts)
km.set({ "n" }, "<Leader>ld", function()
    require("telescope.builtin").diagnostics({ bufnr = 0 })
end, opts)
km.set({ "n" }, "<Leader>lw", function()
    require("telescope.builtin").diagnostics()
end, opts)
km.set({ "n" }, "<Leader>li", function()
    require("telescope.builtin").lsp_implementations()
end, opts)
km.set({ "n" }, "<Leader>ld", function()
    require("telescope.builtin").lsp_definitions()
end, opts)
km.set({ "n" }, "<Leader>T", ":Telescope ", opts)

local telescope_menu =
utils.table_menu(require("telescope.builtin"), "Select picker: ")
km.set({ "n", "v" }, "<Leader>tm", telescope_menu, opts)

--
--Knit rmarkdown - ugly as sin but works
-- km.set({ "n" }, "<Leader>kn", function()
--     U.knit(nil, true, true)
-- end, opts)
-- Paste-replace
km.set({ "n" }, "<Leader>p", '"_d$p', opts)
km.set({ "n" }, "<Leader>P", '"_d$P', opts)
-- Add line above/below ending with trailing character - good for lists of function args, etc.
km.set({ "n" }, "<Leader>ao", "$yl[pI", opts)
km.set({ "n" }, "<Leader>aO", "$yl]pI", opts)

-- Directory switching
km.set({ "n" }, "<Leader>cd", ":silent cd %:p:h | pwd<CR>", { noremap = true })
km.set(
    { "n" },
    "<Leader>lcd",
    ":silent lcd %:p:h | pwd<CR>",
    { noremap = true }
)
vim.api.nvim_set_keymap("n", "c", '"_c', opts)
vim.api.nvim_set_keymap("n", "C", '"_C', opts)

-- Surround register with quotes
km.set({ "n", "v" }, '<leader>"', function()
    utils.modify_register(utils.surround_string, "+", '"', '"')
end, opts)

-- Delete next or previous occurrence of string
km.set({ "n" }, "<Leader>zz", function()
    utils.alter_closest("")
end, opts)
km.set({ "n" }, "<Leader>ZZ", function()
    utils.alter_closest("b")
end, opts)
km.set({ "n" }, "<Leader>zr", function()
    utils.alter_closest("", true)
end, opts)
km.set({ "n" }, "<Leader>Zr", function()
    utils.alter_closest("b", true)
end, opts)

-- Force line to 80 characters by inserting newlines
km.set({ "n", "v" }, "<leader>fl", [[:s/\%>80v,\zs\s*\ze/\re  /g<CR>]], opts)

-- Yank from terminal
km.set({ "n" }, "<Leader>ty", function()
    vim.fn.win_execute(term_state["last_terminal_win_id"], "normal 0ElvGy")
end, opts)

km.set({ "n", "v", "i" }, "<Leader>nj", utils.no_jump, opts)

km.set({ "i" }, ";n", "<C-o>o<Esc>4jI", opts)
-- Blank line above/below in insert move
vim.api.nvim_set_keymap("i", ";o", "<Esc>o", opts)
vim.api.nvim_set_keymap("i", ";O", "<Esc>O", opts)

km.set({ "t" }, "<Esc>", "<C-\\><C-n>", opts)
--Terminal pasting
km.set({ "t" }, "<C-p>", "<C-\\><C-n>pi", opts)

-- Terminal paste most recent filename
km.set(
    { "t" },
    "<C-t>",
    [["'" . expand("#:p" . v:count1) . "'"]],
    { noremap = true, silent = true, expr = true }
)
-- Put text in next free register
km.set({ "n" }, "<leader>sr", function()
    utils.next_free_register(nil, nil)
end, opts)

-- https://vim.fandom.com/wiki/Keystroke_Saving_Substituting_and_Searching
--vim.api.nvim_set_keymap('v', '/ y:execute', '"/".escape(@",'[]/\.*')<CR>', {noremap = true, silent = true})
--vim.api.nvim_set_keymap('v', '<F4> y:execute', '"%s/".escape(@",'[]/')."//gc"<Left><Left><Left><Left>', {noremap = true, silent = true})

-- Buffer switch
km.set({ "n" }, "<Leader>bn", ":bnext<CR>", opts)
km.set({ "n" }, "<Leader>bp", ":bprevious<CR>", opts)

-- Replace
km.set(
    { "n" },
    "<Leader>rw",
    ':call execute("%s/" . expand("<cword>") . "/" . input("Replacement: ") . "/g")<CR>',
    opts
)

--Terminal yanking
km.set({ "n" }, "<Leader>ty", function()
    U.terminal.term_exec(vim.fn.getreg("+"))
end, opts)
km.set({ "v" }, "<Leader>ty", function()
    U.terminal.term_exec(U.buffer.yank_visual("+"))
end, opts)
-- R pipe
km.set({ "t" }, "++", "<Space><bar>><Space>", opts)

-- Repeat last command
vim.api.nvim_set_keymap("n", "!!", "@:<CR>", opts)

-- From https://www.reddit.com/r/neovim/comments/rfrgq5/is_it_possible_to_do_something_like_his_on/
-- Increase numbers in visual
km.set({ "v" }, "J", ":m '>+1<CR>gv=gv", opts)

km.set({ "n", "v" }, "<Leader>nn", function()
    utils.range_command(vim.fn.input("normal command: "))
end)
km.set({ "n", "v" }, "<Leader>Nn", function()
    utils.range_command(vim.fn.input("normal command: "), nil, true)
end)
km.set({ "v" }, "*", function()
    U.buffer.visual_search("/")
end, opts)
km.set({ "v" }, "#", function()
    U.buffer.visual_search("?")
end, opts)

--Pairs
-- Transpose function arguments
-- These complex mappings copied from https://vim.fandom.com/wiki/Swapping_characters,_words_and_lines
km.set(
    { "n" },
    "gw",
    [[_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><c-o><c-l>:nohlsearch<CR>]],
    opts
)
km.set(
    { "n" },
    "gl",
    [["_yiw?\w\+\_W\+\%#<CR>:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><c-o><c-l>:nohlsearch<CR>]],
    opts
)
km.set(
    { "n" },
    "gl",
    [["_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><c-o>/\w\+\_W\+<CR><c-l>:nohlsearch<CR>]],
    opts
)
vim.api.nvim_set_keymap("n", "g{", "dap}p{", opts)
km.set({ "n" }, "<Leader>tp", 't,bmz"ydwwdw"yP`zPb', opts)
km.set({ "n" }, "<Leader>tP", 'bdwmzF,b"ydww', opts)
km.set({ "n" }, "<Leader>em", function()
    vim.cmd.Embrace()
end, opts)

-- Toggle LSP log level
km.set("n", "<Leader>lo", function()
    if require("vim.lsp.log").get_level() ~= "DEBUG" then
        vim.lsp.set_log_level("DEBUG")
    else
        vim.lsp.set_log_level("WARN")
    end
end, opts)
--
km.set({ "i", "n", "v" }, "<C-%>>", function()
    utils.match_paren()
end, { silent = true })

-- Copy messages
km.set({ "n" }, "<leader>mm", function()
    vim.fn.setreg("+", vim.fn.execute("messages"))
end, { silent = true })

--Insert mode: delete word or WORD right of cursor
km.set({ "i" }, "<C-k>", function()
    vim.cmd.normal([[ysiw"]])
end)
km.set({ "i" }, "<C-b>", function()
    vim.cmd.normal("w")
    vim.cmd.normal("dw")
    vim.cmd.normal("`^")
    vim.cmd.normal("i")
end, opts)
km.set({ "i" }, "<C-B>", function()
    vim.cmd.normal("W")
    vim.cmd.normal("dW")
    vim.cmd.normal("`^")
    vim.cmd.normal("i")
end, opts)
-- Insert mode: delete entire word or WORD under cursor
km.set({ "i" }, "<C-d>", function()
    vim.cmd.normal("ciw")
    vim.cmd.normal("`^")
    vim.cmd.normal("i")
end, opts)
km.set({ "i" }, "<C-D>", function()
    vim.cmd.normal("ciW")
    vim.cmd.normal("`^")
    vim.cmd.normal("i")
end, opts)

-- Repeat motion
km.set("n", "gt", _G.__dot_repeat, { expr = true })
-- Print lines, take count
km.set(
    "n",
    "<leader>gt",
    "<ESC><CMD>lua _G.__dot_repeat(nil, true, true)<CR>",
    { expr = true }
)
km.set(
    "x",
    "gt",
    "<ESC><CMD>lua _G.__dot_repeat(vim.fn.visualmode(), false, true)<CR>"
)
--Collapse last paste with literal newlines
km.set("n", "<leader>jj", function()
    return utils.modify_register(function(x)
        return string.gsub(x, [=[\n]=], [=[\\n]=])
    end)
end)

-- Treesitter pickers
km.set({ "n", "v" }, "<leader>gs", "<cmd>Telescope grep_string<CR>")
km.set({ "n", "v" }, "<leader>of", "<cmd>Telescope oldfiles<CR>")
km.set({ "n", "v" }, "<leader>sh", "<cmd>Telescope search_history<CR>")
km.set({ "n", "v" }, "<leader>qf", "<cmd>Telescope quickfix<CR>")
km.set({ "n", "v" }, "<leader>hl", "<cmd>Telescope highlights<CR>")
km.set(
    { "n", "v" },
    "<leader>cb",
    "<cmd>Telescope current_buffer_fuzzy_find<CR>"
)
-- Choose from menu of LSP options
km.set({ "n", "v" }, "<leader>cp", utils.choose_picker)

-- Swap, terminal-send operators
km.set({ "n", "v" }, "<C-s>", U.operator.term_motion, { expr = true })
km.set({ "n", "v" }, "<C-j>", U.operator.swap, { expr = true })
km.set({ "n", "v" }, "<C-w>", U.operator.link_wiki, { expr = true })

-- Toggle DAP interface
km.set({ "v" }, "<C-e>", function()
    require("dapui").eval()
end)
