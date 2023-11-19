local M = {}

M.visual_search = function(target)
    -- Abort current visual mode
    vim.cmd.normal(U.utils.t("<Esc>"))
    target = U.utils.default_arg(target, "/")
    local text = M.yank_visual(0)
    vim.fn.setreg("/", text, "c")
    return text
end
M.alter_closest = function(flags, replace)
    local string = vim.fn.input("Enter pattern: ")
    if string.len(string) == 0 then
        return
    end
    local replacement = ""
    if replace then
        replacement = vim.fn.input("Enter replacement: ")
    end
    local count = vim.v.count1
    local start = vim.fn.getpos(".")
    flags = "wz" .. (flags or "")
    -- Search forward or backward; ternary-ish expression
    local step = (vim.fn.stridx(flags, "b") == -1) and "n" or "N"

    vim.fn.setreg("/", string)
    local matches = vim.fn.searchcount()["total"]
    local stop = math.min(matches, count)

    -- Search for next match {count} times
    local cmd = replacement and "normal gns" .. replacement or "normal gnx"
    for _ = 0, stop - 1 do
        vim.cmd("normal " .. step)
        vim.cmd(cmd)
    end

    vim.fn.setpos(".", start)
    vim.fn.setreg("/", {})
    print("Removed " .. stop .. " match(es)")
end

--Buffer
M.get_matching_buffers = function(pattern)
    pattern = U.utils.default_arg(pattern, ".*")
    local buffers = vim.api.nvim_list_bufs()
    local matches = {}
    local valid_buffers = {}

    for _, buf in ipairs(buffers) do
        if vim.api.nvim_buf_is_loaded(buf)
            and vim.api.nvim_buf_get_option(buf, "bufhidden") ~= "hide"
        then
            local buf_name = vim.api.nvim_buf_get_name(buf)
            if string.match(buf_name, pattern) then
                buf_name = (buf_name == "" and "<unnamed>") or buf_name
                table.insert(valid_buffers, buf)
                table.insert(matches, buf_name)
            end
        end
    end
    return valid_buffers, matches
end

-- Change to buffer matching a regular expression
M.switch_to_buffer = function(pattern)
    -- Match all by default
    valid_buffers, matches = M.get_matching_buffers(pattern)

    if #valid_buffers == 0 then
        print("No active buffers matched " .. pattern)
        return
    end
    -- Create menu offering buffer options
    vim.ui.select(
        matches,
        {
            prompt = "Select buffer:",
        },
        -- Switch to selected buffer
        function(choice, index)
            if choice == nil then
                return
            end
            vim.cmd.buffer(valid_buffers[index])
        end
    )
end

M.get_buf_names = function(filter, ...)
    filter = U.utils.default_arg(filter, function(bufnr)
        return vim.api.nvim_buf_is_loaded(bufnr)
    end)
    local bufnrs = vim.api.nvim_list_bufs()
    local out = {}
    for _, bufnr in ipairs(bufnrs) do
        if filter(bufnr, ...) then
            out[tostring(bufnr)] = vim.api.nvim_buf_get_name(bufnr)
        end
    end
    return out
end

M.close_bufs_by_type = function(buftype)
    for _, bufname in pairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_get_option(bufname, "buftype") == buftype then
            vim.cmd("bdelete " .. bufname)
        end
    end
end

M.yank_visual = function(buffer)
    buffer = U.utils.default_arg(buffer, 0)
    -- Col value for ">" mark in linewise selection is the 32-bit integer limit
    -- TODO fix blockwise selection
    --local linewise_col = 2 ^ 31 - 1
    local left_line = vim.fn.line("'<")
    local left_col = vim.fn.col("'<")
    local right_line = vim.fn.line("'>")
    local right_col = vim.fn.col("'>")

    local mode = vim.fn.visualmode()
    if mode == "v" then --Charwise mode
        text = vim.api.nvim_buf_get_text(
            buffer,
            left_line - 1,
            math.max(left_col - 1, 0),
            right_line - 1,
            right_col,
            {}
        )
    else
        text = vim.api.nvim_buf_get_lines(
            buffer,
            left_line - 1,
            right_line - 1,
            {}
        )
        if mode ~= "V" then -- Linewise mode: trim lines to width of block
            end_col = 0
            for _, line in ipairs(text) do
                end_col = math.max(end_col, string.len(line))
            end
            for i, line in ipairs(text) do
                text[i] = string.sub(line, left_col, end_col)
            end
        end
    end
    if type(text) == "table" then
        text = table.concat(text, "\n")
    end
    return text
end

--Buffer
M.open_in_hidden = function(pattern)
    local current_file = vim.fn.expand("%")
    -- Default to matching current file extension
    pattern = U.utils.default_arg(
        pattern,
        "*" .. string.sub(current_file, string.find(current_file, "%.[^.]+$"))
    )
    local files = vim.fn.systemlist("ls " .. pattern)
    -- Shell-quote and add all files matched, except current
    local cmd = "argadd"
    local current_buffer = vim.api.nvim_buf_get_number(0)
    for i, _ in ipairs(files) do
        cmd = cmd .. (files[i] ~= current_file)
            and U.utils.surround_string(files[i], " ", "")
            or ""
    end

    -- Return if only current file detected
    if string.match(cmd, "%s$") then
        return
    end
    n_buffers = #files
    arg_idx = vim.fn.argidx()
    print(cmd)
    -- Add files to arglist
    vim.cmd(cmd)
    -- Special-case single file?
    local range = arg_idx + 1 .. "," .. arg_idx + n_buffers
    print(range)
    --let b:bufhidden="hide"
    vim.cmd(range .. 'argdo let b:bufhidden="hide" | bdelete')
    -- Maybe use nvim_buf_call with nvim_buf_delete, but hard to translate arglist to buffers
    --range current to number added
    --argdo b:bufhidden=1
    vim.api.nvim_win_set_buf(0, current_buffer)
end

--Buffer
-- Delete lingering scratch buffers
M.clean_buffers = function(remove_nonempty)
    remove_nonempty = U.utils.default_arg(remove_nonempty, false)
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if not vim.api.nvim_buf_is_loaded(bufnr) then
            local buf_name = vim.api.nvim_buf_get_name(bufnr)
            if remove_nonempty
                or buf_name == ""
                or buf_name == "[Scratch]"
                or buf_name == "[No Name]"
            then
                vim.api.nvim_buf_delete(bufnr, { force = true })
            end
        end
    end
end
-- Buffer
-- Open window to edit ftplugin file for current filetype
M.edit_filetype = function(filetype, extension)
    filetype = U.utils.default_arg(filetype, vim.bo.filetype)
    extension = U.utils.default_arg(extension, "lua")
    if filetype == "" then
        print("Invalid filetype")
        return
    end

    local ftplugin = vim.api.nvim_get_runtime_file("ftplugin", false)
    if #ftplugin == 0 then
        print(U.utils.surround_string(ftplugin) .. " does not exist")
        return
    end
    local file = ftplugin[1] .. "/" .. filetype .. "." .. extension
    -- Works whether or not file exists
    vim.cmd("split " .. file)
end

M.count_bufs_by_type = function(loaded_only)
    loaded_only = (loaded_only == nil and true or loaded_only)
    local count = {
        normal = 0,
        acwrite = 0,
        help = 0,
        nofile = 0,
        nowrite = 0,
        quickfix = 0,
        terminal = 0,
        prompt = 0,
    }
    local buftypes = vim.api.nvim_list_bufs()
    for _, bufname in pairs(buftypes) do
        if (not loaded_only or vim.api.nvim_buf_is_loaded(bufname)) and bufname
        then
            local buftype = vim.api.nvim_buf_get_option(bufname, "buftype")
            buftype = buftype ~= "" and buftype or "normal"
            count[buftype] = count[buftype] + 1
        end
    end
    return count
end

return M
