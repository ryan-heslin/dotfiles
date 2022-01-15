vim.g.mapleader = ","

-- Repeat last terminal command. See https://vi.stackexchange.com/questions/21449/send-keys-to-a-terminal-buffer/21466
vim.api.nvim_set_keymap('n', '<Leader>!!', [[<C-U>:lua term_exec("\x1b\x5b\x41")<CR>]], { noremap = true, silent = true })
-- Send line under cursor to terminal
vim.api.nvim_set_keymap('n', '<Leader>sl', [[:lua term_exec(vim.fn.getline('.'))<CR>]], { noremap = true, silent = true })
-- Interact with terminal buffer
vim.api.nvim_set_keymap('n', '<Leader>te', [[:lua term_edit()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>tr', [[:lua term_edit('savehistory("/tmp/history.txt")', 'r')<CR>]], { noremap = true, silent = true })
 -- Visual selection to terminal
vim.api.nvim_set_keymap('v', '<Leader>tv', [[:lua term_exec(vim.fn.getreg('*'))<CR>]], { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<Leader>sl', [[:lua term_exec(vim.fn.getline('.'))<CR>]], { noremap = true, silent = true })

-- Scroll terminal up-down
vim.api.nvim_set_keymap('n', '<C-PageDown>', ':lua win_exec("3j", vim.g.last_terminal_win_id)<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-PageUp>', ':lua win_exec("3k", vim.g.last_terminal_win_id)<CR>', { noremap = true, silent = true })

--all these to scroll window by position up/down
vim.api.nvim_set_keymap('n', '<Leader>kk', ':lua win_exec("1k", "k")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>kj', ':lua win_exec("1j", "k")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>lk', ':lua win_exec("1k", "l")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>lj', ':lua win_exec("1j", "l")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>jk', ':lua win_exec("1k", "j")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>jj', ':lua win_exec("1j", "j")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>hk', ':lua win_exec("1k", "h")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>hj', ':lua win_exec("1j", "h")<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<Leader>te', ':vsplit<CR>l:terminal<CR>i', { noremap = true, silent = true })

--vim.api.nvim_set_keymap('n', '<C-S>', ':let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>', {noremap = true, silent = true}
vim.api.nvim_set_keymap('n', '<Leader>o', 'o<Esc>k', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>O', 'O<Esc>j', {noremap = true, silent = true})

vim.api.nvim_set_keymap('i', '<c-x><c-f>' , 'fzf#vim#complete#path("rg --files")', {noremap = true, silent = true, expr = true})
vim.api.nvim_set_keymap('c', '<c-x><c-f>', 'fzf#vim#complete#path("rg --files")', {noremap = true, silent = true, expr = true})

-- Tabs & navigation
vim.api.nvim_set_keymap('n', '<Leader>nt', ':tabnew<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>to', ':tabonly<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>tc', ':tabclose<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>tm', ':tabmove<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>tn', ':tabnext<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>tl', ':tabprev<CR>', {noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<Leader>]', ':cnext', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>[', ':cprev', {noremap = true, silent = true})

-- Splits
vim.api.nvim_set_keymap('n', '<Leader>h', ':<C-u>split<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>v', ':<C-u>vsplit<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'cc', '"_cc', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>q', ':q<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>w', ':w<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>qa', ':wa <bar> qa<CR>', {noremap = true, silent = true})
-- From https://vi.stackexchange.com/questions/21449/send-keys-to-a-terminal-buffer/21466

-- Easier window switching
vim.api.nvim_set_keymap('n', '<tab>h', "<cmd>lua repeat_cmd('normal ' .. t('<C-w>') .. 'h', vim.v.count1)<CR>" , {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<tab>j', "<cmd>lua repeat_cmd('normal ' .. t('<C-w>') .. 'j', vim.v.count1)<CR>" , {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<tab>k', "<cmd>lua repeat_cmd('normal ' .. t('<C-w>') .. 'k', vim.v.count1)<CR>" , {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<tab>l', "<cmd>lua repeat_cmd('normal ' .. t('<C-w>') .. 'l', vim.v.count1)<CR>" , {noremap = true, silent = true})

--Easier window manipulation
vim.api.nvim_set_keymap('n', '<tab>H', '<C-w>H', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<tab>J', '<C-w>J', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<tab>K', '<C-w>K', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<tab>L', '<C-w>L', {noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<Tab>+', '<C-w>+', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Tab>-', '<C-w>-', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Tab><', ':<C-u>lua repeat_cmd("wincmd >", vim.v.count1)<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Tab>>', '<cmd>lua repeat_cmd("wincmd >", vim.v.count1)<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Tab>_', '<C-w>_', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Tab><bar>', '<C-w><bar>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Tab>=', '<C-w>=', {noremap = true, silent = true})

-- Spelling remap suggested by https://stackoverflow.com/questions/19072561/spellcheck-entire-file-in-vim
vim.api.nvim_set_keymap('n' ,'<k5>' ,'z=', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n' ,'<k1>' , '[s', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n' ,'<k3>', ']s', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n' ,'<k8>' ,'zg', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<k9>' ,'zug', {noremap = true, silent = true})

-- Print output of Lua command
vim.api.nvim_set_keymap('n', '<leader>lp', ':lua print(<C-r>)<CR>', {noremap = true, silent = true})
-- vimrc access
vim.api.nvim_set_keymap('n', '<Leader>ev', ':split $MYVIMRC<CR>', {noremap = true, silent = true})
--:silent! try | write $MYVIMRC | catch  |  finally  |
vim.api.nvim_set_keymap('n', '<Leader>sv', ':source $MYVIMRC<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<space>', '<space> <c-^>', {noremap = true, silent = true})

-- Default Telescope
vim.api.nvim_set_keymap('n', '<Leader>ff', '<cmd>lua require("telescope.builtin").find_files()<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>fg', '<cmd>lua require("telescope.builtin").live_grep()<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>fb', '<cmd>lua require("telescope.builtin").buffers()<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>fh', '<cmd>lua require("telescope.builtin").help_tags()<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>rr', '<cmd>lua require("telescope.builtin").registers()<cr>', {noremap = true, silent = true})
-- Results of previous picker
vim.api.nvim_set_keymap('n', '<Leader>pp', '<cmd>lua require("telecope.builtin").resume()<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>rl', '<cmd>lua require("telecope.builtin").lsp_references()<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>ls', '<cmd>lua require("telecope.builtin").lsp_document_symbols()<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>ws', '<cmd>lua require("telecope.builtin").lsp_dynamic_workspace_symbols()<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>ca', '<cmd>lua require("telecope.builtin").lsp_range_code_actions()<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>ld', '<cmd>lua require("telecope.builtin").diagnostics({bufnr = 0})<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>lw', '<cmd>lua require("telescope.builtin").diagnostics()<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>li', '<cmd>lua require("telescope.builtin").lsp_implementations()<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>ld', '<cmd>lua require("telescope.builtin").lsp_definitions()<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>T', ':Telescope ', {noremap = true, silent = true})
--
--Knit rmarkdown - ugly as sin but works
vim.api.nvim_set_keymap('n', '<Leader>kn', ':call functions#Knit()<CR>', {noremap = true, silent = true})
-- For easier copy-paste
vim.api.nvim_set_keymap('n', '<Leader>y', '"+y', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>p', '"+p', {noremap = true, silent = true})
-- Paste-replace
vim.api.nvim_set_keymap('n', '<Leader>p', '"_d$p', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>P', '"_d$P', {noremap = true, silent = true})
-- Add line above/below ending with trailing character - good for lists of function args, etc.
vim.api.nvim_set_keymap('n', '<Leader>ao', '$yl[pI', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>aO', '$yl]pI', {noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<Leader>cd', ':cd %:p:h<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader>lcd', ':lcd %:p:h<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', 'c', '"_c', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'C', '"_C', {noremap = true, silent = true})
-- Clear R console after failure
vim.api.nvim_set_keymap('n', '\\cl', ':RSend 0<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '\\cq', ':RSend Q<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '\\ck', ':RSend .. t("<C-c>") <CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>s', ':w <bar> source %<CR>', {noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<Leader>cv', '<cmd> lua vim.cmd[[%normal I<Space><Space><Space><Space> | normal ggG$y<Esc>]]', { noremap = true, silent = true})

-- Strip surrounding function call
vim.api.nvim_set_keymap('n', '<Leader>ds', 'B/(<CR>bdiw%x``xi', {noremap = true, silent = true})
-- Delete next or previous occurrence of string
vim.api.nvim_set_keymap('n', '<Leader>zz', ':<C-U>lua jump_delete("")<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>ZZ', ':<C-U>lua jump_delete("b")<CR>', {noremap = true, silent = true})

-- Yank from terminal
vim.api.nvim_set_keymap('n', '<Leader>ty', ':lua vim.fn.win_execute(vim.g.last_terminal_win_id, "normal 0ElvGy")<CR>', {noremap = true, silent = true})
-- Insert section headings below cursor
vim.api.nvim_set_keymap('n', '<Leader>sen', ':<C-U>call functions#Sections(1)<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>sel', ':<C-U>call functions#Sections("a")<CR>', {noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<Leader>nj', ':<C-U>lua no_jump()<CR>', {noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<Leader>pd', '^yiWoprint(paste("<C-o>p<space>=",<space><C-o>p))<Esc>k^', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>rs', ':call UltiSnips#RefreshSnippets<CR>', {noremap = true, silent = true})
--Insert markdown link around previous word, pasting URL from clipboard
vim.api.nvim_set_keymap('i', ';lk', '<Esc>Bi[<Esc>ea](<Esc>"+pA)<Space>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('i', ';n', '<C-o>o<Esc>4jI', {noremap = true, silent = true})
-- Copy comment character to new line below
vim.api.nvim_set_keymap('i', ';#', '<Esc>^yWo<C-o>P<C-o>$<Space>', {noremap = true, silent = true})
--Paste equation RHS on line below
vim.api.nvim_set_keymap('i', ';eq', '<Esc>F=y$A\\<Esc>o&<Space><Esc>pF=', {noremap = true, silent = true})
vim.api.nvim_set_keymap('i', ';o', '<Esc>o', {noremap = true, silent = true})
vim.api.nvim_set_keymap('i', ';O', '<Esc>O', {noremap = true, silent = true})

vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', {noremap = true, silent = true})
--vim.api.nvim_set_keymap('t',  '<C-r>', "'<C-\\><C-n>' . nr2char(getchar()) . 'pi'", {noremap = true, silent = true, expr = true})
vim.api.nvim_set_keymap('t', '<C-p>', '<C-\\><C-n>pi', {noremap = true, silent = true})

-- https://vim.fandom.com/wiki/Keystroke_Saving_Substituting_and_Searching
--vim.api.nvim_set_keymap('v', '/ y:execute', '"/".escape(@",'[]/\.*')<CR>', {noremap = true, silent = true})
--vim.api.nvim_set_keymap('v', '<F4> y:execute', '"%s/".escape(@",'[]/')."//gc"<Left><Left><Left><Left>', {noremap = true, silent = true})
-- Buffer switch
vim.api.nvim_set_keymap('n', '<Leader>bn', ':bnext<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>bp', ':bprevious<CR>', {noremap = true, silent = true})

vim.api.nvim_set_keymap('c', '<-A-h>', '&cedit . "h<C-c>"', {noremap = true, silent = true, expr = true})
vim.api.nvim_set_keymap('c', '<-A-j>', '&cedit . "j" . "<C-c>"', {noremap = true, silent = true, expr = true})
vim.api.nvim_set_keymap('c', '<-A-k>', '&cedit . "k" . "<C-c>"', {noremap = true, silent = true, expr = true})
vim.api.nvim_set_keymap('c', '<-A-l>', '&cedit . "l" . "<C-c>"', {noremap = true, silent = true, expr = true})
-- Enable delimiter closing for terminal
--vim.api.nvim_set_keymap('c', "'", [ ''<left> ], {noremap = true, silent = true})
--vim.api.nvim_set_keymap('c', '"', [ ""<left> ], {noremap = true, silent = true})
--vim.api.nvim_set_keymap('t', '(', '()<left>', {noremap = true, silent = true})
--vim.api.nvim_set_keymap("c", "'", "\'\'<left>", {noremap = true, silent = true})

vim.api.nvim_set_keymap('t', '++', '<Space><bar>><Space>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('c', '(', ':<C-U>lua expand_pair("(", "c")<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '!!', '@:<CR>', {noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<leader>ab', [[<cmd>lua add_abbrev(vim.fn.expand('<cword>'))<CR>]], {noremap = true})

-- From https://www.reddit.com/r/neovim/comments/rfrgq5/is_it_possible_to_do_something_like_his_on/
vim.api.nvim_set_keymap('v', 'J',  ":m '>+1<CR>gv=gv", {noremap = true, silent = true})
vim.api.nvim_set_keymap('v', 'J',  ":m '<-2<CR>gv=gv", {noremap = true, silent = true})



--Pairs
-- Tranpose function arguments
vim.api.nvim_set_keymap('n', '<Leader>tp', 't,bmz"ydwwdw"yP`zPb', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>em', ':Embrace<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>ss', 'Ea)<C-o>B(<left>', {noremap = true, silent = true})
-- Replacement for all these
-- '<,'>s/\v^([a-z])noremap\s+([^ ]+)\s+(.*)/vim.api.nvim_set_keymap('\1', '\2', '\3', {noremap = true, silent = true})/
