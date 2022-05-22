M = {}
local a = require("plenary.async")
-- TODO make table of vim filetypes and standard extensions
-- Wrapper that checks and restores the current register and type.
-- TODO fix
M.with_register = function(func)
    return function(...)
        local old_register = vim.v.register
        local old_register_value = vim.fn.getreg(old_register)
        local old_register_type = vim.fn.getregtype(old_register)
        out = func(...)
        vim.fn.setreg(old_register, old_register_value, old_register_type)
        return out
    end
end

-- Returns function that retrieves table element keyed to filetype, then calls another function with that value
M.switch_filetype = function(mapping, default)
    return function(func)
        local mapping = mapping
        return function(...)
            local value = mapping[vim.bo.filetype]
            local default = M.default_arg(default, nil)
            value = M.default_arg(value, default)
            return func(value, ...)
        end
    end
end

-- TODO make named tables, for matched indexing
M.invert_logical = M.switch_filetype({
    r = { "TRUE", "FALSE" },
    rmd = { "TRUE", "FALSE" },
    python = { "True", "False" },
    lua = { "true", "false" },
})

M.swap_word = function(mapping)
    vim.cmd("normal yiw")
    local word = vim.fn.getreg("+")
    print(word)
    local swap = nil
    if word == mapping[1] then
        swap = mapping[2]
    elseif word == mapping[2] then
        swap = mapping[1]
    end
    if swap ~= nil then
        vim.cmd("normal ciw" .. swap)
    end
end

M.swap_logical = M.invert_logical(swap_word)
-- false

-- Make coroutine?
M.repeat_action = function(func, args, interval)
    local interval = interval or 10
    local cmd = "sleep " .. interval
    while true do
        func(unpack(args))
        vim.cmd(cmd)
    end
end

-- Using NVim-R plugin, call R function on word beneath cursor
M.r_exec = function(cmd, clear_output)
    if not os.getenv("NVIMR_ID") then
        print("Nvim-R is not running")
        return
    end
    local clear_output = M.default_arg(clear_output, true)
    vim.call("RAction", cmd)
    if clear_output then
        vim.cmd("silent RSend 0")
    end
end

--Wrap a function so it may be called safely
M.safe_call = function(func, ...)
    local pre_args = { ... }
    return function(...)
        return pcall(func, ...)
    end
end

M.set_term_opts = function()
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
M.term_yank = function(term_id)
    local term_id = M.default_arg(term_id, vim.g.last_terminal_win_id)
    local prompt_line = vim.fn.win_execute(term_id, 'call search(">", "bnW")')
    if prompt_line == "" then
        return ""
    end
    local text = vim.fn.win_execute(
        term_id,
        "normal " .. tostring(prompt_line) .. "gg0f>lvG$y"
    )
    --vim.fn.setreg('+', text)
    return text
end
-- Given a table of global variables, invert the value of each if it exists (1 -> 0, true -> false)

-- TODO handle different scopes (vim['g']), etc.)
M.toggle_var = function(...)
    local arg = { ... }
    for _, var in ipairs(arg) do
        local old = vim.g[var]
        if old ~= nil then
            if old == 0 or old == 1 then
                vim.g[var] = (old + 1) % 2
            elseif type(old) == "boolean" then
                vim.g[var] = not old
            else
                print("Variable " .. var .. "is not 0, 1, true, or false")
            end
        else
            print("Variable " .. var .. " is not set")
        end
    end
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
    local flags = "wz" .. (flags or "")
    -- Search forward or backward; ternary-ish expression
    step = (vim.fn.stridx(flags, "b") == -1) and "n" or "N"

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

M.count_bufs_by_type = function(loaded_only)
    local loaded_only = (loaded_only == nil and true or loaded_only)
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
        if
            (not loaded_only or vim.api.nvim_buf_is_loaded(bufname)) and bufname
        then
            local buftype = vim.api.nvim_buf_get_option(bufname, "buftype")
            buftype = buftype ~= "" and buftype or "normal"
            count[buftype] = count[buftype] + 1
        end
    end
    return count
end

M.switch_to_buffer = function(pattern)
    -- TODO rewrite with nvim_list_bufs
    local bufs = M.grep_output("ls", false, pattern)
    if bufs == nil then
        print("No active buffers matched " .. pattern)
        return
    end
    print(vim.inspect(bufs))
    local buf_number = string.sub(bufs[1], string.find(bufs[1], "^%s*%d+"))
    vim.cmd("b" .. buf_number)
end

M.close_bufs_by_type = function(buftype)
    for _, bufname in pairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_get_option(bufname, "buftype") == buftype then
            vim.cmd("bdelete " .. bufname)
        end
    end
end

-- suggested by official guide to automatically escape terminal codes

M.t = function(str)
    --last arg is "special"
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- Takes a key sequence, executes it in first window in specified
-- direction, then returns to original window
M.get_opposite_window = function(dir)
    local dir_pairs = { h = "l", l = "h", j = "k", k = "j" }
    return dir_pairs[dir]
end

M.win_exec = function(keys, dir)
    local keys = keys
    if keys == nil then
        keys = vim.fn.input("Window command: ")
    end
    local count = vim.v.count1
    local command = string.gsub(
        M.t(keys),
        "^normal%s",
        "normal " .. tostring(count),
        1
    )
    -- If window targeted by number instead of relative direction, just execute command
    if type(dir) == "number" then
        vim.fn.win_execute(dir, command)
        return
    end
    -- Switch to window, execute command, switch back
    local this_window = vim.api.nvim_win_get_number(0)
    vim.cmd("wincmd " .. dir)
    print(command)
    vim.cmd(command)
    vim.cmd(this_window .. "wincmd w")
end

-- Building on https://vi.stackexchange.com/questions/21449/send-keys-to-a-terminal-buffer/21466
M.term_exec = function(keys, scroll_down)
    if vim.g.last_terminal_chan_id == nil then
        return false
    end
    local count = vim.v.count1
    local command = keys
    scroll_down = scroll_down or true
    if vim.fn.stridx(keys, [[\]]) ~= -1 then
        command = M.t(keys)
    end
    --vim.fn.chansend(vim.g.last_terminal_chan_id, M.t('<CR>'))
    for _ = 1, count, 1 do
        vim.fn.chansend(vim.g.last_terminal_chan_id, command)
    end
    vim.fn.chansend(vim.g.last_terminal_chan_id, M.t("<CR>"))
    -- Scroll down if argument specified, useful for long input
    if scroll_down then
        vim.fn.win_execute(vim.g.last_terminal_win_id, " normal G")
    end
end

M.default_arg = function(arg, default)
    return arg ~= nil and arg or default
end

-- double controls whether to concatenate if string already has prefix/suffix
M.surround_string = function(string, prefix, postfix, double)
    local prefix = M.default_arg(prefix, "'")
    local postfix = M.default_arg(postfix, "'")
    local double = M.default_arg(double, false)
    prefix = (double or string.sub(string, 1, 1) ~= prefix) and prefix or ""
    postfix = (double or string.sub(string, -1, -1) ~= postfix) and postfix
        or ""
    return string ~= "" and (prefix .. string .. postfix) or string
end

-- Modify register with function
M.modify_register = function(func, register, ...)
    local register = M.default_arg(register, "+")
    local current = vim.fn.getreg(register)
    local new = func(current, ...)
    vim.fn.setreg(register, new)
    return new
end

M.jump = function(pattern, offset, flags)
    local newpos = vim.fn.search(pattern, flags)
    if newpos == 0 then
        return
    end
    vim.fn.setpos(".", { 0, newpos + offset, 0, 0 })
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
M.toggle_opt = function(opt, val1, val2)
    if vim.o[opt] == val1 then
        vim.o[opt] = val2
    elseif vim.o[opt] == val1 then
        vim.o[opt] = val2
    else
        print(
            "Don't know how to handle option "
                .. opt
                .. " with value"
                .. str(vim.o[opt])
        )
    end
end
-- Count each value of a given option across all buffers
M.summarize_option = function(opt)
    if
        not pcall(function()
            vim.api.nvim_buf_get_option(0, opt)
        end)
    then
        print("Invalid option " .. opt)
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

M.repeat_cmd = function(...)
    --Window commands glitch command editing window
    --if vim.fn.bufexists('[Command Line]') then return end
    local arg = { ... }
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

M.reinstall = function(plug)
    local line = vim.fn.search(surrounds(plug))
    if line == 0 then
        print("Could not find plugin" .. plug)
        return
    end
    vim.cmd("normal I")
end

M.get_input = function(str)
    local input = vim.fn.input("Enter expansion for " .. str)
end

-- Append abbreviation to abbreviations file
M.add_abbrev = function(abbrev, expansion)
    if expansion == nil then
        local expansion = vim.fn.input(
            "Enter expansion for abbreviation "
                .. M.surround_string(abbrev, '"', '"')
                .. ": "
        )
    end
    -- vim command to sub in new abbreviation at end of abbreviation chunk
    local cmd = [[$-1 s/$/\rinoreabbrev ]] .. abbrev .. " " .. expansion .. "/"
    local cmd = (
        "nvim -c '"
        .. cmd
        .. "' -c 'wq' /home/rheslin/dotfiles/nvim/lua/abbrev.lua"
    )
    vim.fn.system(cmd)
    print(
        "\nAdded abbreviation "
            .. M.surround_string(expansion, '"', '"')
            .. " for "
            .. M.surround_string(abbrev, '"', '"')
    )
end

M.no_jump = function(cmd)
    local cmd = cmd or "normal " .. vim.fn.input("Normal command: ")
    print("\n")
    local old_pos = vim.fn.getpos(".")
    M.repeat_cmd(cmd)
    vim.fn.setpos(".", old_pos)
end
M.no_jump_safe = M.safe_call(no_jump)

M.refresh = function(file)
    -- https://codereview.stackexchange.com/questions/90177/get-file-name-with-extension-and-get-only-extension
    local file = file or vim.fn.expand("%:p")
    local extension = vim.bo.filetype
    local cmd = ""
    if extension == "R" or extension == "r" then
        cmd = 'RSend source("' .. file .. '")'
    elseif extension == "python" then
        cmd = "IPythonCellRun"
    elseif extension == "bash" or extension == "sh" then
        cmd = "!. " .. file
    elseif extension == "lua" or extension == "vim" then
        cmd = "source " .. file
    else
        print("Don't know how to handle extension " .. extension)
        return
    end
    vim.cmd(cmd)
end

-- Mostly copied from https://vi.stackexchange.com/questions/11310/what-is-a-scratch-window
-- Makes a scratch buffer
M.make_scratch = function(command_fn, ...)
    local args = { ... }
    vim.cmd("split")
    vim.bo.swapfile = false
    vim.cmd("enew")
    vim.bo.buftype = "nofile"
    vim.bo.bufhidden = "hide"
    vim.bo.buflisted = false
    vim.cmd("lcd " .. vim.fn.expand("$HOME"))
    if command_fn then
        command_fn()
    end
end

-- Dump command output to scratch buffer
M.capture_output = function(cmd)
    local output = vim.fn.execute(cmd)
    vim.fn.setreg("z", output)
    func = function()
        vim.cmd("put z")
    end
    M.make_scratch(func)
end
capture_output = M.with_register(capture_output)

-- Open scratch buffer containing terminal history so you can browse and rerun commands
-- TODO fix syntax highlighting in scratch
M.term_edit = function(history_command, syntax)
    history_command = history_command or "history -w /tmp/history.txt"
    syntax = syntax or "bash"
    M.term_exec(history_command)
    M.make_scratch(
        compose_commands(
            "read /tmp/history.txt",
            "setlocal number syntax=" .. syntax,
            "normal G",
            "autocmd "
        )
    )
end

M.get_pair = function(char)
    local pairs_mapping = {
        ["("] = ")",
        ["["] = "]",
        ["{"] = "}",
        ["' "] = "'",
        ['"'] = '"',
        ["<"] = ">",
    }
    return pairs_mapping[char] or ""
end

M.get_char = function(offset, mode)
    --Given an editor mode and offset, returns the character {offset}
    --columns from the current character in the current line in that mode
    local which = offset or 0
    local mode = mode or vim.fn.mode()
    local out
    if mode == "n" then
        which = which + vim.fn.col(".")
        out = string.sub(vim.fn.getline("."), which, which)
    elseif mode == "c" then
        which = which + vim.fn.getcmdpos()
        out = string.sub(vim.fn.getcmdline(), which, which)
    end
    return out
end

-- Given a pair-opening character like "(", inserts the character if the next character is alphanumeric
-- Otherwise, inserts the character and its closing pair, then moves the cursor between them
M.expand_pair = function(char, mode)
    --Credit  https://stackoverflow.com/questions/23323747/vim-vimscript-get-exact-character-under-the-cursor
    local next_char = M.get_char(1, mode)
    out = string.find(next_char, "%w") and char
        or char .. M.get_pair(char) .. M.t("<left>")
    return out
end

--Move cursor one index right if next character matches char position, otherwise put character
M.match_pair = function(char)
    local next_char = get_char(1)
    return next_char == char and M.t("<right>") or char
end

M.compose_commands = function(...)
    local args = { ... }
    return function(...)
        for _, cmd in ipairs(args) do
            vim.cmd(cmd)
        end
    end
end

M.surround = function()
    vim.fn.setline(
        ".",
        vim.fn.input("function: ") .. "(" .. vim.fn.getline(".") .. ")"
    )
end

--TODO put input function name
-- Build an R character vector or list from optionally named, unquoted arguments,
-- quoting automatically
M.vec = function()
    M.compose_commands(
        [[s/\([^ =]\+\)/"\1"/g]],
        [[s/\("[^ =]\+"\)\ze\s\+[^=]/\1,/g]]
    )()
    M.surround()
end

M.yank_visual = function(register)
    register = register or '"'
    -- Only use quote mark notation if not using unnamed register
    sub = register ~= '"' and '"' .. register or ""
    vim.cmd("normal " .. sub .. "gvy")
    return vim.fn.getreg(register)
end
yank_visual = M.with_register(yank_visual)

-- Translated from https://vim.fandom.com/wiki/Search_for_visually_selected_text
M.visual_search = function(target)
    target = target or "/"
    text = vim.fn.substitute(yank_visual(), [[\_s\+]], " ", "g")
    pcall(function()
        vim.fn.setreg(target, text)
        vim.cmd("normal n")
    end, print("No matches"))
end

-- From https://stackoverflow.com/questions/4990990/check-if-a-file-exists-with-lua
M.file_exists = function(name)
    if name == nil then
        return false
    end
    local f = io.open(name, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

M.make_session = function()
    vim.b.sessiondir = os.getenv("HOME") .. "/.vim/sessions" .. vim.fn.getcwd()
    if vim.fn.filewritable(vim.b.sessiondir) ~= 2 then
        vim.cmd("silent !mkdir -p " .. vim.b.sessiondir)
        vim.cmd("redraw!")
    end
    vim.b.filename = vim.b.sessiondir .. "/session.vim"
    vim.cmd("mksession! " .. vim.b.filename)
end

-- From https://stackoverflow.com/questions/1642611/how-to-save-and-restore-multiple-different-sessions-in-vim, with my modifications
M.save_session = function()
    local session_dir = os.getenv("VIM_SESSION_DIR")
    if session_dir == nil then
        print("Session directory not specified")
        return
    end
    local this_session = vim.g.current_session
        or (vim.v.this_session ~= "" and vim.fn.systemlist( --Check if session file exists with current session name
            'basename -s ".vim" ' .. M.surround_string(vim.v.this_session)
        )[1])
        or nil
    -- If no current session name found, prompt user for one, warning if already in use
    local name_provided = false
    if this_session == nil then
        local ok, this_session = pcall(
            vim.fn.input("Enter session name (enter to skip): ")
        )
        if not ok then
            print("\n Error saving session")
            return
        elseif this_session == "" then
            print("\nInvalid session name")
            return
        end
        name_provided = true
    end
    local current_session = this_session

    local path = session_dir .. "/" .. current_session .. ".vim"
    if name_provided and file_exists(path) then
        local choice = vim.fn.input(
            "Session "
                .. M.surround_string(current_session)
                .. " already exists. Overwrite (y to overwrite, any other key to abort)? "
        )
        if choice ~= "y" then
            return
        end
    end
    vim.g.current_session = current_session
    vim.cmd("mksession! " .. path)
end

M.load_session = function()
    local session_dir = os.getenv("VIM_SESSION_DIR")
    if session_dir == nil then
        print("Session directory not specified")
        return
    end
    -- Shell-quote for safety
    local latest_session = vim.fn.systemlist(
        "lastn " .. session_dir .. " 1 echo"
    )[1]
    local session_name = vim.fn.systemlist(
        "basename -s '.vim' " .. M.surround_string(latest_session)
    )[1]
    local safe_source = function(file)
        vim.cmd("source " .. file)
    end
    print(session_name)
    if not pcall(safe_source, M.surround_string(latest_session)) then
        print(
            "Session file "
                .. M.surround_string(latest_session)
                .. " does not exist or cannot be read"
        )
        return
    end
    vim.g.current_session = session_name
    print("Loading session " .. session_name)
end

-- Knit an Rmarkdown file
M.knit = function(file, quiet, view_result)
    -- We have to get the full path of the output in case the YAML specifies a different output directory

    local file = M.default_arg(file, vim.g.last_rmd)
    if not M.file_exists(file) then
        print(M.surround_string(file) .. " does not exist")
        return
    end
    local view_result = M.default_arg(view_result, true)
    vim.cmd("wa")
    print("Knitting " .. file)
    local args = "-e"
    args = quiet and "--silent " .. args or args
    local outfile = vim.fn.system(
        [[R ]]
            .. args
            .. [[ 'cat(rmarkdown::render("]]
            .. file
            .. [["), "\n") &']]
    )
    -- Bail out on knit error
    -- if vim.v:shell_error != 0 then
    --  print('Error knitting ' . filename)
    -- return
    -- end
    outfile = string.match(
        outfile,
        M.surround_string(os.getenv("HOME") .. "/.*%.pdf", "\n(", ")")
    )

    if file_exists(outfile) then
        print("Rendered " .. M.surround_string(outfile))
        if view_result then
            vim.cmd("!zathura " .. vim.fn.shellescape(outfile) .. " &")
        end
    end
end

M.count_pairs = function(str, char, close)
    local open = 0
    for i = 1, string.len(str) do
        cur = string.sub(str, i, i)
        if cur == char then
            open = open + 1
        elseif cur == close then
            open = open - 1
        end
        --TODO find correct stopping condition
        if
            open < 1
            and not string.find(string.sub(str, i + 1, -1), "%" .. close)
        then
            return i
        end
    end
    return string.len(str)
end
-- TODO fix no closing case, slowness, do mapping
M.match_paren = function()
    local char = get_char(0)
    local line = vim.fn.getline(".")
    local remainder = string.sub(line, vim.fn.col("."), -1)
    local close = get_pair(char)
    --pattern = char .. '.[^' .. char ..']+' .. close
    if string.len(remainder) == 1 then
        vim.fn.setline(".", line .. close)
        return
    end
    local i = M.count_pairs(string.sub(remainder, 2, -1), char, close) + 1

    --Insert closing character at appropriate position
    vim.fn.setline(
        ".",
        string.sub(line, 1, vim.fn.col(".") - 1)
            .. string.sub(remainder, 1, i)
            .. close
            .. string.sub(remainder, i + 1, -1)
    )
end
--if string.find(remainder,  pattern ) then
--vim.cmd('normal f' .. char .. '%a' .. close)
--else
--vim.cmd('normal $a' .. close)
--end
--end
--summary(fun(inner(mean(x, y, z)), fun2(y))
--summary(a, b, c, d, e

M.dump_args = function()
    signature = vim.fn.getline(".")
    --TODO
end

-- Display lines of command output (e.g., autocmd) matching pattern
M.grep_output = function(cmd, print_output, ...)
    local patterns = { ... }
    local output = vim.fn.execute(cmd)
    --output = str_split(output)
    local out = {}
    -- From https://stackoverflow.com/questions/45143191/lua-gmatch-multi-line-string
    for line in string.gmatch(output, "[^\r\n]+") do
        for _, pat in ipairs(patterns) do
            if string.find(line, pat) then
                table.insert(out, line)
                break
            end
        end
    end
    if print_output or print_output == nil then
        M.print_table(out)
    else
        return out
    end
end

-- TODO recursively print tables
M.inspect = function(x)
    print(vim.inspect(x))
end

M.print_table = function(table)
    for i, val in ipairs(table) do
        if type(val) ~= "table" then
            print(val)
        else
            M.print_table(val)
        end
    end
end

-- Standard string split. Credit https://stackoverflow.com/questions/1426954/split-string-in-lua
M.str_split = function(string, sep)
    local sep = sep or " "
    local out = {}
    for str in string.gmatch(string, sep) do
        table.insert(out, str)
    end
    return out
end
-- Evaluate inline R code chunk
M.inline_send = function()
    if not os.getenv("NVIMR_ID") then
        print("Nvim-R is not running")
        return
    end
    local old_pos = vim.fn.getpos(".")
    vim.cmd([[normal F`2w"zyt`]]) -- "just to fix syntax highlighting
    vim.cmd("RSend " .. vim.fn.getreg("z"))
    vim.fn.setpos(".", old_pos)
end

M.open_in_hidden = function(pattern)
    local current_file = vim.fn.expand("%")
    -- Default to matching current file extension
    local pattern = M.default_arg(
        pattern,
        "*" .. string.sub(current_file, string.find(current_file, "%.[^.]+$"))
    )
    local files = vim.fn.systemlist("ls " .. pattern)
    -- Shell-quote and add all files matched, except current
    local cmd = "argadd"
    local current_buffer = vim.api.nvim_buf_get_number(0)
    for i, _ in ipairs(files) do
        cmd = cmd
                .. (
                    files[i] ~= current_file
                    and M.surround_string(files[i], " ", "")
                )
            or ""
    end

    -- Return if only current file detected
    if string.match(cmd, "%s$") then
        return
    end
    n_buffers = table.getn(files)
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

-- Delete lingering scratch buffers
M.clean_buffers = function(remove_nonempty)
    local ignore_nonempty = M.default_arg(ignore_nonempty, false)
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if not vim.api.nvim_buf_is_loaded(bufnr) then
            local buf_name = vim.api.nvim_buf_get_name(bufnr)
            if
                ignore_nonempty
                or buf_name == ""
                or buf_name == "[Scratch]"
                or buf_name == "[No Name]"
            then
                vim.api.nvim_buf_delete(bufnr, { force = true })
            end
        end
    end
end

-- Based on https://stackoverflow.com/questions/23120266/lua-advancing-to-the-next-letter-of-the-alphabet
-- Finds next free register and saves string in it
M.next_free_register = function(content, start_register)
    local alphabet = "abcdefghijklmnopqrstuvwxyz"
    local content = M.default_arg(content, vim.fn.getreg('"'))
    local start_register = M.default_arg(start_register, "a")
    local start_index = string.find(alphabet, start_register)
    local end_index = 26
    if start_index < 1 or start_index > 26 then
        print("Invalid start register")
        return
    end
    for num = start_index, end_index, 1 do
        local cur = string.sub(alphabet, num, num)
        if vim.fn.getreg(cur) == "" then
            vim.fn.setreg(cur, content)
            print(
                M.surround_string(content, "'", "'") .. " written to @" .. cur
            )
            return content
        end
    end
    print("All registers full")
end

-- Open window to edit ftplugin file for current filetype
M.edit_filetype = function(filetype, extension)
    filetype = M.default_arg(filetype, vim.bo.filetype)
    extension = M.default_arg(extension, "lua")
    if filetype == "" then
        print("Invalid filetype")
        return
    end

    local ftplugin = vim.api.nvim_get_runtime_file("ftplugin", false)
    if table.getn(ftplugin) == 0 then
        print(M.surround_string(ftplugin) .. " does not exist")
        return
    end
    local file = ftplugin[1] .. "/" .. filetype .. "." .. extension
    -- Works whether or not file exists
    vim.cmd("split " .. file)
end

-- Check conditions for saving session
M.do_save_session = function(min_buffers)
    min_buffers = M.default_arg(min_buffers, 2)
    if
        M.count_bufs_by_type(true)["normal"] >= min_buffers
        and M.summarize_option("ft")["anki_vim"] == nil
    then
        M.save_session()
    end
end

--From Reddit user vonheikemen
--load = function(mod)
--package.loaded[mod] = nil
--return require(mod)
--end

--Reddit user Rafat913
M.open_uri_under_cursor = function()
    local function open_uri(uri)
        if type(uri) ~= "nil" then
            uri = string.gsub(uri, "#", "\\#") --double escapes any # signs
            uri = '"' .. uri .. '"'
            vim.cmd("!xdg-open " .. uri .. " > /dev/null")
            vim.cmd("mode")
            -- print(uri)
            return true
        else
            return false
        end
    end

    local word_under_cursor = vim.fn.expand("<cWORD>")

    -- any uri with a protocol segment
    local regex_protocol_uri = "%a*:%/%/[%a%d%#%[%]%-%%+:;!$@/?&=_.,~*()]*"
    if open_uri(string.match(word_under_cursor, regex_protocol_uri)) then
        return
    end

    -- consider anything that looks like string/string a github link
    local regex_plugin_url = "[%a%d%-%.%_]*%/[%a%d%-%.%_]*"
    if
        open_uri(
            "https://github.com/"
                .. string.match(word_under_cursor, regex_plugin_url)
        )
    then
        return
    end
end
--vim.api.nvim_create_user_command('open_uri_under_cursor', open_uri_under_cursor, {})
--#region
--#region

M.clamp = function(x, lower, upper)
    return math.min(math.max(x, lower), upper)
end

-- Given a command and number, applies the command to the range of lines between the current line and
-- the number inclusive, clamping to file length
M.range_command = function(command, range, invert)
    range = M.default_arg(range, vim.v.count1)
    invert = M.default_arg(invert, false)
    local bound = (invert and -1 * range) or range
    local current_line = vim.fn.line(".")
    bound = M.clamp(current_line + bound, 1, vim.fn.line("$")) - current_line
    -- Needed to avoid range-swapping prompt
    if bound < 0 then
        bound = current_line + bound .. "," .. current_line
    else
        bound = ".,.+" .. bound
    end
    vim.cmd(bound .. " normal " .. command)
end
