-- Custom commands
local create_range = function(line1, line2)
    local out
    if line1 == nil or line2 == nil then
        out = "%"
    else
        out = tostring(line1) .. ","
        tostring(line2)
    end
    return out
end

vim.api.nvim_create_user_command("E", function(args)
    vim.cmd.edit(args["args"])
end, {
    complete = "buffer",
    desc = "Switch to any currently active buffer",
    nargs = "*",
})
vim.api.nvim_create_user_command("BD", function()
    vim.cmd("bprevious | split | bnext | bdelete")
end, { desc = "Delete current buffer without closing window" })
vim.api.nvim_create_user_command("Sed", function(args)
    local range = create_range(args["line1"], args["line2"])
    vim.cmd(range .. "s/" .. args["args"] .. "//g")
end, { desc = "Remove all occurrences of a pattern in the current buffer" })
vim.api.nvim_create_user_command("Grab", function(args)
    local range = create_range(args["line1"], args["line2"])
    vim.cmd(range .. "g/" .. args["args"] .. "//g")
end, { desc = "Yank lines between a range in current buffer" })
vim.api.nvim_create_user_command("Embrace", function(args)
    local range = create_range(args["line1"], args["line2"])
    vim.cmd(range .. [[   s/\v(_|\^)\s*([^{}_\^ \$]+)/\1{\2}/g]])
end, { desc = "Surround LaTeX subscripts in range with braces" })
vim.api.nvim_create_user_command("Inc", function(args)
    local range = create_range(args["line1"], args["line2"])
    vim.cmd(range .. [[s/\%V\d\+\%V/\=submatch(0)+1/g]])
end, { desc = "Increment all numbers within visual selection by 1" })

vim.api.nvim_create_user_command("FZF", function(_)
    vim.fn["fzf#run"]({
        source = os.getenv("FZF_DEFAULT_COMMAND"),
        command = os.getenv("FZF_DEFAULT_OPTS"),
        sink = "e",
    })
end, { desc = "Call FZF with defaults set in environment variables" })
