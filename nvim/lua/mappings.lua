vim.g.mapleader = ","
local opts = { noremap = true, silent = true }

-- Repeat last terminal command. See https://vi.stackexchange.com/questions/21449/send-keys-to-a-terminal-buffer/21466
vim.keymap.set(
    { "n" },
    "<Leader>!!",
    [[:<C-U>lua M.term_exec("\x1b\x5b\x41")<CR>]],
    opts
)
-- Put in last window
vim.keymap.set(
    { "n", "v" },
    "<leader>p",
    [[:lua M.win_put(nil, vim.v.register)<CR>]],
    opts
)
-- Write, then repeat last command
vim.keymap.set({ "n", "v" }, "<leader>w", ":w | normal @:<CR>", opts)
-- Send line under cursor to terminal
vim.keymap.set(
    { "n" },
    "<Leader>sl",
    [[:lua M.term_exec(vim.fn.getline('.'))<CR>]],
    opts
)
-- Interact with terminal buffer
vim.keymap.set({ "n" }, "<Leader>te", [[:lua M.term_edit()<CR>]], opts)
vim.keymap.set(
    { "n" },
    "<Leader>tr",
    [[:lua M.term_edit('savehistory("/tmp/history.txt")', 'r')<CR>]],
    opts
)
-- Visual selection to terminal
vim.keymap.set(
    { "v" },
    "<Leader>ts",
    [[:lua M.term_exec(vim.fn.getreg('*'))<CR>]],
    opts
)

vim.keymap.set(
    { "n" },
    "<Leader>ts",
    [[:lua M.term_exec(vim.fn.getline('.'))<CR>]],
    opts
)

-- Scroll terminal up-down
vim.keymap.set(
    { "n" },
    "<C-PageDown>",
    ':lua M.win_exec("normal 3j", vim.g.last_terminal_win_id)<CR>',
    opts
)
vim.keymap.set(
    { "n" },
    "<C-PageUp>",
    ':lua M.win_exec("normal 3k", vim.g.last_terminal_win_id)<CR>',
    opts
)

--all these to scroll window by position up/down
vim.keymap.set(
    { "n" },
    "<Leader>kk",
    ':lua M.win_exec("normal k", "k")<CR>',
    opts
)
vim.keymap.set(
    { "n" },
    "<Leader>kj",
    ':lua M.win_exec("normal j", "k")<CR>',
    opts
)
vim.keymap.set(
    { "n" },
    "<Leader>lk",
    ':lua M.win_exec("normal k", "l")<CR>',
    opts
)
vim.keymap.set(
    { "n" },
    "<Leader>lj",
    ':lua M.win_exec("normal j", "l")<CR>',
    opts
)
vim.keymap.set(
    { "n" },
    "<Leader>jk",
    ':lua M.win_exec("normal k", "j")<CR>',
    opts
)
vim.keymap.set(
    { "n" },
    "<Leader>jj",
    ':lua M.win_exec("normal j", "j")<CR>',
    opts
)
vim.keymap.set(
    { "n" },
    "<Leader>hk",
    ':lua M.win_exec("normal k", "h")<CR>',
    opts
)
vim.keymap.set(
    { "n" },
    "<Leader>hj",
    ':lua M.win_exec("normal j", "h")<CR>',
    opts
)

vim.keymap.set(
    { "n", "v" },
    "<Leader>kq",
    ":lua M.win_exec('q', 'k')<CR>",
    opts
)

vim.keymap.set(
    { "n", "v" },
    "<Leader>hq",
    ":lua M.win_exec('q', 'h')<CR>",
    opts
)

vim.keymap.set(
    { "n", "v" },
    "<Leader>lq",
    ":lua M.win_exec('q', 'l')<CR>",
    opts
)

vim.keymap.set(
    { "n", "v" },
    "<Leader>jq",
    ":lua M.win_exec('q', 'j')<CR>",
    opts
)

vim.keymap.set(
    { "n", "v" },
    "<Leader>wc",
    ":lua M.win_exec('normal ' .. vim.fn.input.M.t('Command: '), vim.fn.input('Window: '))<CR>",
    opts
)

vim.keymap.set({ "n" }, "<Leader>te", ":vsplit<CR>l:terminal<CR>i", opts)

--vim.api.nvim_set_keymap('n', '<C-S>', ':let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>', {noremap = true, silent = true}
vim.keymap.set({ "n" }, "<Leader>o", "o<Esc>k", opts)
vim.keymap.set({ "n" }, "<Leader>O", "O<Esc>j", opts)

vim.keymap.set(
    { "i" },
    "<c-x><c-f>",
    'fzf#vim#complete#path("rg --files")',
    { noremap = true, silent = true, expr = true }
)
vim.keymap.set(
    { "c" },
    "<c-x><c-f>",
    'fzf#vim#complete#path("rg --files")',
    { noremap = true, silent = true, expr = true }
)

-- Tabs & navigation
vim.keymap.set({ "n" }, "<Leader>nt", ":tabnew<CR>", opts)
vim.keymap.set({ "n" }, "<Leader>to", ":tabonly<CR>", opts)
vim.keymap.set({ "n" }, "<Leader>tc", ":tabclose<CR>", opts)
vim.keymap.set({ "n" }, "<Leader>tm", ":tabmove<CR>", opts)
vim.keymap.set({ "n" }, "<Leader>tn", ":tabnext<CR>", opts)
vim.keymap.set({ "n" }, "<Leader>tl", ":tabprev<CR>", opts)

vim.keymap.set({ "n" }, "<Leader>]", ":cnext", opts)
vim.keymap.set({ "n" }, "<Leader>[", ":cprev", opts)

-- Splits
vim.keymap.set({ "n" }, "<Leader>h", ":<C-u>split<CR>", opts)
vim.keymap.set({ "n" }, "<Leader>v", ":<C-u>vsplit<CR>", opts)
vim.api.nvim_set_keymap("n", "cc", '"_cc', opts)
vim.keymap.set({ "n" }, "<Leader>q", ":q<CR>", opts)
vim.keymap.set({ "n" }, "<Leader>w", ":w<CR>", opts)
vim.keymap.set({ "n" }, "<Leader>qa", ":wa <bar> qa<CR>", opts)
-- From https://vi.stackexchange.com/questions/21449/send-keys-to-a-terminal-buffer/21466

-- Easier window switching
vim.keymap.set(
    { "n" },
    "<Tab>h",
    "<cmd>lua M.repeat_cmd('normal ' .. M.t('<C-w>') .. 'h', vim.v.count1)<CR>",
    opts
)
vim.keymap.set(
    { "n" },
    "<Tab>j",
    "<cmd>lua M.repeat_cmd('normal ' .. M.t('<C-w>') .. 'j', vim.v.count1)<CR>",
    opts
)
vim.keymap.set(
    { "n" },
    "<Tab>k",
    "<cmd>lua M.repeat_cmd('normal ' .. M.t('<C-w>') .. 'k', vim.v.count1)<CR>",
    opts
)
vim.keymap.set(
    { "n" },
    "<Tab>l",
    "<cmd>lua M.repeat_cmd('normal ' .. M.t('<C-w>') .. 'l', vim.v.count1)<CR>",
    opts
)

--Easier window manipulation
vim.keymap.set({ "n" }, "<Tab>H", "<C-w>H", opts)
vim.keymap.set({ "n" }, "<Tab>J", "<C-w>J", opts)
vim.keymap.set({ "n" }, "<Tab>K", "<C-w>K", opts)
vim.keymap.set({ "n" }, "<Tab>L", "<C-w>L", opts)

vim.keymap.set({ "n" }, "<Tab>+", "<C-w>+", opts)
vim.keymap.set({ "n" }, "<Tab>-", "<C-w>-", opts)
vim.keymap.set(
    { "n" },
    "<Tab><",
    ':<C-u>lua M.repeat_cmd("wincmd >", vim.v.count1)<CR>',
    opts
)
vim.keymap.set(
    { "n" },
    "<Tab>>",
    '<cmd>lua M.repeat_cmd("wincmd >", vim.v.count1)<CR>',
    opts
)
vim.keymap.set({ "n" }, "<Tab>_", "<C-w>_", opts)
vim.keymap.set({ "n" }, "<Tab><bar>", "<C-w><bar>", opts)
vim.keymap.set({ "n" }, "<Tab>=", "<C-w>=", opts)

-- Spelling remap suggested by https://stackoverflow.com/questions/19072561/spellcheck-entire-file-in-vim
vim.api.nvim_set_keymap("n", "<k5>", "z=", opts)
vim.api.nvim_set_keymap("n", "<k1>", "[s", opts)
vim.api.nvim_set_keymap("n", "<k3>", "]s", opts)
vim.api.nvim_set_keymap("n", "<k8>", "zg", opts)
vim.api.nvim_set_keymap("n", "<k9>", "zug", opts)

-- Print output of Lua command
vim.keymap.set({ "n" }, "<leader>lp", ":lua print(<C-r>)<CR>", opts)
-- vimrc access
vim.keymap.set({ "n" }, "<Leader>ev", ":split $MYVIMRC<CR>", opts)
--:silent! try | write $MYVIMRC | catch  |  finally  |
vim.keymap.set(
    { "n" },
    "<Leader>sv",
    ":source $MYVIMRC<CR>",
    { noremap = true }
)
vim.keymap.set({ "n" }, "<space>", "<space> <c-^>", opts)
vim.keymap.set(
    { "n" },
    "<leader>tt",
    ':lua M.switch_to_buffer("term")<CR>',
    opts
)

-- Default Telescope
vim.keymap.set(
    { "n" },
    "<Leader>ff",
    '<cmd>lua require("telescope.builtin").find_files()<cr>',
    opts
)
vim.keymap.set(
    { "n" },
    "<Leader>fg",
    '<cmd>lua require("telescope.builtin").live_grep()<cr>',
    opts
)
vim.keymap.set(
    { "n" },
    "<Leader>fb",
    '<cmd>lua require("telescope.builtin").buffers()<cr>',
    opts
)
vim.keymap.set(
    { "n" },
    "<Leader>fh",
    '<cmd>lua require("telescope.builtin").help_tags()<cr>',
    opts
)
vim.keymap.set(
    { "n" },
    "<Leader>rr",
    '<cmd>lua require("telescope.builtin").registers()<cr>',
    opts
)
-- Results of previous picker
vim.keymap.set(
    { "n" },
    "<Leader>pp",
    '<cmd>lua require("telecope.builtin").resume()<cr>',
    opts
)
vim.keymap.set(
    { "n" },
    "<Leader>rl",
    '<cmd>lua require("telecope.builtin").lsp_references()<cr>',
    opts
)
vim.keymap.set(
    { "n" },
    "<Leader>ls",
    '<cmd>lua require("telecope.builtin").lsp_document_symbols()<cr>',
    opts
)
vim.keymap.set(
    { "n" },
    "<Leader>ws",
    '<cmd>lua require("telecope.builtin").lsp_dynamic_workspace_symbols()<cr>',
    opts
)
vim.keymap.set(
    { "n" },
    "<Leader>ca",
    '<cmd>lua require("telecope.builtin").lsp_range_code_actions()<cr>',
    opts
)
vim.keymap.set(
    { "n" },
    "<Leader>ld",
    '<cmd>lua require("telecope.builtin").diagnostics({bufnr = 0})<cr>',
    opts
)
vim.keymap.set(
    { "n" },
    "<Leader>lw",
    '<cmd>lua require("telescope.builtin").diagnostics()<cr>',
    opts
)
vim.keymap.set(
    { "n" },
    "<Leader>li",
    '<cmd>lua require("telescope.builtin").lsp_implementations()<cr>',
    opts
)
vim.keymap.set(
    { "n" },
    "<Leader>ld",
    '<cmd>lua require("telescope.builtin").lsp_definitions()<cr>',
    opts
)
vim.keymap.set({ "n" }, "<Leader>T", ":Telescope ", opts)
--
--Knit rmarkdown - ugly as sin but works
vim.keymap.set({ "n" }, "<Leader>kn", function()
    M.knit(nil, true, true)
end, opts)
-- For easier copy-paste
vim.keymap.set({ "n" }, "<Leader>y", '"+y', opts)
vim.keymap.set({ "n" }, "<Leader>p", '"+p', opts)
-- Paste-replace
vim.keymap.set({ "n" }, "<Leader>p", '"_d$p', opts)
vim.keymap.set({ "n" }, "<Leader>P", '"_d$P', opts)
-- Add line above/below ending with trailing character - good for lists of function args, etc.
vim.keymap.set({ "n" }, "<Leader>ao", "$yl[pI", opts)
vim.keymap.set({ "n" }, "<Leader>aO", "$yl]pI", opts)

vim.keymap.set(
    { "n" },
    "<Leader>cd",
    ":silent cd %:p:h | pwd<CR>",
    { noremap = true }
)
vim.keymap.set(
    { "n" },
    "<Leader>lcd",
    ":silent lcd %:p:h | pwd<CR>",
    { noremap = true }
)
vim.api.nvim_set_keymap("n", "c", '"_c', opts)
vim.api.nvim_set_keymap("n", "C", '"_C', opts)
-- Clear R console after failure
vim.keymap.set({ "n" }, "\\cl", ":RSend 0<CR>", opts)
vim.keymap.set({ "n" }, "\\cq", ":RSend Q<CR>", opts)
vim.keymap.set({ "n" }, "\\ck", ':RSend .. M.t("<C-c>") <CR>', opts)
vim.keymap.set({ "n" }, "<Leader>s", ":w <bar> source %<CR>", opts)

-- Give info on R objects
vim.keymap.set({ "n" }, "\ra", ':lua M.r_exec("args")<CR>', opts)
vim.keymap.set({ "n" }, "\rt", ':lua M.r_exec("str")<CR>', opts)
vim.keymap.set(
    { "n" },
    "\re",
    ':lua vim.cmd("RSend " .. M.surround_string(vim.fn.getline("."), "(", ")"))<CR>',
    opts
)

vim.keymap.set(
    { "n" },
    "<Leader>cv",
    "<cmd> lua vim.cmd[[%normal I<Space><Space><Space><Space> | normal ggG$y<Esc>]]",
    opts
)
-- Surround register with quotes
vim.keymap.set(
    { "n" },
    '<leader>"',
    [[:lua M.modify_register(M.surround_string, '+', '"', '"')<CR>]],
    opts
)

-- Strip surrounding function call
vim.keymap.set({ "n" }, "<Leader>ds", "B/(<CR>bdiw%x``xi", opts)
-- Delete next or previous occurrence of string
vim.keymap.set({ "n" }, "<Leader>zz", ':<C-U>lua M.alter_closest("")<CR>', opts)
vim.keymap.set(
    { "n" },
    "<Leader>ZZ",
    ':<C-U>lua M.alter_closest("b")<CR>',
    opts
)
vim.keymap.set(
    { "n" },
    "<Leader>zr",
    ':<C-U>lua M.alter_closest("", true)<CR>',
    opts
)
vim.keymap.set(
    { "n" },
    "<Leader>Zr",
    ':<C-U>lua M.alter_closest("b", true)<CR>',
    opts
)

vim.keymap.set({ "n" }, "<leader>fl", [[:s/\%>80v,\zs\s*\ze/\r  /g<CR>]], opts)
vim.keymap.set({ "v" }, "<leader>fl", [[:s/\%>80v,\zs\s*\ze/\r  /g<CR>]], opts)

-- Yank from terminal
vim.keymap.set(
    { "n" },
    "<Leader>ty",
    ':lua vim.fn.win_execute(vim.g.last_terminal_win_id, "normal 0ElvGy")<CR>',
    opts
)
-- Insert section headings below cursor
vim.keymap.set(
    { "n" },
    "<Leader>sen",
    ":<C-U>call functions#Sections(1)<CR>",
    opts
)
vim.keymap.set(
    { "n" },
    "<Leader>sel",
    ':<C-U>call functions#Sections("a")<CR>',
    opts
)

vim.keymap.set({ "n" }, "<Leader>nj", ":<C-U>lua M.no_jump_safe()<CR>", opts)
vim.keymap.set({ "i" }, "<C-a>", "<C-o>:lua M.no_jump_safe()<CR>", opts)
vim.keymap.set({ "v" }, "<C-a>", "<C-o>:lua M.no_jump_safe()<CR>", opts)

vim.keymap.set(
    { "n" },
    "<Leader>pd",
    '^yiWoprinM.t(paste("<C-o>p<space>=",<space><C-o>p))<Esc>k^',
    opts
)
vim.keymap.set(
    { "n" },
    "<Leader>rs",
    ":call UltiSnips#RefreshSnippets<CR>",
    opts
)
--Insert markdown link around previous word, pasting URL from clipboard
vim.keymap.set({ "i" }, ";lk", '<Esc>Bi[<Esc>ea](<Esc>"+pA)<Space>', opts)
vim.keymap.set({ "i" }, ";n", "<C-o>o<Esc>4jI", opts)
-- Copy comment character to new line below
vim.keymap.set({ "i" }, ";#", "<Esc>^yWo<C-o>P<C-o>$<Space>", opts)
--Paste equation RHS on line below
vim.keymap.set({ "i" }, ";eq", "<Esc>F=y$A\\<Esc>o&<Space><Esc>pF=", opts)
vim.api.nvim_set_keymap("i", ";o", "<Esc>o", opts)
vim.api.nvim_set_keymap("i", ";O", "<Esc>O", opts)

vim.keymap.set({ "t" }, "<Esc>", "<C-\\><C-n>", opts)
--vim.api.nvim_set_keymap('t',  '<C-r>', "'<C-\\><C-n>' . nr2char(getchar()) . 'pi'", {noremap = true, silent = true, expr = true})
vim.keymap.set({ "t" }, "<C-p>", "<C-\\><C-n>pi", opts)
-- Terminal paste most recent filename
vim.keymap.set(
    { "t" },
    "<C-t>",
    [["'" . expand("#:p" . v:count1) . "'"]],
    { noremap = true, silent = true, expr = true }
)
-- Put text in next free register
vim.keymap.set(
    { "n" },
    "<leader>sr",
    ":lua M.next_free_register(nil, nil)<CR>",
    opts
)

-- https://vim.fandom.com/wiki/Keystroke_Saving_Substituting_and_Searching
--vim.api.nvim_set_keymap('v', '/ y:execute', '"/".escape(@",'[]/\.*')<CR>', {noremap = true, silent = true})
--vim.api.nvim_set_keymap('v', '<F4> y:execute', '"%s/".escape(@",'[]/')."//gc"<Left><Left><Left><Left>', {noremap = true, silent = true})
-- Buffer switch
vim.keymap.set({ "n" }, "<Leader>bn", ":bnext<CR>", opts)
vim.keymap.set({ "n" }, "<Leader>bp", ":bprevious<CR>", opts)
-- Replace
-- TODO fix
vim.keymap.set(
    { "n" },
    "<Leader>rw",
    ':call execute("%s/" . expand("<cword>") . "/" . input("Replacement: ") . "/g")<CR>',
    opts
)

-- <-A-k> remap represents current best attempt at using window for paren matching
vim.keymap.set(
    { "c" },
    "<-A-h>",
    '&cedit . "h<C-c>"',
    { noremap = true, silent = true, expr = true }
)
vim.keymap.set(
    { "c" },
    "<-A-j>",
    '&cedit . "j" . "<C-c>"',
    { noremap = true, silent = true, expr = true }
)
vim.keymap.set(
    { "c" },
    "<-A-k>",
    M.t("<C-f>i" .. M.expand_pair("(") .. "<Down>"),
    opts
)
vim.keymap.set(
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
vim.keymap.set({ "n" }, ",ty", ':lua M.term_exec(vim.fn.getreg("+"))<CR>', opts)
vim.keymap.set({ "v" }, ",ty", ':lua M.term_exec(M.yank_visual("+"))<CR>', opts)
vim.keymap.set({ "t" }, "++", "<Space><bar>><Space>", opts)
--vim.api.nvim_set_keymap('c', '(', [[luaeval('M.expand_pair("(")')]], {noremap = true, silent = true, expr = true})
--vim.api.nvim_set_keymap('c', ')', [[luaeval('M.match_pair(")")')]], {noremap = true, silent = true, expr = true})

vim.api.nvim_set_keymap("n", "!!", "@:<CR>", opts)

vim.keymap.set(
    { "n" },
    "<leader>ab",
    [[<cmd>lua M.add_abbrev(vim.fn.expand('<cword>'))<CR>]],
    { noremap = true }
)

-- From https://www.reddit.com/r/neovim/comments/rfrgq5/is_it_possible_to_do_something_like_his_on/
vim.keymap.set({ "v" }, "J", ":m '>+1<CR>gv=gv", opts)
vim.keymap.set({ "v" }, "J", ":m '<-2<CR>gv=gv", opts)

vim.keymap.set(
    { "n", "v" },
    "<Leader>nn",
    ":<C-U>lua M.range_command(vim.fn.input('normal command: '))<CR>"
)
vim.keymap.set(
    { "n", "v" },
    "<Leader>Nn",
    ":<C-U>lua M.range_command(vim.fn.input('normal command: '), nil, true)<CR>"
)
vim.keymap.set({ "v" }, "*", ':lua M.visual_search("/")<CR>', opts)
vim.keymap.set({ "v" }, "#", ':lua M.visual_search("?")<CR>', opts)
--Pairs
-- Transpose function arguments
-- These complex mappings copied from https://vim.fandom.com/wiki/Swapping_characters,_words_and_lines
vim.keymap.set(
    { "n" },
    "gw",
    [[_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><c-o><c-l>:nohlsearch<CR>]],
    opts
)
vim.keymap.set(
    { "n" },
    "gl",
    [["_yiw?\w\+\_W\+\%#<CR>:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><c-o><c-l>:nohlsearch<CR>]],
    opts
)
vim.keymap.set(
    { "n" },
    "gl",
    [["_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><c-o>/\w\+\_W\+<CR><c-l>:nohlsearch<CR>]],
    opts
)
vim.api.nvim_set_keymap("n", "g{", "dap}p{", opts)
vim.keymap.set({ "n" }, "<Leader>tp", 't,bmz"ydwwdw"yP`zPb', opts)
vim.keymap.set({ "n" }, "<Leader>tP", 'bdwmzF,b"ydww', opts)
vim.keymap.set({ "n" }, "<Leader>em", ":Embrace<CR>", opts)
vim.keymap.set({ "n" }, "<Leader>ss", "Ea)<C-o>B(<left>", opts)
vim.keymap.set({ "i" }, "<C-(>", ":normal i( | lua M.match_paren()", opts)
vim.keymap.set("n", "<Leader>LL", function()
    vim.lsp.set_log_level("debug")
end, opts)
--
-- Translate Vimscript mapping to vim
vim.keymap.set(
    { "n", "v" },
    "<leader>ll",
    [=[:s/\v\s*([a-z])noremap\s+([^ ]+)\s+(.*)/vim.api.nvim_set_keymap('\1', [[\2]], [[\3]], {noremap = true, silent = true})/<CR>]=],
    opts
)
vim.keymap.set({ "i", "n", "v" }, "<C-%>>", function()
    M.match_paren()
end, { silent = true })
-- Save messages
vim.keymap.set({ "n" }, "<leader>mm", function()
    vim.fn.setreg("+", vim.fn.execute("messages"))
end, { silent = true })

--Insert mode: delete word or WORD right of cursor
vim.keymap.set({ "i" }, "<C-b>", "<C-o>mz<S-Right><C-o>dw<C-o>`z<C-o>", opts)
vim.keymap.set({ "i" }, "<C-B>", "<C-o>mz<S-Right><C-o>dW<C-o>`z<C-o>", opts)
-- Insert mode: delete word or WORD under cursor
vim.keymap.set({ "i" }, "<C-d>", "<C-o>ciw", opts)
vim.keymap.set({ "i" }, "<C-D>", "<C-o>ciW", opts)

-- Extract to default argument
vim.keymap.set(
    { "n" },
    "<Leader>ed",
    [[:<C-U>lua M.extract_to_default_arg()<CR>]],
    opts
)
-- Repeat motion
vim.keymap.set("n", "gt", _G.__dot_repeat, { expr = true })
-- Print lines, take count
vim.keymap.set(
    "n",
    "<leader>gt",
    "<ESC><CMD>lua _G.__dot_repeat(nil, true, true)<CR>",
    { expr = true }
)
vim.keymap.set(
    "x",
    "gt",
    "<ESC><CMD>lua _G.__dot_repeat(vim.fn.visualmode(), false, true)<CR>"
) -- 1.
