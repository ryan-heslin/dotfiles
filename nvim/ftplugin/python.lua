local opts = { noremap = true, silent = true, buffer = true }
local km = vim.keymap
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

km.set("n", [[<leader>sh]], [[ggO#!/usr/bin/python3<Esc><C-o>]], opts)
km.set("n", [[\s]], [[:SlimeSend1 ipython<CR>]], opts)
km.set("n", [[\e]], [[:w <bar> IPythonCellExecuteCell<CR>]], opts)
km.set("n", [[\r]], [[:w <bar> IPythonCellRun<CR>]], opts)
km.set("n", [[\p]], [[:IPythonCellPrevCommand<CR>]], opts)
km.set("n", [[\\]], [[:IPythonCellRestart<CR>]], opts)
km.set("n", [[\[c]], [[:IPythonCellPrevCell<CR>]], opts)
km.set("n", [[\E]], [[:IPythonCellExecuteCellJump<CR>]], opts)
km.set("n", [[\x]], [[:IPythonCellClose<CR>]], opts)
km.set("n", [[\p]], [[:IPythonCellClear<CR>]], opts)
km.set("n", [[\Q]], [[:IPythonCellRestart<CR>]], opts)
km.set("n", [[\d]], [[:SlimeSend1 %debug<CR>]], opts)
km.set("n", [[\q]], [[:SlimeSend1 exit<CR>]], opts)

-- Print object under cursor
km.set("n", [[\pp]], [[yiW:SlimeSend1 print(<C-r><C-w>)<CR>]], opts)
km.set("n", [[\o]], "<Plug>SlimeRegionSend<CR>", opts)
km.set("n", [[\b]], [[<Plug>SlimeParagraphSend<CR>]], opts)
km.set("n", [[\ll]], "<Plug>SlimeLineSend<CR>", opts)
km.set("n", [[\m]], "<Plug>SlimeMotionSend<CR>", opts)

-- Set or remove breakpoints
km.set("n", [[\pdb]], [[Obreakpoint()<Esc>j]], opts)
km.set("n", [[\ddb]], [[:%s/^\s*breakpoint()\s*$//<CR>]], opts)

-- Print debug
km.set("n", [[<leader>pd]], [[^yWoIprint(f'<C-o>P = {<C-o>P}')<Esc>]], opts)
--km.set({"n", "v"}, [[:split | normal  | term | lua U.term_exec("ipython3")<CR>]])
km.set("n", [[<leader>di]], [[Pa["<Esc>ea"]<Esc>B]], opts)
km.set("i", [[<C-l>]], [[<Esc>A:<CR>]], opts)
km.set({ "n", "v" }, [[\jj]], ":lua run_current_chunk()<CR>", opts)
km.set({ "n", "v" }, [[\rr]], ":lua run_all_chunks()<CR>", opts)
--km.set({ "n", "v" }, [[\l]], ":lua run_line()<CR>", opts)
km.set({ "n", "v" }, [[\ss]], run_visual_selection, opts)

km.set(
    { "n", "v" },
    [[\ca]],
    "<cmd>lua run_all_chunks(nil, vim.fn.line('.'))<CR>",
    opts
)
km.set({ "n", "v" }, [[\pp]], ":lua run_word()<CR>", opts)
km.set({ "n", "v" }, [[\hh]], ":lua run_paragraph()<CR>", opts)
km.set({ "n" }, "<leader>dn", function()
    require("dap-python").test_method()
end)
km.set({ "n" }, "<leader>df", function()
    require("dap-python").test_class()
end)
km.set({ "v" }, "<leader>ds", function()
    require("dap-python").debug_selection()
end)

-- Special Python highlighting
vim.api.nvim_set_hl(0, "TSDunder", { fg = "#d694b4", italic = true })
vim.api.nvim_set_hl(0, "TSSelf", { fg = "#d694b4", italic = true, bold = true })
