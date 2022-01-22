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

-- Yank text at end of terminal buffer
term_yank = function(term_id)
    term_id = term_id or vim.g.last_terminal_win_id
    local prompt_line = vim.fn.win_execute(term_id, 'call search(">", "bnW")')
    if prompt_line == '' then
        return
    end
    local text = vim.fn.win_execute(term_id, 'normal ' .. tostring(prompt_line) .. 'gg0f>lvG$y')
    --vim.fn.setreg('+', text)
    return text
end
-- Given a table of global variables, invert the value of each if it exists (1 -> 0, true -> false)

-- TODO handle different scopes (vim['g']), etc.)
toggle_var = function(...)
    local arg = {...}
    for _, var in ipairs(arg) do
        local old = vim.g[var]
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
    local string = vim.fn.input('Enter pattern: ')
    if string.len(string) == 0 then
        return
    end
    local count = vim.v.count1
    local start = vim.fn.getpos('.')
    local flags = 'wz' .. (flags or '')
    -- Search forward or backward; ternary-ish expression
    step= (vim.fn.stridx(flags, 'b') == -1) and 'n' or 'N'

    vim.fn.setreg('/', string)
    local matches = vim.fn.searchcount()['total']
    local stop = math.min(matches, count)

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
    local loaded_only = (loaded_only == nil and true or loaded_only)
    local count = {normal = 0, acwrite = 0, help = 0, nofile = 0,
    nowrite = 0, quickfix = 0, terminal = 0, prompt = 0}
    local buftypes = vim.api.nvim_list_bufs()
    for _, bufname in pairs(buftypes) do
        if ((not loaded_only) or vim.api.nvim_buf_is_loaded(bufname)) and bufname then
            local buftype = vim.api.nvim_buf_get_option(bufname, 'buftype')
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

-- suggested by official guide to automatically escape terminal codes

t = function(str)
    --last arg is "special"
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- Takes a key sequence, executes it in first window in specified
-- direction, then returns to original window
get_opposite_window = function(dir)
    local dir_pairs = {h = "l", l = "h", j = "k", k = "j"}
    return dir_pairs[dir]
end

win_exec = function(keys, dir)
    local count = vim.v.count1
    local reverse = get_opposite_window(dir)
    local command = "normal " ..  tostring(count) .. t(keys)
    -- then window id supplied, not direction
    if reverse == nil then
        vim.fn.win_execute(dir, command)
    else
        vim.cmd("wincmd " .. dir)
        vim.cmd(command)
        vim.cmd("wincmd " .. reverse)
    end
end

-- Building on https://vi.stackexchange.com/questions/21449/send-keys-to-a-terminal-buffer/21466
term_exec = function(keys, scroll_down)
    if vim.g.last_terminal_chan_id == nil then
        return false
    end
    local count =  vim.v.count1
    local command = keys
    scroll_down = scroll_down or true
    if vim.fn.stridx(keys, [[\]]) ~= -1 then
        command = t(keys)
    end
    --vim.fn.chansend(vim.g.last_terminal_chan_id, t('<CR>'))
    print(command)
    for  _ = 1, count do
        vim.fn.chansend(vim.g.last_terminal_chan_id, command)
        vim.fn.chansend(vim.g.last_terminal_chan_id, t("<CR>"))
    end
    -- Scroll down if argument specified, useful for long input
    --if scroll_down then vim.fn.win_execute( vim.g.last_terminal_win_id, ' normal G') end
end

-- Wrap an argument in double quotes; do not change the empty string

quote_arg = function(string)
    return string ~= '' and ('"' .. string .. '"') or string
end

jump = function(pattern, offset, flags)
    local newpos = vim.fn.search(pattern, flags)
    if newpos == 0 then
        return
    end
    vim.fn.setpos('.', {0, newpos + offset, 0, 0})
end

--add_note = function(search)
    --vim.cmd('Znote ' .. search)
    --    Get note from key, save to varaible, process
    --    let local zotkey = zotcite#FindCitationKey(a:key)
    --            let local repl = py3eval('ZotCite.GetNotes("' . zotkey . '")')
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
    local summary = {}

    for _, bufname in pairs(vim.api.nvim_list_bufs()) do
        local value = vim.api.nvim_buf_get_option(bufname, opt)
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
    --Window commands glitch command editing window
    --if vim.fn.bufexists('[Command Line]') then return end
    local arg = {...}
    local cmd = arg[1]
    local count = arg[2] or vim.v.count1
    if count > 1 then
        if string.find(cmd, "normal", 1) then
             cmd = string.gsub(cmd, "normal%s+", "normal " .. tostring(count))
        else
             cmd = tostring(count) .. arg[1]
    end
    end
    vim.cmd(cmd)
end

reinstall = function(plug)
    local line = vim.fn.search(quote_args(plug))
    if line == 0 then
        print('Could not find plugin' .. plug)
        return
    end
    vim.cmd('normal I')
end

get_input = function(str)
    local input = vim.fn.input("Enter expansion for " .. str)
end

-- Append abbreviation to abbreviations file
add_abbrev = function(abbrev, expansion)
    if expansion == nil then
        local expansion = vim.fn.input('Enter expansion for abbreviation ' .. quote_arg(abbrev) .. ": ")
    end
    -- vim command to sub in new abbreviation at end of abbreviation chunk
    local cmd = [[$-1 s/$/\rinoreabbrev ]] .. abbrev .. ' ' .. expansion  .. '/'
    local cmd = ("nvim -c '" .. cmd .. "' -c 'wq' /home/rheslin/dotfiles/nvim/lua/abbrev.lua")
    vim.fn.system(cmd)
    print('\nAdded abbreviation ' .. quote_arg(expansion) .. ' for ' .. quote_arg(abbrev))
end

no_jump = function()
    local cmd = 'normal ' .. vim.fn.input("Normal command: ")
    print('\n')
    local pos = vim.fn.getpos('.')
    repeat_cmd(cmd)
    vim.fn.setpos('.', pos)
end
refresh = function(file)
    -- https://codereview.stackexchange.com/questions/90177/get-file-name-with-extension-and-get-only-extension
    local file = file or vim.fn.expand('%:p')
    local extension = vim.bo.filetype
    local cmd = ""
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

-- Mostly copied from https://vi.stackexchange.com/questions/11310/what-is-a-scratch-window
-- Makes a scratch buffer
make_scratch = function(command_fn)
    vim.cmd('split')
    vim.bo.swapfile = false
    vim.cmd('enew')
    vim.bo.buftype = 'nofile'
    vim.bo.bufhidden = 'hide'
    vim.bo.buflisted = false
    vim.cmd('lcd ' .. vim.fn.expand('$HOME'))
    if command_fn then  command_fn() end
end

-- Dump messages to scratch buffer
capture_messages = function()
    vim.cmd('redir @z')
    vim.cmd('silent messages')
    make_scratch('put z')
    vim.cmd('redir end')
end

-- Open scratch buffer containing terminal history so you can browse and rerun commands
-- TODO fix syntax highlighting in scratch
term_edit = function(history_command, syntax)
    history_command = history_command or 'history -w /tmp/history.txt'
    syntax = syntax or 'bash'
    term_exec(history_command)
    make_scratch(compose_commands("read /tmp/history.txt",
    "setlocal number syntax=" .. syntax,
    "normal G"
    ))
end


get_pair = function(char)
    local pairs_mapping = {[ '(' ] = ')', [ '[' ] = ']',
    [ '{' ] = '}',
    [ "' "] = "'",
    ['"'] = '"',
    ['<'] = '>'}
return pairs_mapping[char] or ''
end

get_char = function(offset, mode)
    --Given an editor mode and offset, returns the character {offset} columns from the current character in the current line in that mode
    local offset = offset or 0
    if mode == 'n' then
        local which = vim.fn.col('.') + offset
        return string.sub(vim.fn.getline('.'), which, which)
    elseif mode == "c" then
        local which = vim.fn.getcmdpos() + offset
        return string.sub(vim.fn.getcmdline(), which, which)
    end
end

-- Given a a pair-opening character like "(", inserts the character if the next character is alphanumeric
-- Otherwise, inserts the character and its closing pair, then moves the cursor between them
expand_pair = function(char, mode)
    --Credit  https://stackoverflow.com/questions/23323747/vim-vimscript-get-exact-character-under-the-cursor
    local next_char= get_char(1, mode)
    local out
    if string.find(next_char, '%w')  then
        out =  char
    --elseif next_char == ")" then
     --   out = '<Right>'
    else
        out =  char .. get_pair( char ) .. t('<left>')
    end
    --vim.cmd('echom' .. quote_arg(out))
    return out
end

match_pair = function(char, mode)
    local next_char = get_char(1, mode)
    return next_char == char and  t('<right>') or char
end

compose_commands = function(...)
    local args = {...}
    return function(...)
        for _, cmd in ipairs(args) do
            vim.cmd(cmd)
        end
    end
end

surround = function()
    vim.fn.setline('.', vim.fn.input('function: ') .. '(' ..  vim.fn.getline('.') .. ')')
end

--TODO put input function name
 -- Build an R character vector or list from optionally named, unquoted arguments,
 -- quoting automatically
vec = function()
    compose_commands([[s/\([^ =]\+\)/"\1"/g]],
[[s/\("[^ =]\+"\)\ze\s\+[^=]/\1,/g]])()
    surround()
end


yank_visual = function(register)
    register = register or '+'
    vim.cmd('normal "' .. register .. 'gvy' )
    out= vim.fn.getreg(register)
    return out
end
