--TODO handle insert above
local opts = { noremap = true, silent = true, buffer = true }
insert_comment = function(offset)
    if offset == nil then
        offset = 0
    end
    local line = vim.fn.line(".") + offset
    vim.api.nvim_buf_set_lines(0, line, line, false, { "(*   *)" })
    -- Nudge cursor down if line inserted below
    vim.fn.cursor(line + 1, 4)
    vim.cmd("normal i")
end

-- Copied from https<cmd>//github.com/jez/vim-better-sml; mostly REPL control
vim.keymap.set({ "n", "v" }, "<leader>t", "<cmd>SMLTypeQuery<CR>", opts)
vim.keymap.set({ "n", "v" }, "gd", "<cmd>SMLJumpToDef<CR>", opts)

--  open the REPL terminal buffer
vim.keymap.set({ "n", "v" }, "<leader>is", "<cmd>SMLReplStart<CR>", opts)
--  close the REPL (mnemonic<cmd> k -> kill)
vim.keymap.set({ "n", "v" }, "<leader>ik", "<cmd>SMLReplStop<CR>", opts)
--  build the project (using CM if possible)
vim.keymap.set({ "n", "v" }, "<leader>ib", "<cmd>SMLReplBuild<CR>", opts)
--  for opening a structure, not a file
vim.keymap.set({ "n", "v" }, "<leader>io", "<cmd>SMLReplOpen<CR>", opts)
--  use the current file into the REPL (even if using CM)
vim.keymap.set({ "n", "v" }, "<leader>iu", "<cmd>SMLReplUse<CR>", opts)
--  clear the REPL screen
vim.keymap.set({ "n", "v" }, "<leader>ic", "<cmd>SMLReplClear<CR>", opts)
--  set the print depth to 100
vim.keymap.set({ "n", "v" }, "<leader>ip", "<cmd>SMLReplPrintDepth<CR>", opts)
-- Insert comment below
vim.keymap.set({ "n" }, "<leader>cc", function()
    insert_comment()
end, opts)
-- Insert comment below
vim.keymap.set({ "n" }, "<leader>CC", function()
    insert_comment(-1)
end, opts)
