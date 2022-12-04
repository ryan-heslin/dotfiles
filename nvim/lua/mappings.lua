vim.g.mapleader = ","
local opts = { noremap = true, silent = true }
local km = vim.keymap

-- Repeat last terminal command. See https://vi.stackexchange.com/questions/21449/send-keys-to-a-terminal-buffer/21466
km.set({ "n" }, "<Leader>!!", function()
    M.term_exec("\x1b\x5b\x41")
end, opts)
-- Put in last window
km.set({ "n", "v" }, "<leader>p", function()
    M.win_put(nil, vim.v.register)
end, opts)
-- Write, then repeat last command
km.set({ "n", "v" }, "<leader>w", ":w | normal @:<CR>", opts)
-- Send line under cursor to terminal
km.set({ "n" }, "<Leader>sl", function()
    M.term_exec(vim.fn.getline("."))
end, opts)
-- Interact with terminal buffer
km.set({ "n" }, "<Leader>te", M.term_edit, opts)

-- R history
km.set({ "n" }, "<Leader>tr", function()
    M.term_edit('savehistory("/tmp/history.txt")', "r")
end, opts)
-- Visual selection to terminal
km.set({ "v" }, "<Leader>ts", function()
    M.term_exec(vim.fn.getreg("*"))
end, opts)

-- Send line to terminal
km.set({ "n" }, "<Leader>ts", function()
    M.term_exec(vim.fn.getline("."))
end, opts)

-- Scroll last window of any type
km.set({ "n", "v" }, "<S-PageUp>", function()
    M.win_exec("normal 3k", recents["window"])
end, opts)
km.set({ "n", "v" }, "<S-PageDown>", function()
    M.win_exec("normal 3j", recents["window"])
end, opts)

-- Scroll last terminal window up-down
km.set({ "n", "v" }, "<C-PageDown>", function()
    if term_state ~= nil then
        M.win_exec("normal 3j", term_state["last_terminal_win_id"])
    end
end, opts)
km.set({ "n", "v" }, "<C-PageUp>", function()
    if term_state ~= nil then
        M.win_exec("normal 3k", term_state["last_terminal_win_id"])
    end
end, opts)
--
--all these to scroll window by position up/down
km.set({ "n" }, "<Leader>kk", function()
    M.win_exec("normal k", "k")
end, opts)
km.set({ "n" }, "<Leader>kj", function()
    M.win_exec("normal j", "k")
end, opts)
km.set({ "n" }, "<Leader>lk", function()
    M.win_exec("normal k", "l")
end, opts)
km.set({ "n" }, "<Leader>lj", function()
    M.win_exec("normal j", "l")
end, opts)
km.set({ "n" }, "<Leader>jk", function()
    M.win_exec("normal k", "j")
end, opts)
km.set({ "n" }, "<Leader>jj", function()
    M.win_exec("normal j", "j")
end, opts)
km.set({ "n" }, "<Leader>hk", function()
    M.win_exec("normal k", "h")
end, opts)
km.set({ "n" }, "<Leader>hj", function()
    M.win_exec("normal j", "h")
end, opts)

km.set({ "n", "v" }, "<Leader>kq", function()
    M.win_exec("q", "k")
end, opts)

km.set({ "n", "v" }, "<Leader>hq", function()
    M.win_exec("q", "h")
end, opts)

km.set({ "n", "v" }, "<Leader>lq", function()
    M.win_exec("q", "l")
end, opts)

km.set({ "n", "v" }, "<Leader>jq", function()
    M.win_exec("q", "j")
end, opts)

km.set({ "n", "v" }, "<Leader>wc", function()
    M.win_exec(
        "normal " .. vim.fn.input.M.t("Command: "),
        vim.fn.input("Window: ")
    )
end, opts)

km.set({ "n" }, "<Leader>te", "<cmd>vsplit<CR>l:terminal<CR>i", opts)

--vim.api.nvim_set_keymap('n', '<C-S>', ':let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>', {noremap = true, silent = true}
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
km.set({ "n" }, "<Leader>v", ":<C-u>vsplit<CR>", opts)
vim.api.nvim_set_keymap("n", "cc", '"_cc', opts)
km.set({ "n" }, "<Leader>q", ":q<CR>", opts)
km.set({ "n" }, "<Leader>w", ":w<CR>", opts)
km.set({ "n" }, "<Leader>qa", ":wa <bar> qa<CR>", opts)
-- From https://vi.stackexchange.com/questions/21449/send-keys-to-a-terminal-buffer/21466

-- Easier window switching
km.set({ "n" }, "<Tab>h", function()
    M.repeat_cmd("normal " .. M.t("<C-w>") .. "h", vim.v.count1)
end, opts)
km.set({ "n" }, "<Tab>j", function()
    M.repeat_cmd("normal " .. M.t("<C-w>") .. "j", vim.v.count1)
end, opts)
km.set({ "n" }, "<Tab>k", function()
    M.repeat_cmd("normal " .. M.t("<C-w>") .. "k", vim.v.count1)
end, opts)
km.set({ "n" }, "<Tab>l", function()
    M.repeat_cmd("normal " .. M.t("<C-w>") .. "l", vim.v.count1)
end, opts)

--Easier window manipulation
km.set({ "n" }, "<Tab>H", "<C-w>H", opts)
km.set({ "n" }, "<Tab>J", "<C-w>J", opts)
km.set({ "n" }, "<Tab>K", "<C-w>K", opts)
km.set({ "n" }, "<Tab>L", "<C-w>L", opts)

km.set({ "n" }, "<Tab>+", "<C-w>+", opts)
km.set({ "n" }, "<Tab>-", "<C-w>-", opts)
km.set({ "n" }, "<Tab><", function()
    M.repeat_cmd("wincmd >", vim.v.count1)
end, opts)
km.set({ "n" }, "<Tab>>", function()
    M.repeat_cmd("wincmd >", vim.v.count1)
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

-- Print output of Lua command
km.set({ "n" }, "<leader>lp", ":lua print(<C-r>)<CR>", opts)
-- vimrc access
km.set({ "n" }, "<Leader>ev", ":split $MYVIMRC<CR>", opts)
--:silent! try | write $MYVIMRC | catch  |  finally  |
km.set({ "n" }, "<Leader>sv", ":source $MYVIMRC<CR>", { noremap = true })
km.set({ "n" }, "<space>", "<space> <c-^>", opts)
km.set({ "n" }, "<leader>tt", function()
    M.switch_to_buffer("term")
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
km.set({ "n" }, "<Leader>ca", function()
    require("telescope.builtin").lsp_range_code_actions()
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
--
--Knit rmarkdown - ugly as sin but works
km.set({ "n" }, "<Leader>kn", function()
    M.knit(nil, true, true)
end, opts)
-- For easier copy-paste
km.set({ "n" }, "<Leader>y", '"+y', opts)
km.set({ "n" }, "<Leader>p", '"+p', opts)
-- Paste-replace
km.set({ "n" }, "<Leader>p", '"_d$p', opts)
km.set({ "n" }, "<Leader>P", '"_d$P', opts)
-- Add line above/below ending with trailing character - good for lists of function args, etc.
km.set({ "n" }, "<Leader>ao", "$yl[pI", opts)
km.set({ "n" }, "<Leader>aO", "$yl]pI", opts)

km.set({ "n" }, "<Leader>cd", ":silent cd %:p:h | pwd<CR>", { noremap = true })
km.set(
    { "n" },
    "<Leader>lcd",
    ":silent lcd %:p:h | pwd<CR>",
    { noremap = true }
)
vim.api.nvim_set_keymap("n", "c", '"_c', opts)
vim.api.nvim_set_keymap("n", "C", '"_C', opts)
-- Clear R console after failure
km.set({ "n" }, "\\cl", ":RSend 0<CR>", opts)
km.set({ "n" }, "\\cq", ":RSend Q<CR>", opts)
km.set({ "n" }, "\\ck", ':RSend .. M.t("<C-c>") <CR>', opts)
km.set({ "n" }, "<Leader>s", ":w <bar> source %<CR>", opts)

-- Give info on R objects
km.set({ "n" }, "\ra", function()
    M.r_exec("args")
end, opts)
km.set({ "n" }, "\rt", function()
    M.r_exec("str")
end, opts)
km.set({ "n" }, "\re", function()
    vim.cmd("RSend " .. M.surround_string(vim.fn.getline("."), "(", ")"))
end, opts)

km.set(
    { "n" },
    "<Leader>cv",
    ":lua vim.cmd[[%normal I<Space><Space><Space><Space> | normal ggG$y<Esc>]]",
    opts
)
-- Surround register with quotes
km.set({ "n", "v" }, '<leader>"', function()
    M.modify_register(M.surround_string, "+", '"', '"')
end, opts)

-- Strip surrounding function call
km.set({ "n" }, "<Leader>ds", "B/(<CR>bdiw%x``xi", opts)
-- Delete next or previous occurrence of string
km.set({ "n" }, "<Leader>zz", function()
    M.alter_closest("")
end, opts)
km.set({ "n" }, "<Leader>ZZ", function()
    M.alter_closest("b")
end, opts)
km.set({ "n" }, "<Leader>zr", function()
    M.alter_closest("", true)
end, opts)
km.set({ "n" }, "<Leader>Zr", function()
    M.alter_closest("b", true)
end, opts)

-- Force line to 80 characters by inserting newlines
km.set({ "n", "v" }, "<leader>fl", [[:s/\%>80v,\zs\s*\ze/\re  /g<CR>]], opts)

-- Yank from terminal
km.set({ "n" }, "<Leader>ty", function()
    vim.fn.win_execute(term_state["last_terminal_win_id"], "normal 0ElvGy")
end, opts)

-- Insert section headings below cursor
km.set({ "n" }, "<Leader>sen", ":<C-U>call functions#Sections(1)<CR>", opts)
km.set({ "n" }, "<Leader>sel", ':<C-U>call functions#Sections("a")<CR>', opts)

km.set({ "n", "v", "i" }, "<Leader>nj", M.no_jump, opts)

-- km.set(
--     { "n" },
--     "<Leader>pd",
--     '^yiWoprinM.t(paste("<C-o>p<space>=",<space><C-o>p))<Esc>k^',
--     opts
-- )
km.set({ "n" }, "<Leader>rs", function()
    vim.fn["UltiSnips#RefreshSnippets"]()
end, opts)

--Insert markdown link around previous word, pasting URL from clipboard
km.set({ "i" }, ";lk", '<Esc>Bi[<Esc>ea](<Esc>"+pA)<Space>', opts)
km.set({ "i" }, ";n", "<C-o>o<Esc>4jI", opts)
-- Copy comment character to new line below
km.set({ "i" }, ";#", "<Esc>^yWo<C-o>P<C-o>$<Space>", opts)
--Paste equation RHS on line below
km.set({ "i" }, ";eq", "<Esc>F=y$A\\<Esc>o&<Space><Esc>pF=", opts)
vim.api.nvim_set_keymap("i", ";o", "<Esc>o", opts)
vim.api.nvim_set_keymap("i", ";O", "<Esc>O", opts)

km.set({ "t" }, "<Esc>", "<C-\\><C-n>", opts)
--vim.api.nvim_set_keymap('t',  '<C-r>', "'<C-\\><C-n>' . nr2char(getchar()) . 'pi'", {noremap = true, silent = true, expr = true})
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
    M.next_free_register(nil, nil)
end, opts)

-- https://vim.fandom.com/wiki/Keystroke_Saving_Substituting_and_Searching
--vim.api.nvim_set_keymap('v', '/ y:execute', '"/".escape(@",'[]/\.*')<CR>', {noremap = true, silent = true})
--vim.api.nvim_set_keymap('v', '<F4> y:execute', '"%s/".escape(@",'[]/')."//gc"<Left><Left><Left><Left>', {noremap = true, silent = true})

-- Buffer switch
km.set({ "n" }, "<Leader>bn", ":bnext<CR>", opts)
km.set({ "n" }, "<Leader>bp", ":bprevious<CR>", opts)

-- Replace
-- TODO fix word replacement
km.set(
    { "n" },
    "<Leader>rw",
    ':call execute("%s/" . expand("<cword>") . "/" . input("Replacement: ") . "/g")<CR>',
    opts
)

-- <-A-k> remap represents current best attempt at using window for paren matching
km.set(
    { "c" },
    "<-A-h>",
    '&cedit . "h<C-c>"',
    { noremap = true, silent = true, expr = true }
)
km.set(
    { "c" },
    "<-A-j>",
    '&cedit . "j" . "<C-c>"',
    { noremap = true, silent = true, expr = true }
)
km.set({ "c" }, "<-A-k>", M.t("<C-f>i" .. M.expand_pair("(") .. "<Down>"), opts)
km.set(
    { "c" },
    "<-A-l>",
    '&cedit . "l" . "<C-c>"',
    { noremap = true, silent = true, expr = true }
)

-- Enable delimiter closing for terminal
--vim.api.nvim_set_keymap('c', "'", [ ''<left> ], {noremap = true, silent = true})
--vim.api.nvim_set_keymap('c', '"', [ ""<left> ], {noremap = true, silent = true})
--vim.api.nvim_set_keymap('t', '(', '()<left>', {noremap = true, silent = true})
--vim.api.nvim_set_keymap("c", "'", "\'\'<left>", {noremap = true, silent = true})

--Terminal yanking
km.set({ "n" }, ",ty", function()
    M.term_exec(vim.fn.getreg("+"))
end, opts)
km.set({ "v" }, ",ty", function()
    M.term_exec(M.yank_visual("+"))
end, opts)
km.set({ "t" }, "++", "<Space><bar>><Space>", opts)

--vim.api.nvim_set_keymap('c', '(', [[luaeval('M.expand_pair("(")')]], {noremap = true, silent = true, expr = true})
--vim.api.nvim_set_keymap('c', ')', [[luaeval('M.match_pair(")")')]], {noremap = true, silent = true, expr = true})

vim.api.nvim_set_keymap("n", "!!", "@:<CR>", opts)

km.set({ "n" }, "<leader>ab", function()
    M.add_abbrev(vim.fn.expand("<cword>"))
end, { noremap = true })

-- From https://www.reddit.com/r/neovim/comments/rfrgq5/is_it_possible_to_do_something_like_his_on/
km.set({ "v" }, "J", ":m '>+1<CR>gv=gv", opts)
km.set({ "v" }, "J", ":m '<-2<CR>gv=gv", opts)

km.set({ "n", "v" }, "<Leader>nn", function()
    M.range_command(vim.fn.input("normal command: "))
end)
km.set({ "n", "v" }, "<Leader>Nn", function()
    M.range_command(vim.fn.input("normal command: "), nil, true)
end)
km.set({ "v" }, "*", function()
    M.visual_search("/")
end, opts)
km.set({ "v" }, "#", function()
    M.visual_search("?")
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
km.set({ "i" }, "<C-(>", ":normal i( | lua M.match_paren()", opts)
km.set("n", "<Leader>LL", function()
    vim.lsp.set_log_level("debug")
end, opts)
--
-- Translate Vimscript mapping to Lua with awful regex
km.set(
    { "n", "v" },
    "<leader>ll",
    [=[:s/\v\s*([a-z])noremap\s+([^ ]+)\s+(.*)/vim.api.nvim_set_keymap('\1', [[\2]], [[\3]], {noremap = true, silent = true})/<CR>]=]
    ,
    opts
)
km.set({ "i", "n", "v" }, "<C-%>>", function()
    M.match_paren()
end, { silent = true })

-- Save messages
km.set({ "n" }, "<leader>mm", function()
    vim.fn.setreg("+", vim.fn.execute("messages"))
end, { silent = true })

--Insert mode: delete word or WORD right of cursor
km.set({ "i" }, "<C-b>", "<C-o>mz<S-Right><C-o>dw<C-o>`z<C-o>", opts)
km.set({ "i" }, "<C-B>", "<C-o>mz<S-Right><C-o>dW<C-o>`z<C-o>", opts)
-- Insert mode: delete word or WORD under cursor
km.set({ "i" }, "<C-d>", "<C-o>ciw", opts)
km.set({ "i" }, "<C-D>", "<C-o>ciW", opts)

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
    return M.modify_register(function(x)
        return string.gsub(x, [=[\n]=], [=[\\n]=])
    end)
end)

-- Treesitter pickers
km.set({ "n", "v" }, "<leader>ff", "<cmd>Telescope find_files<CR>")
km.set({ "n", "v" }, "<leader>lg", "<cmd>Telescope live_grep<CR>")
km.set({ "n", "v" }, "<leader>bb", "<cmd>Telescope buffers<CR>")
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
km.set({ "n", "v" }, "<leader>cp", "<cmd>lua M.choose_picker()")

-- hop
km.set({ "n", "v" }, "<C-h>aa", "<cmd>HopAnywhere<CR>")
km.set({ "n", "v" }, "<C-h>ac", "<cmd>HopAnywhereAC<CR>")
km.set({ "n", "v" }, "<C-h>ab", "<cmd>HopAnywhereBC<CR>")
km.set({ "n", "v" }, "<C-h>ac", "<cmd>HopAnywhereAC<CR>")
km.set({ "n", "v" }, "<C-h>c1", "<cmd>HopChar1<CR>")
km.set({ "n", "v" }, "<C-h>c2", "<cmd>HopChar2<CR>")
km.set({ "n", "v" }, "<C-h>hl", "<cmd>HopLine<CR>")
km.set({ "n", "v" }, "<C-h>hw", "<cmd>HopWord<CR>")

km.set({ "n", "v" }, "<Leader>ll", "<plug>(leap-forward-to)", { remap = true })
km.set({ "n", "v" }, "<Leader>LL", "<plug>(leap-backward-to)", { remap = true })
km.set(
    { "n", "v" },
    "<Leader>ww",
    "<plug>(leap-cross-window)",
    { remap = true }
)
km.set(
    { "n", "v" },
    "<Leader>jj",
    "<plug>(leap-forward-till)",
    { remap = true }
)
km.set(
    { "n", "v" },
    "<Leader>JJ",
    "<plug>(leap-backward-till)",
    { remap = true }
)
km.set({ "n", "v" }, "<C-s>", M.term_motion, { expr = true })
km.set({ "n", "v" }, "<C-j>", M.swap, { expr = true })
