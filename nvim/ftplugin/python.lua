local ipython = function()
    if term_state == nil then
        U.utils.sequence_callbacks({
            U.terminal.term_setup,
            function()
                U.terminal.term_exec("ipython")
            end,
        }, 5)
    end
end
local opts = { noremap = true, silent = true, buffer = true }
local km = vim.keymap

-- Run a Python script using vim-slime
local run = function()
    if term_state == nil
        or term_state["last_terminal_win_id"] == nil
        or term_state["last_terminal_chan_id"] == nil
    then
        print("No terminal active")
        return
    end
    local chan = term_state["last_terminal_chan_id"]
    if vim.g.slime_default_config == nil then
        vim.g.slime_default_config = { jobid = chan }
    end
    vim.g.slime_target = "neovim"
    vim.g.slime_dont_ask_default = true
    vim.cmd.write()
    -- Read and run buffer lines
    local code = vim.api.nvim_buf_get_lines(0, 0, vim.fn.line("$"), {})
    local text = table.concat(code, "\n") .. "\n"
    vim.fn["slime#send"]("%cpaste -q\n")
    vim.fn["slime#send"](text)
    vim.fn["slime#send"]("\n--\n")
end

vim.opt.cinwords:append({
    "if",
    "else",
    "async",
    "for",
    "while",
    "try",
    "except",
    "finally",
    "def",
    "class",
    "with",
})
vim.g.jupyter_highlight_cells = 1
vim.g.jupyter_cell_separators = {"`"}

km.set("n", "<leader>sh", [[ggO#!/usr/bin/python3<Esc><C-o>]], opts)
km.set("n", "\\s", [[:SlimeSend1 ipython<CR>]], opts)
km.set("n", "\\e", [[:w <bar> IPythonCellExecuteCell<CR>]], opts)
km.set("n", "\\r", run, opts)
km.set("n", "\\p", [[:IPythonCellPrevCommand<CR>]], opts)
km.set("n", "\\\\", [[:IPythonCellRestart<CR>]], opts)
km.set("n", "\\[c", [[:IPythonCellPrevCell<CR>]], opts)
km.set("n", "\\E", [[:IPythonCellExecuteCellJump<CR>]], opts)
km.set("n", "\\x", [[:IPythonCellClose<CR>]], opts)
km.set("n", "\\p", [[:IPythonCellClear<CR>]], opts)
km.set("n", "\\Q", [[:IPythonCellRestart<CR>]], opts)
km.set("n", "\\d", [[:SlimeSend1 %debug<CR>]], opts)
km.set("n", "\\q", [[:SlimeSend1 exit<CR>]], opts)

-- Print object under cursor
km.set("n", "\\pp", [[yiW:SlimeSend1 print(<C-r><C-w>)<CR>]], opts)
km.set("n", "\\o", "<Plug>SlimeRegionSend<CR>", opts)
km.set("n", "\\b", [[<Plug>SlimeParagraphSend<CR>]], opts)
km.set("n", "\\l", "<Plug>SlimeLineSend<CR>", opts)
km.set("n", "\\m", "<Plug>SlimeMotionSend<CR>", opts)

-- Set or remove breakpoints
km.set("n", "\\pdb", [[Obreakpoint()<Esc>j]], opts)
km.set("n", "\\ddb", [[:%s/^\s*breakpoint()\s*$//<CR>]], opts)

-- Print debug
km.set("n", "<leader>pd", [[^yWoIprint(f'<C-o>P = {<C-o>P}')<Esc>]], opts)
km.set("n", "<leader>di", [[Pa["<Esc>ea"]<Esc>B]], opts)
km.set("i", "[[<C-l>]]", [[<Esc>A:<CR>]], opts)
km.set({ "n", "v" }, "\\jj", ":lua run_current_chunk()<CR>", opts)
km.set({ "n", "v" }, "\\rr", ":lua run_all_chunks()<CR>", opts)
km.set({ "n", "v" }, "\\ss", run_visual_selection, opts)

km.set({ "n", "v" }, [[\ca]], function()
    run_all_chunks(nil, vim.api.nvim_get_current_line())
end, opts)
km.set({ "n", "v" }, "<leader>pp", run_word, opts)
km.set({ "n", "v" }, "<leader>hh", run_paragraph, opts)
km.set({ "n" }, "<leader>dn", function()
    require("dap-python").test_method()
end)
km.set({ "n" }, "<leader>df", function()
    require("dap-python").test_class()
end)
km.set({ "v" }, "<leader>ds", function()
    require("dap-python").debug_selection()
end)
km.set({ "n", "v" }, "<leader>ii", function()
    local module = vim.fn.input("Enter module name: ")
    U.terminal.term_exec("import importlib; importlib.reload(" .. module .. ")")
end)
km.set({ "n", "v" }, "<leader>rl", ipython)
-- Special Python highlighting
vim.api.nvim_set_hl(0, "TSDunder", { fg = "#d694b4", italic = true })
vim.api.nvim_set_hl(0, "TSSelf", { fg = "#d694b4", italic = true, bold = true })
