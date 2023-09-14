local insert_table_row = function()
    local line = vim.fn.line(".")
    local next = line + 1
    local text = vim.api.nvim_buf_get_lines(0, line - 1, line, false)
    if text == {} or text == nil then
        return
    end

    local result = {}
    local chars = text[1]
    for i = 1, string.len(chars), 1 do
        print(string.sub(chars, i, i))
        table.insert(result, (string.sub(chars, i, i) == "|" and "|") or " ")
    end
    print(result[1])
    str = table.concat(result, "")
    vim.api.nvim_buf_set_lines(0, line, line + 1, false, { str })
end

local opts = { noremap = true, silent = true }
vim.keymap.set({ "i" }, [[;bb]], [[****<Esc>hi]], opts)
vim.keymap.set({ "i" }, [[;ii]], [[**<Esc>i]], opts)
vim.keymap.set({ "i" }, [[;ll]], insert_table_row)
--Insert Markdown link around previous word, pasting URL from clipboard
vim.keymap.set({ "i" }, ";lk", '<Esc>Bi[<Esc>ea](<Esc>"+pA)<Space>', opts)
