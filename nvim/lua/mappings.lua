local km = vim.keymap
local opts = { noremap = true, silent = true }
local utils = U.utils
local telescope = require("telescope.builtin")

local add_key = function(tbl, key, value)
    tbl[key] = value
    return tbl
end

local add_opts = function(value)
    return add_key(opts, "desc", value)
end

-- Diagnostics
km.set(
    "n",
    "<space>e",
    vim.diagnostic.open_float,
    add_opts("Open diagnostic float")
)
km.set("n", "[d", vim.diagnostic.goto_prev, add_opts("Go to prev diagnostic"))
km.set("n", "]d", vim.diagnostic.goto_next, add_opts("Go to next diagnostic"))
km.set(
    "n",
    "<space>q",
    vim.diagnostic.setloclist,
    add_opts("Set diagnostic loclist")
)

-- Terminal mappings
-- Repeat last terminal command. See https://vi.stackexchange.com/questions/21449/send-keys-to-a-terminal-buffer/21466
km.set({ "n" }, "<leader>!!", function()
    U.terminal.term_exec("\x1b\x5b\x41")
end, { desc = "Repeat last terminal command" })
-- Toggle terminal
km.set(
    { "n", "v" },
    "<leader>tt",
    U.terminal.term_toggle,
    { desc = "Toggle terminal window" }
)
-- Put in last window
km.set({ "n", "v" }, "<leader>p", function()
    utils.win_put(nil, vim.v.register)
end, add_opts("Put in last window"))
-- Write, then repeat last command
km.set({ "n", "v" }, "<leader>w", function()
    vim.cmd.write()
    vim.cmd.normal("@:")
end, add_opts("Write, then repeat last command"))
-- Send line under cursor to terminal
km.set({ "n" }, "<Leader>sl", function()
    U.terminal.term_exec(vim.api.nvim_get_current_line())
end, opts)
-- Interact with terminal buffer
km.set(
    { "n" },
    "<Leader>te",
    U.terminal.term_edit,
    add_opts("Open terminal window")
)

-- Visual selection to terminal
-- km.set({ "v" }, "<Leader>ts", function()
--     U.terminal.term_exec(vim.fn.getreg("*"))
-- end, opts)

km.set({ "n", "v" }, "<Leader>ts", function()
    U.terminal.term_exec(U.buffer.yank_visual())
end, opts)

-- Scroll last window of any type
km.set({ "n", "v" }, "<S-PageUp>", function()
    utils.win_exec("normal 3k", U.recents["window"])
end, add_opts("Scroll last window up"))

km.set({ "n", "v" }, "<S-PageDown>", function()
    utils.win_exec("normal 3j", U.recents["window"])
end, add_opts("Scroll last window down"))

-- Scroll last terminal window up-down
km.set({ "n", "v" }, "<C-PageDown>", function()
    if term_state ~= nil and term_state["last_terminal_win_id"] ~= nil then
        utils.win_exec("normal 3j", term_state["last_terminal_win_id"])
    end
end, add_opts("Scroll last terminal window down"))
km.set({ "n", "v" }, "<C-PageUp>", function()
    if term_state ~= nil and term_state["last_terminal_win_id"] ~= nil then
        utils.win_exec("normal 3k", term_state["last_terminal_win_id"])
    end
end, add_opts("Scroll last terminal window up"))
--
--all these to scroll window by position up/down
-- TODO put in for loop
km.set({ "n" }, "<Leader>kk", function()
    utils.win_exec("normal k", "k")
end, add_opts("Scroll upper window up"))
km.set({ "n" }, "<Leader>kj", function()
    utils.win_exec("normal j", "k")
end, add_opts("Scroll upper window down"))
km.set({ "n" }, "<Leader>lk", function()
    utils.win_exec("normal k", "l")
end, add_opts("Scroll top window right"))
km.set({ "n" }, "<Leader>lj", function()
    utils.win_exec("normal j", "l")
end, add_opts("Scroll right window down"))
km.set({ "n" }, "<Leader>jk", function()
    utils.win_exec("normal k", "j")
end, add_opts("Scroll"))
km.set({ "n" }, "<Leader>jj", function()
    utils.win_exec("normal j", "j")
end, add_opts("Scroll lower window down"))
km.set({ "n" }, "<Leader>hk", function()
    utils.win_exec("normal k", "h")
end, add_opts("Scroll left window up"))
km.set({ "n" }, "<Leader>hj", function()
    utils.win_exec("normal j", "h")
end, add_opts("Scroll left window down"))

-- Quit windows in direction, if it exists
local ignore_single = function(keys, dir)
    utils.win_exec(keys, dir, true)
end
km.set({ "n", "v" }, "<Leader>kq", function()
    ignore_single("q", "k")
end, add_opts("Close window above"))
km.set({ "n", "v" }, "<Leader>hq", function()
    ignore_single("q", "h")
end, add_opts("Close window left"))
km.set({ "n", "v" }, "<Leader>lq", function()
    ignore_single("q", "l")
end, add_opts("Close window right"))
km.set({ "n", "v" }, "<Leader>jq", function()
    ignore_single("q", "j")
end, add_opts("Close window below"))
-- Enter arbitrary command
km.set({ "n", "v" }, "<Leader>wc", function()
    U.utils.win_exec(
        "normal " .. vim.fn.input("Command: "),
        vim.fn.input("Window: ")
    )
end, add_opts("Execute Normal command in chosen window"))

-- Set up terminal
km.set(
    { "n" },
    "<Leader>te",
    U.terminal.term_setup,
    add_opts("Activate terminal window")
)

-- FZF finding
-- km.set({ "i", "c" }, "<C-x><C-f>", function()
--     vim.fn["fzf#vim#complete#path"]("rg --files")
-- end, { noremap = true, silent = true, expr = true })

-- Tabs & navigation
km.set({ "n", "v" }, "<Leader>nt", vim.cmd.tabnew, add_opts("New tab"))
km.set({ "n", "v" }, "<Leader>to", vim.cmd.tabonly, add_opts("Tab only"))
km.set({ "n", "v" }, "<Leader>tc", vim.cmd.tabclose, add_opts("Close tab"))
km.set({ "n", "v" }, "<Leader>tm", vim.cmd.tabmove, add_opts("Move tab"))
km.set({ "n", "v" }, "<Leader>tn", vim.cmd.tabnext, add_opts("Next tab"))
km.set({ "n", "v" }, "<Leader>tl", vim.cmd.tabprev, add_opts("Previous tab"))

km.set({ "n", "v" }, "<Leader>[", ":cprev<CR>", add_opts("Previous error"))
km.set({ "n", "v" }, "<Leader>]", ":cnext<CR>", add_opts("Next error"))

-- Splits
km.set(
    { "n", "v" },
    "<Leader>h",
    ":<C-u>split<CR>",
    add_opts("Horizontal split")
)
km.set(
    { "n", "v" },
    "<Leader>v",
    ":<C-u>vsplit<CR>",
    add_opts("Vertical split")
)

km.set("n", "cc", '"_cc', opts)
km.set({ "n" }, "<Leader>q", vim.cmd.quit, add_opts("Quit"))
km.set({ "n" }, "<Leader>w", vim.cmd.write, add_opts("Write"))
-- Quit and save all writeable buffers
km.set({ "n" }, "<Leader>qa", function()
    vim.cmd("wa")
    vim.cmd("qa")
end, { desc = "Quit and save all buffers" })

-- From https://vi.stackexchange.com/questions/21449/send-keys-to-a-terminal-buffer/21466

-- Easier window switching
local window = utils.t("<C-w>")
local chars = { "h", "j", "k", "l" }
for _, char in ipairs(chars) do
    km.set({ "n" }, "<Tab>" .. char, function()
        vim.cmd.normal(window .. char)
    end, opts)
    local upper = string.upper(char)
    km.set(
        { "n" },
        "<Tab>" .. upper,
        "<C-w>" .. upper,
        add_opts("Switch window (" .. char .. ")")
    )
end

--Easier window manipulation
km.set({ "n" }, "<Tab>+", "<C-w>+", add_opts("Increase window height"))
km.set({ "n" }, "<Tab>-", "<C-w>-", add_opts("Decrease window height"))
km.set({ "n" }, "<Tab><", function()
    utils.repeat_cmd("wincmd <", vim.v.count1)
end, { desc = "Contract window left" })
km.set({ "n" }, "<Tab>>", function()
    utils.repeat_cmd("wincmd >", vim.v.count1)
end, { desc = "Expand window right" })
km.set({ "n", "v" }, "<Tab>_", "<C-w>_", add_opts("Increase window height"))
km.set({ "n", "v" }, "<Tab><bar>", "<C-w><bar>", opts)
km.set({ "n", "v" }, "<Tab>=", "<C-w>=", add_opts("Expand window right"))

-- Spelling remap suggested by https://stackoverflow.com/questions/19072561/spellcheck-entire-file-in-vim
km.set({ "n", "v" }, "<k5>", "z=", add_opts("Suggest correct spellings"))
km.set({ "n", "v" }, "<k1>", "[s", add_opts("Find next misspelling"))
km.set({ "n", "v" }, "<k3>", "]s", add_opts("Find last misspelling"))
km.set({ "n", "v" }, "<k8>", "zg", add_opts("Add new word to spellfile"))
km.set({ "n", "v" }, "<k9>", "zug", add_opts("Remove word from spellfline"))

-- init.lua access
km.set({ "n", "v" }, "<Leader>s", utils.refresh)
km.set({ "n", "v" }, "<Leader>ev", function()
    vim.cmd.split("$MYVIMRC")
end, add_opts("Open vim config file for editing"))
km.set({ "n", "v" }, "<Leader>sv", function()
    vim.cmd.source("$MYVIMRC")
end, add_opts("Re-run Vim config file"))
km.set({ "n", "v" }, "<Space>", "<Space> <c-^>", opts)
km.set({ "n", "v" }, "<leader>tt", function()
    U.buffer.switch_to_buffer("term")
end, add_opts("Switch to an open terminal buffer"))

-- Default Telescope
km.set({ "n", "v" }, "<Leader>ff", function()
    telescope.find_files()
end, add_opts("Activate Telescope file finder"))
km.set({ "n", "v" }, "<Leader>fg", function()
    telescope.live_grep()
end, add_opts("Run Telescope live grep"))
km.set({ "n", "v" }, "<Leader>fb", function()
    telescope.buffers()
end, add_opts("Show open buffers"))
-- km.set({ "n" }, "<Leader>fh", function()
--     telescope.help_tags()
-- end, opts)
km.set({ "n", "v" }, "<Leader>rr", function()
    telescope.registers()
end, add_opts("Show Telescope registers"))
-- Results of previous picker
km.set({ "n", "v" }, "<Leader>pp", function()
    telescope.resume()
end, add_opts("Restore last active Telescope picker"))
km.set({ "n", "v" }, "<Leader>rl", function()
    telescope.lsp_references()
end, add_opts("Show LSP references"))
km.set({ "n", "v" }, "<Leader>ls", function()
    telescope.lsp_document_symbols()
end, add_opts("Show LSP document symbols"))
km.set({ "n", "v" }, "<Leader>ws", function()
    telescope.lsp_dynamic_workspace_symbols()
end, add_opts("Show LSP workspace symbols"))
km.set({ "n", "v" }, "<Leader>ld", function()
    telescope.diagnostics({ bufnr = 0 })
end, add_opts("Show LSP diagnostics for current buffer"))
km.set({ "n", "v" }, "<Leader>lw", function()
    telescope.diagnostics()
end, add_opts("Show LSP diagnostics for all buffers"))
km.set({ "n", "v" }, "<Leader>li", function()
    telescope.lsp_implementations()
end, add_opts("Show LSP implementations"))
km.set({ "n", "v" }, "<Leader>ld", function()
    telescope.lsp_definitions()
end, add_opts("Show LSP definitions"))
km.set(
    { "n", "v" },
    "<Leader>T",
    ":Telescope ",
    add_opts("Start Telescope command")
)

local telescope_menu = utils.table_menu(telescope, "Select picker: ")
km.set(
    { "n", "v" },
    "<Leader>tm",
    telescope_menu,
    add_opts("Select Telescope picker")
)

--
-- Paste-replace
km.set({ "n" }, "<Leader>p", '"_d$p', add_opts("Paste with replace right"))
km.set({ "n" }, "<Leader>P", '"_d$P', add_opts("Paste with replace left"))

-- Directory switching
km.set({ "n", "v" }, "<Leader>cd", function()
    vim.cmd("silent cd %:p:h")
    vim.cmd.pwd()
end, add_opts("Change overall directory to buffer directory"))
km.set({ "n", "v" }, "<Leader>lcd", function()
    vim.cmd("silent lcd %:p:h | pwd")
    --vim.cmd.pwd()
end, add_opts("Change window directory to buffer directory"))

-- Send changes to void register
vim.api.nvim_set_keymap("n", "c", '"_c', add_opts("Change text"))
vim.api.nvim_set_keymap("n", "C", '"_C', add_opts("Change line"))

-- Delete next or previous occurrence of string
km.set({ "n" }, "<Leader>zz", function()
    U.buffer.alter_closest("")
end, add_opts("Delete next patttern occurrence"))
km.set({ "n" }, "<Leader>ZZ", function()
    U.buffer.alter_closest("b")
end, add_opts("Delete previous pattern occurrence"))
km.set({ "n" }, "<Leader>zr", function()
    U.buffer.alter_closest("", true)
end, add_opts("Replace next pattern occurrence"))
km.set({ "n" }, "<Leader>Zr", function()
    U.buffer.alter_closest("b", true)
end, add_opts("Replace previous pattern occurrence"))

-- Force line to 80 characters by inserting newlines
km.set(
    { "n", "v" },
    "<leader>fl",
    [[:s/\%>80v,\zs\s*\ze/\re  /g<CR>]],
    add_opts("Insert newlines to force line to 80 characters")
)

-- Yank from terminal
km.set({ "n" }, "<Leader>ty", function()
    vim.fn.win_execute(term_state["last_terminal_win_id"], "normal 0ElvGy")
end, add_opts("Yank from terminal"))

km.set(
    { "n", "v" },
    "<Leader>nj",
    utils.no_jump,
    add_opts("Execute normal command without moving cursor")
)

-- Blank line above/below in insert move
vim.api.nvim_set_keymap(
    "i",
    ";o",
    "<Esc>o",
    add_opts("Insert blank line above")
)
vim.api.nvim_set_keymap(
    "i",
    ";O",
    "<Esc>O",
    add_opts("Insert blank line below")
)

km.set({ "t" }, "<Esc>", "<C-\\><C-n>", add_opts("Leave terminal mode"))
--Terminal pasting
km.set({ "t" }, "<C-p>", "<C-\\><C-n>pi", add_opts("Paste in terminal"))

-- Terminal paste most recent filename
km.set({ "t" }, "<C-t>", [["'" . expand("#:p" . v:count1) . "'"]], {
    desc = "Paste most recent filename in terminal",
    noremap = true,
    silent = true,
    expr = true,
})
-- Put text in next free register
-- km.set({ "n" }, "<leader>sr", function()
--     utils.next_free_register(nil, nil)
-- end, opts)

-- Buffer switch
km.set(
    { "n", "v" },
    "<Leader>bn",
    vim.cmd.bnext,
    { desc = "Switch to next buffer" }
)
km.set(
    { "n", "v" },
    "<Leader>bp",
    vim.cmd.brevious,
    { desc = "Switch to previous buffer" }
)

-- Replace word under cursor with choice throughout buffer
km.set({ "n", "v" }, "<Leader>rw", function()
    vim.cmd(
        "%s/"
        .. vim.fn.expand("<cword>")
        .. "/"
        .. vim.fn.input("Replacement: ")
        .. "/g"
    )
end, add_opts("Replace word under cursor with choice throughout buffer"))

km.set({ "n", "v" }, "<Leader>ty", function()
    U.terminal.term_exec(vim.fn.getreg("+"))
end, add_opts("Paste clipboard to terminal"))
-- R pipe
km.set({ "t" }, "++", "<Space><bar>><Space>", add_opts("Insert R pipe"))

-- Repeat last command
vim.api.nvim_set_keymap(
    "n",
    "!!",
    "@:<CR>",
    add_opts("Repeat last Normal command")
)

-- From https://www.reddit.com/r/neovim/comments/rfrgq5/is_it_possible_to_do_something_like_his_on/
-- Increase numbers in visual
km.set(
    { "v" },
    "J",
    ":m '>+1<CR>gv=gv",
    add_opts("Increment numbers in visual selection")
)

km.set({ "n", "v" }, "<Leader>nn", function()
    utils.range_command(vim.fn.input("Normal command: "))
end)
km.set({ "n", "v" }, "<Leader>Nn", function()
    utils.range_command(vim.fn.input("Normal command: "), nil, true)
end)

--TODO fix
km.set({ "v" }, "*", function()
    U.buffer.visual_search("/")
end, add_opts("Visual search up"))
km.set({ "v" }, "#", function()
    U.buffer.visual_search("?")
end, add_opts("Visual search down"))

--Pairs
km.set({ "n", "v" }, "<Leader>em", function()
    vim.cmd.Embrace()
end, opts)

-- Toggle LSP log level
km.set("n", "<Leader>lo", function()
    if require("vim.lsp.log").get_level() ~= "DEBUG" then
        vim.lsp.set_log_level("DEBUG")
    else
        vim.lsp.set_log_level("WARN")
    end
end, add_opts("Toggle LSP log level"))
--
-- Copy messages to clipboard
km.set({ "n" }, "<leader>mm", function()
    vim.fn.setreg("+", vim.cmd.messages())
end, { silent = true, desc = "Copy Vim messages to clipboard" })

--Quote-surround in insert
-- km.set({ "i" }, "<C-k>", function()
--     vim.cmd.normal([[ysiw"]])
-- end)
km.set({ "i" }, "<C-b>", function()
    vim.cmd.stopinsert()
    vim.cmd.normal('"_diw')
    vim.cmd.normal("`^l")
    vim.cmd.normal("i")
end, add_opts("Delete word right of cursor"))
km.set({ "i" }, "<Alt-b>", function()
    vim.cmd.stopinsert()
    vim.cmd.normal('W"_diW')
    vim.cmd.normal("`^l")
    vim.cmd.normal("i")
end, add_opts("Delete WORD right of cursor"))

-- Insert mode: delete entire word or WORD under cursor
-- TODO fix
km.set({ "i" }, "<C-d>", function()
    vim.cmd.stopinsert()
    vim.cmd.normal('"_diw')
    vim.cmd.normal("`^l")
    vim.cmd.normal("i")
end, add_opts("Delete word under cursor"))
km.set({ "i" }, "<ALT-d>", function()
    vim.cmd.stopinsert()
    vim.cmd.normal('"_diW')
    vim.cmd.normal("`^l")
    vim.cmd.normal("i")
end, add_opts("Delete WORD under cursor"))

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
km.set(
    { "n", "v" },
    "<leader>gs",
    "<cmd>Telescope grep_string<CR>",
    { desc = "Telescope string grep" }
)
km.set(
    { "n", "v" },
    "<leader>of",
    "<cmd>Telescope oldfiles<CR>",
    { desc = "Telescope old files" }
)
km.set(
    { "n", "v" },
    "<leader>sh",
    "<cmd>Telescope search_history<CR>",
    { desc = "Telescope search history" }
)
km.set(
    { "n", "v" },
    "<leader>qf",
    "<cmd>Telescope quickfix<CR>",
    { desc = "Telescope quickfix list" }
)
km.set(
    { "n", "v" },
    "<leader>hl",
    "<cmd>Telescope highlights<CR>",
    { desc = "Telescope highlight" }
)
km.set(
    { "n", "v" },
    "<leader>cb",
    "<cmd>Telescope current_buffer_fuzzy_find<CR>",
    { desc = "Telescope fuzzy find in current buffer" }
)
-- Choose from menu of LSP options
km.set(
    { "n", "v" },
    "<leader>cp",
    utils.choose_picker,
    { desc = "Select Telescope picker from menu" }
)

-- Swap, terminal-send operators
km.set(
    { "n", "v" },
    "<C-s>",
    U.operator.term_motion,
    { expr = true, desc = "Send selection to terminal" }
)
km.set(
    { "n", "v" },
    "<C-j>",
    U.operator.swap,
    { expr = true, desc = "Mark text for swapping" }
)
km.set({ "n", "v" }, "<C-m>", U.operator.link_wiki, { expr = true })

-- Toggle DAP interface
km.set({ "v" }, "<C-e>", function()
    require("dapui").eval()
end, add_opts("Toggle DAP interface"))
