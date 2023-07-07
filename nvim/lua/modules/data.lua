local M = {}
M.recents = { window = nil, filetype = {}, terminal = {} }
M.defaults = { operatorfunc = "v:lua.require'nvim-surround'.normal_callback" }
M.restore_default = function(option)
    if M.defaults[option] == nil then
        print("No recorded default for " .. option)
    else
        pcall(function()
            vim.go[option] = M.defaults[option]
        end, "Unknown option " .. option)
    end
end

M.record_file_name = function()
    if vim.bo.filetype ~= "" then
        M.recents["filetype"][vim.bo.filetype] = vim.fn.expand("%:p")
    end
end

return M
