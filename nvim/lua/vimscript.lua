--For special global variable denoting Lua functions callable from Vimscript
--
--Suggested by official guide: Print lua objects
_G.my_utils = {}
_G.my_utils.term_motion = U.terminal.term_motion

function _G.put(...)
    local objects = {}
    for i = 1, select("#", ...) do
        local v = select(i, ...)
        table.insert(objects, vim.inspect(v))
    end

    print(table.concat(objects, "\n"))
    return ...
end

function _G.refresh(file)
    -- https://codereview.stackexchange.com/questions/90177/get-file-name-with-extension-and-get-only-extension
    file = file or vim.fn.expand("%:p")
    local extension = vim.bo.filetype
    local cmd = ""
    if extension == "R" or extension == "r" then
        cmd = 'Rsend source("' .. file .. '")'
    elseif extension == "python" then
        cmd = "IPythonCellRun"
    elseif extension == "bash" or extension == "sh" then
        cmd = "!. " .. file
    elseif extension == "lua" or extension == "vim" then
        cmd = "source " .. file
    else
        print("Don't know how to source file with extension " .. extension)
        return
    end
    print(cmd)
    vim.cmd(cmd)
end

-- From https://www.vikasraj.dev/blog/vim-dot-repeat
function _G.__dot_repeat(motion, print_lines, use_count)
    print_lines = U.utils.default_arg(print_lines, false)
    use_count = U.utils.default_arg(use_count, false)
    local is_visual = string.match(motion or "", "[vV]") -- 2.

    if not is_visual and motion == nil then
        vim.o.operatorfunc = "v:lua.__dot_repeat"
        return "g@"
    end

    if is_visual then
        print("VISUAL mode")
    else
        print("NORMAL mode")
    end

    if print_lines then
        local to_print
        if use_count then
            local row = unpack(vim.api.nvim_win_get_cursor(0))
            to_print = vim.api.nvim_buf_get_lines(
                0,
                row - 1,
                (row + vim.v.count) - 1,
                false
            )
        else
            to_print = {
                starting = vim.api.nvim_buf_get_mark(
                    0,
                    is_visual and "<" or "["
                ),
                ending = vim.api.nvim_buf_get_mark(0, is_visual and ">" or "]"),
            }
        end
        print(vim.inspect(to_print))
    end
end
