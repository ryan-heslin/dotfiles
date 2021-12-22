set_term_opts = function()
    vim.cmd("startinsert")
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.spell = false
    -- Globals respectively indicating  buffer, channel, and window ID of last terminal entered
    vim.g.last_terminal_buf_id = vim.fn.bufnr()
    vim.g.last_terminal_chan_id = vim.b.terminal_job_id
    vim.g.last_terminal_win_id = vim.fn.bufwinid(vim.g.last_terminal_buf_id)
end

-- Last error message
last_message = function(n)

end
-- Yank text at end of terminal buffer
term_yank = function(term_id)
    prompt_line = vim.fn.win_execute(term_id, 'call search(">", "bnW")')
    if prompt_line == 0 then
        return
    end
    text = vim.fn.win_execute(term_id, 'normal ' .. tostring(prompt_line) .. 'gg0f>lvG$y')
    --vim.fn.setreg('+', text)
    return text
end
-- Given a table of global variables, invert the value of each if it exists (1 -> 0, true -> false)
-- TODO handle different scopes (vim['g']), etc.)
toggle_var = function(...)
    arg = {...}
    for _, var in ipairs(arg) do
        old = vim.g[var]
        if old ~= nil then
            if old == 0 or old == 1 then
                vim.g[var] = (old  + 1 ) % 2
            elseif type(old) == 'boolean' then
                vim.g[var] = not old
            else
                print("Variable " .. var .. "is not 0, 1, true, or false")
            end
        else
            print('Variable ' .. var .. ' is not set')
        end
    end
end

jump_delete = function(flags)
    count = vim.v.count1
    string = vim.fn.input('Enter pattern: ')
    if string.len(string) == 0 then
        return
    end
    start = vim.fn.getpos('.')
    flags = 'wz' .. (flags or '')
    -- Search forward or backward; ternary-ish expression
    step= (vim.fn.stridx(flags, 'b') == -1) and 'n' or 'N'

    vim.fn.setreg('/', string)
    matches = vim.fn.searchcount()['total']
    stop = math.min(matches, count)

    -- Search for next match {count} times
    for _  = 0, stop - 1 do
        vim.cmd('normal ' .. step)
        vim.cmd( 'normal gnx' )
    end

    vim.fn.setpos('.', start)
    vim.fn.setreg('/', {})
    print('Removed ' .. stop .. ' match(es)')
end

    count_bufs_by_type = function(loaded_only)
        loaded_only = (loaded_only == nil and true or loaded_only)
        count = {normal = 0, acwrite = 0, help = 0, nofile = 0,
        nowrite = 0, quickfix = 0, terminal = 0, prompt = 0}
        buftypes = vim.api.nvim_list_bufs()
        for _, bufname in pairs(buftypes) do
           if (not loaded_only) or vim.api.nvim_buf_is_loaded(bufname) then
               buftype = vim.api.nvim_buf_get_option(bufname, 'buftype')
               buftype = buftype ~= '' and buftype or 'normal'
               count[buftype] = count[buftype] + 1
           end
        end
        return count
    end


close_bufs_by_type = function(buftype)
    for _, bufname in pairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_get_option(bufname, "buftype") == buftype then
            vim.cmd("bdelete " .. bufname)
        end
    end
end

-- suggested by official guide

t = function(str)
    --last arg is "special"
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- Takes a key sequence, executes it in first window in specified
-- direction, then returns to original window
get_opposite_window = function(dir)
    dir_pairs = {h = "l", l = "h", j = "k", k = "j"}
    return dir_pairs[dir]
end

win_exec = function(keys, dir)
    count = vim.v.count1
    reverse = get_opposite_window(dir)
    command = "normal " ..  tostring(count) .. t(keys)
    -- then window id supplied, not direction
    if reverse == nil then
        vim.fn.win_execute(dir, command)
    else
        vim.cmd("wincmd " .. dir)
        vim.cmd(command)
        vim.cmd("wincmd " .. dir_pairs[dir])
    end
end

-- Building on https://vi.stackexchange.com/questions/21449/send-keys-to-a-terminal-buffer/21466
term_exec = function(keys)
    if vim.g.last_terminal_chan_id == nil then
        return false
    end
    count =  vim.v.count1
    command = keys
    if vim.fn.stridx(keys, [[\]]) ~= -1 then
        command = t(keys)
    end
    for _ = 0, count do
        vim.fn.chansend(vim.g.last_terminal_chan_id, command)
    end
    vim.fn.chansend(vim.g.last_terminal_chan_id, t("<CR>"))
end

-- Wrap an argument in double quotes; do not change the empty string

quote_arg = function(string)
    return string ~= '' and ('"' .. string .. '"') or string
end

jump = function(pattern, offset, flags)
    newpos = vim.fn.search(pattern, flags)
    if newpos == 0 then
        return
    end
    vim.fn.setpos('.', {0, newpos + offset, 0, 0})
end

--add_note = function(search)
    --vim.cmd('Znote ' .. search)
    --    Get note from key, save to varaible, process
    --    let zotkey = zotcite#FindCitationKey(a:key)
    --            let repl = py3eval('ZotCite.GetNotes("' . zotkey . '")')
    --            Does not recognize valid key - why?
-- end
--
-- Toggle option limited to one of two values.
toggle_opt = function(opt, val1, val2)
    if vim.o[opt] == val1 then
        vim.o[opt] = val2
    elseif vim.o[opt] == val1 then
        vim.o[opt] = val2
    else
        print("Don't know how to handle option " .. opt .. " with value" .. str(vim.o[opt]))
    end
end
-- Count each value of a given option across all buffers
summarize_option = function(opt)
    if not pcall(function() vim.api.nvim_buf_get_option(0, opt) end) then
        print('Invalid option ' .. opt)
        return
    end
    summary = {}

    for _, bufname in pairs(vim.api.nvim_list_bufs()) do
        value = vim.api.nvim_buf_get_option(bufname, opt)
        if summary[value] == nil then
            --table.insert(summary, value)
            summary[value] = 1
        else
            summary[value] = summary[value] + 1
        end
    end
    return summary
end

repeat_cmd = function(...)
    local arg = {...}
    cmd = arg[1]
    count = arg[2] or vim.v.count1
    if count > 1 then
        if string.find(cmd, "normal", 1) then
            cmd = string.gsub(cmd, "normal%s+", "normal " .. tostring(count))
        else
            cmd = tostring(count) ..arg[1]
    end
    end
    vim.cmd(cmd)
end

reinstall = function(plug)
    line = vim.fn.search(quote_args(plug))
    if line == 0 then
        print('Could not find plugin' .. plug)
        return
    end
    vim.cmd('normal I')
end

get_input = function(str)
    input = vim.fn.input("Enter expansion for " .. str)
end
-- Append abbreviation to abbreviations file
add_abbrev = function(abbrev, expansion)
    if expansion == nil then
        expansion = vim.fn.input('Enter expansion for abbreviation ' .. quote_arg(abbrev) .. ": ")
    end
    -- vim command to sub in new abbreviation at end of abbreviation chunk
    cmd = [[$-1 s/$/\rinoreabbrev ]] .. abbrev .. ' ' .. expansion  .. '/'
    cmd = ("nvim -c '" .. cmd .. "' -c 'wq' /home/rheslin/dotfiles/nvim/lua/abbrev.lua")
    vim.fn.system(cmd)
    print('\nAdded abbreviation ' .. quote_arg(expansion) .. ' for ' .. quote_arg(abbrev))
end

no_jump = function()
    cmd = 'normal ' .. vim.fn.input("Normal command: ")
    print('\n')
    pos = vim.fn.getpos('.')
    repeat_cmd(cmd)
    vim.fn.setpos('.', pos)
end

refresh = function(file)
    -- https://codereview.stackexchange.com/questions/90177/get-file-name-with-extension-and-get-only-extension
    file = file or vim.fn.expand('%:p')
    extension = vim.o.filetype
    if extension == 'R' or extension == 'r' then
        cmd = 'Rsend source("' ..file .. '")'
    elseif extension == 'python' then
        cmd = 'IPythonCellRun'
    elseif extension == 'bash' or extension == 'sh' then
        cmd = '!. ' .. file
    elseif extension == 'lua' or extension == 'vim' then
        cmd = 'source ' .. file
    else
        print('Don\'t know how to handle extension ' .. extension)
        return
    end
    vim.cmd(cmd)
end
