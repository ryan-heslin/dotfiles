local opts = { noremap = true, silent = true }
local km = vim.keymap
local utils = U.utils
local telescope = require("telescope.builtin")

-- Diagnostics
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
km.set({ "n", "v" }, "<leader>w", function()
    vim.cmd.write()
    vim.cmd.normal("@:")
end, opts)
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
local ignore_single = function(keys, dir)
    utils.win_exec(keys, dir, true)
end
km.set({ "n", "v" }, "<Leader>kq", function()
    ignore_single("q", "k")
end, opts)
km.set({ "n", "v" }, "<Leader>hq", function()
    ignore_single("q", "h")
end, opts)
km.set({ "n", "v" }, "<Leader>lq", function()
    ignore_single("q", "l")
end, opts)
km.set({ "n", "v" }, "<Leader>jq", function()
    ignore_single("q", "j")
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
km.set({ "i" }, "<C-x><C-f>", function()
    vim.fn["fzf#vim#complete#path"]("rg --files")
end, { noremap = true, silent = true, expr = true })
km.set({ "c" }, "<C-x><C-f>", function()
    vim.fn["fzf#vim#complete#path"]("rg --files")
end, { noremap = true, silent = true, expr = true })

-- Tabs & navigation
km.set({ "n" }, "<Leader>nt", ":tabnew<CR>", opts)
km.set({ "n" }, "<Leader>to", ":tabonly<CR>", opts)
km.set({ "n" }, "<Leader>tc", ":tabclose<CR>", opts)
km.set({ "n" }, "<Leader>tm", ":tabmove<CR>", opts)
km.set({ "n" }, "<Leader>tn", ":tabnext<CR>", opts)
km.set({ "n" }, "<Leader>tl", ":tabprev<CR>", opts)

km.set({ "n" }, "<Leader>]", ":cnext<CR>", opts)
km.set({ "n" }, "<Leader>[", ":cprev<CR>", opts)

-- Splits
km.set({ "n", "v" }, "<Leader>h", ":<C-u>split<CR>", opts)
km.set({ "n", "v" }, "<Leader>v", ":<C-u>vsplit<CR>", opts)

km.set("n", "cc", '"_cc', opts)
km.set({ "n" }, "<Leader>q", ":q<CR>", opts)
km.set({ "n" }, "<Leader>w", ":w<CR>", opts)
-- Quit and save all writeable buffers
km.set({ "n" }, "<Leader>qa", function()
    vim.cmd("wa")
    vim.cmd("qa")
end, opts)

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
km.set({ "n" }, "<Leader>ev", function()
    vim.cmd.split("$MYVIMRC")
end, opts)
km.set({ "n" }, "<Leader>sv", function()
    vim.cmd.source("$MYVIMRC")
end, opts)
km.set({ "n" }, "<Space>", "<Space> <c-^>", opts)
km.set({ "n" }, "<leader>tt", function()
    U.buffer.switch_to_buffer("term")
end, opts)

-- Default Telescope
km.set({ "n" }, "<Leader>ff", function()
    telescope.find_files()
end, opts)
km.set({ "n" }, "<Leader>fg", function()
    telescope.live_grep()
end, opts)
km.set({ "n" }, "<Leader>fb", function()
    telescope.buffers()
end, opts)
km.set({ "n" }, "<Leader>fh", function()
    telescope.help_tags()
end, opts)
km.set({ "n" }, "<Leader>rr", function()
    telescope.registers()
end, opts)
-- Results of previous picker
km.set({ "n" }, "<Leader>pp", function()
    telescope.resume()
end, opts)
km.set({ "n" }, "<Leader>rl", function()
    telescope.lsp_references()
end, opts)
km.set({ "n" }, "<Leader>ls", function()
    telescope.lsp_document_symbols()
end, opts)
km.set({ "n" }, "<Leader>ws", function()
    telescope.lsp_dynamic_workspace_symbols()
end, opts)
km.set({ "n" }, "<Leader>ld", function()
    telescope.diagnostics({ bufnr = 0 })
end, opts)
km.set({ "n" }, "<Leader>lw", function()
    telescope.diagnostics()
end, opts)
km.set({ "n" }, "<Leader>li", function()
    telescope.lsp_implementations()
end, opts)
km.set({ "n" }, "<Leader>ld", function()
    telescope.lsp_definitions()
end, opts)
km.set({ "n" }, "<Leader>T", ":Telescope ", opts)

local telescope_menu = utils.table_menu(telescope, "Select picker: ")
km.set({ "n", "v" }, "<Leader>tm", telescope_menu, opts)

--
-- Paste-replace
km.set({ "n" }, "<Leader>p", '"_d$p', opts)
km.set({ "n" }, "<Leader>P", '"_d$P', opts)

-- Directory switching
km.set({ "n", "v" }, "<Leader>cd", function()
    vim.cmd("silent cd %:p:h")
    vim.cmd.pwd()
end, { noremap = true })
km.set({ "n", "v" }, "<Leader>lcd", function()
    vim.cmd("silent lcd %:p:h | pwd")
    --vim.cmd.pwd()
end, { noremap = true })

-- Send changes to void register
vim.api.nvim_set_keymap("n", "c", '"_c', opts)
vim.api.nvim_set_keymap("n", "C", '"_C', opts)

-- Surround register with quotes
km.set({ "n", "v" }, '<leader>"', function()
    utils.modify_register(utils.surround_string, "+", '"', '"')
end, opts)

-- Delete next or previous occurrence of string
km.set({ "n" }, "<Leader>zz", function()
    U.buffer.alter_closest("")
end, opts)
km.set({ "n" }, "<Leader>ZZ", function()
    U.buffer.alter_closest("b")
end, opts)
km.set({ "n" }, "<Leader>zr", function()
    U.buffer.alter_closest("", true)
end, opts)
km.set({ "n" }, "<Leader>Zr", function()
    U.buffer.alter_closest("b", true)
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

-- Buffer switch
km.set({ "n", "v" }, "<Leader>bn", ":bnext<CR>", opts)
km.set({ "n", "v" }, "<Leader>bp", ":bprevious<CR>", opts)

-- Replace word under cursor with choice throughout buffer
km.set({ "n", "v" }, "<Leader>rw", function()
    vim.cmd(
        "%s/"
        .. vim.fn.expand("<cword>")
        .. "/"
        .. vim.fn.input("Replacement: ")
        .. "/g"
    )
end, opts)

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
    utils.range_command(vim.fn.input("Normal command: "))
end)
km.set({ "n", "v" }, "<Leader>Nn", function()
    utils.range_command(vim.fn.input("Normal command: "), nil, true)
end)
km.set({ "v" }, "*", function()
    U.buffer.visual_search("/")
end, opts)
km.set({ "v" }, "#", function()
    U.buffer.visual_search("?")
end, opts)

--Pairs
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
-- Copy messages to clipboard
km.set({ "n" }, "<leader>mm", function()
    vim.fn.setreg("+", vim.cmd.messages())
end, { silent = true })

--Insert mode: delete word or WORD right of cursor
km.set({ "i" }, "<C-k>", function()
    vim.cmd.normal([[ysiw"]])
end)
km.set({ "i" }, "<C-b>", function()
    vim.cmd.stopinsert()
    vim.cmd.normal("dw`^l")
    vim.cmd.normal("i")
end, opts)
km.set({ "i" }, "<Alt-b>", function()
    vim.cmd.stopinsert()
    vim.cmd.normal("WdW`^l")
    vim.cmd.normal("i")
end, opts)

-- Insert mode: delete entire word or WORD under cursor
km.set({ "i" }, "<C-d>", function()
    vim.cmd.stopinsert()
    vim.cmd.normal("ciw`^l")
    vim.cmd.normal("i")
end, opts)
km.set({ "i" }, "<ALT-d>", function()
    vim.cmd.stopinsert()
    vim.cmd.normal("ciW`^l")
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
km.set({ "n", "v" }, "<C-m>", U.operator.link_wiki, { expr = true })

-- Toggle DAP interface
km.set({ "v" }, "<C-e>", function()
    require("dapui").eval()
end)
