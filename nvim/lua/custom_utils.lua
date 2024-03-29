--Data
U = {}
-- Records most recent window, buffer filetype, etc.
U.recents = { window = nil, filetype = {}, terminal = {} }

-- Default option values
U.defaults = { operatorfunc = "v:lua.require'nvim-surround'.normal_callback" }

-- Set default option recorded in global table
U.restore_default = function(option)
    if U.defaults[option] == nil then
        print("No recorded default for " .. option)
    else
        pcall(function()
            vim.go[option] = U.defaults[option]
        end, "Unknown option " .. option)
    end
end

U.record_file_name = function()
    if vim.bo.filetype ~= "" then
        U.recents["filetype"][vim.bo.filetype] = vim.fn.expand("%:p")
    end
end

-- Utility
-- Decorator that modifies a function so it restores the previous value of a register
-- after using it
U.with_register = function(_func, register)
    return function(...)
        local old_register = U.default_arg(register, vim.v.register)
        local old_register_value = vim.fn.getreg(old_register)
        local old_register_type = vim.fn.getregtype(old_register)
        local out = _func(...)
        vim.fn.setreg(old_register, old_register_value, old_register_type)
        return out
    end
end

--Utility
-- Decorator to execute function, then return cursor to original position
U.with_position = function(func)
    return function(...)
        local old_line = vim.fn.line(".")
        local old_col = vim.fn.col(".")
        local result = func(...)
        vim.fn.setpos(old_line, old_col)
        return result
    end
end

-- Returns function that retrieves table element keyed to filetype, then calls another function with that value
U.switch_filetype = function(mapping, default)
    return function(func)
        return function(...)
            local value = mapping[vim.bo.filetype]
            if value == nil then
                default = U.default_arg(default, nil)
                value = U.default_arg(value, default)
            end
            return func(value, ...)
        end
    end
end

-- TODO make named tables, for matched indexing
-- U.invert_logical = U.switch_filetype({
--     r = { "TRUE", "FALSE" },
--     rmd = { "TRUE", "FALSE" },
--     python = { "True", "False" },
--     lua = { "true", "false" },
-- })
--
-- U.swap_word = function(mapping)
--     vim.cmd("normal yiw")
--     local word = vim.fn.getreg("+")
--     print(word)
--     local swap = nil
--     if word == mapping[1] then
--         swap = mapping[2]
--     elseif word == mapping[2] then
--         swap = mapping[1]
--     end
--     if swap ~= nil then
--         vim.cmd("normal ciw" .. swap)
--     end
-- end

--U.swap_logical = U.invert_logical(U.swap_word)

-- Make coroutine?
U.repeat_action = function(func, args, interval)
    interval = interval or 10
    local cmd = "sleep " .. interval
    while true do
        func(unpack(args))
        vim.cmd(cmd)
    end
end

--Util
--Wrap a function so it may be called safely
U.safe_call = function(func, ...)
    pre_args = { ... }
    return function(...)
        return pcall(func, ...)
    end
end

-- Term
-- Configure standard options when entering terminal, and record metadata in global variables
U.set_term_opts = function()
    vim.cmd.startinsert()
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.spell = false
    vim.wo.signcolumn = "no"

    -- Globals respectively indicating  buffer, channel, and window ID of last terminal entered
    term_state = (term_state == nil and {}) or term_state
    term_state["last_terminal_buf_id"] = vim.fn.bufnr()
    term_state["last_terminal_chan_id"] = vim.b.terminal_job_id
    term_state["last_terminal_win_id"] = vim.fn.win_getid()
end

--Term
-- Yank text at end of terminal buffer
-- There must be a better way to do this
U.term_yank = function(term_id, prompt_pattern, offset)
    if term_state == nil or term_state == {} then
        return
    end
    prompt_pattern = U.default_arg(prompt_pattern, [[>\s[^ ]\+]])
    offset = U.default_arg(offset, -1)
    term_id = U.default_arg(term_id, term_state["last_terminal_win_id"])
    -- Find most recent line with terminal prompt
    local prompt_line = tonumber(
        string.gsub(
            vim.fn.win_execute(
                term_id,
                "echo search('" .. prompt_pattern .. "', 'bnW')"
            ),
            "\n",
            ""
        ),
        10
    )

    if prompt_line == 0 then
        return ""
    end
    local text = vim.api.nvim_buf_get_lines(
        term_state["last_terminal_buf_id"],
        prompt_line - 1,
        offset,
        true
    )
    return string.gsub(U.join(text, ""), "^.+>", "")
end
--
-- Given a table of global variables, invert the value of each if it exists (1 -> 0, true -> false)
--Data
U.toggle_var = function(...)
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

--Editing
U.alter_closest = function(flags, replace)
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

--Util
U.count_bufs_by_type = function(loaded_only)
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

--Buffer
U.get_matching_buffers = function(pattern)
    pattern = U.default_arg(pattern, ".*")
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

-- Buffer
-- Change to buffer matching a regular expression
U.switch_to_buffer = function(pattern)
    -- Match all by default
    valid_buffers, matches = U.get_matching_buffers(pattern)

    if valid_buffers == {} then
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

U.filter_loaded = function(tbl, i)
    if not vim.api.nvim_buf_is_loaded(tbl[i]) then
        table.remove(tbl, i)
    end
    return tbl
end

-- Return names of known buffers filtered by a one-argument function
-- (defaults to checking if they are loaded)
U.get_buf_names = function(filter, ...)
    filter = U.default_arg(filter, function(bufnr)
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

U.close_bufs_by_type = function(buftype)
    for _, bufname in pairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_get_option(bufname, "buftype") == buftype then
            vim.cmd("bdelete " .. bufname)
        end
    end
end

-- Suggested by official guide to automatically escape terminal codes
U.t = function(str)
    --Last arg is "special"
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- Takes a key sequence, executes it in first window in specified
-- direction, then returns to original window
U.get_opposite_window = function(dir)
    local dir_pairs = { h = "l", l = "h", j = "k", k = "j" }
    return dir_pairs[dir]
end

-- Execute a command in another window, then switch back
U.win_exec = function(keys, direction)
    if direction == nil then
        return
    end
    if keys == nil then
        keys = vim.fn.input("Window command: ")
    end

    local count = vim.v.count1
    local command =
    string.gsub(U.t(keys), "^normal%s", "normal " .. tostring(count), 1)
    -- If window targeted by number instead of relative direction, just execute command
    if type(direction) == "number" then
        vim.fn.win_execute(direction, command)
        return
    end

    -- Switch to window, execute command, switch back
    local this_window = vim.api.nvim_win_get_number(0)
    vim.cmd("wincmd " .. direction)
    print(command)
    vim.cmd(command)
    vim.cmd(this_window .. "wincmd w")
end

-- Put register contents into most recent window
U.win_put = function(register, win_id)
    register = U.default_arg(register, "+")
    win_id = U.default_arg(win_id, U.recents["window"])
    if win_id == nil then
        return
    end
    local command = "put " .. register
    vim.fn.win_execute(win_id, command)
end

-- Start new terminal buffer
U.term_setup = function()
    vim.cmd.vsplit()
    vim.cmd([[normal l]])
    vim.cmd.terminal()
    vim.cmd([[normal k]])
    U.win_exec("startinsert", "l")
end

-- Building on https://vi.stackexchange.com/questions/21449/send-keys-to-a-terminal-buffer/21466
U.term_exec = function(keys, scroll_down, use_count)
    if term_state == nil or term_state["last_terminal_chan_id"] == nil then
        return false
    end

    --Use count only if specified
    use_count = U.default_arg(use_count, true)
    scroll_down = U.default_arg(scroll_down, true)
    local count = (use_count and vim.v.count1) or 1
    local command = (string.find(keys, [[\]]) and U.t(keys)) or keys

    for _ = 1, count, 1 do
        vim.fn.chansend(term_state["last_terminal_chan_id"], command)
    end
    vim.fn.chansend(term_state["last_terminal_chan_id"], U.t("<CR>"))
    -- Scroll down if argument specified, useful for long input
    if scroll_down and term_state["last_terminal_win_id"] ~= nil then
        --vim.fn.win_execute(vim.g.last_terminal_win_id, " normal G")
        vim.api.nvim_win_set_cursor(term_state["last_terminal_win_id"], {
            vim.api.nvim_buf_line_count(term_state["last_terminal_buf_id"]),
            1,
        })
    end
    return command
end

--Substitute default value for omitted argument
U.default_arg = function(arg, default)
    return (arg == nil and default) or arg
end

-- double controls whether to concatenate if string already has prefix/suffix
U.surround_string = function(string, prefix, postfix, double)
    prefix = U.default_arg(prefix, "'")
    postfix = U.default_arg(postfix, "'")
    double = U.default_arg(double, false)
    prefix = (double or string.sub(string, 1, 1) ~= prefix) and prefix or ""
    postfix = (double or string.sub(string, -1, -1) ~= postfix) and postfix
        or ""
    return string ~= "" and (prefix .. string .. postfix) or string
end

-- Modify register with function
U.modify_register = function(func, register, ...)
    register = U.default_arg(register, "+")
    local current = vim.fn.getreg(register)
    local new = func(current, ...)
    vim.fn.setreg(register, new)
    --return new
end

U.jump = function(pattern, offset, flags)
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
U.toggle_opt = function(opt, val1, val2)
    if vim.o[opt] == val1 then
        vim.o[opt] = val2
    elseif vim.o[opt] == val1 then
        vim.o[opt] = val2
    else
        print(
            "Don't know how to handle option "
            .. opt
            .. " with value"
            .. tostring(vim.o[opt])
        )
    end
end
-- Count each value of a given option across all buffers
U.summarize_option = function(opt)
    if not pcall(function()
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
            summary[value] = 1
        else
            summary[value] = summary[value] + 1
        end
    end
    return summary
end

U.repeat_cmd = function(...)
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

U.get_input = function(str)
    return vim.fn.input("Enter expansion for " .. str)
end

-- Append abbreviation to abbreviations file
U.add_abbrev = function(abbrev, expansion)
    if expansion == nil then
        expansion = vim.fn.input(
            "Enter expansion for abbreviation "
            .. U.surround_string(abbrev, '"', '"')
            .. ": "
        )
    end
    -- vim command to sub in new abbreviation at end of abbreviation chunk
    cmd = [[$-1 s/$/\rinoreabbrev ]] .. abbrev .. " " .. expansion .. "/"
    cmd = ("nvim -c '" .. cmd .. "' -c 'wq' $HOME/dotfiles/nvim/lua/abbrev.lua")
    vim.fn.system(cmd)
    print(
        "\nAdded abbreviation "
        .. U.surround_string(expansion, '"', '"')
        .. " for "
        .. U.surround_string(abbrev, '"', '"')
    )
end

U.no_jump = function(cmd)
    cmd = cmd or ("normal " .. vim.fn.input("Normal command: "))
    print("\n")
    local old_pos = vim.fn.getpos(".")
    U.repeat_cmd(cmd)
    vim.fn.setpos(".", old_pos)
end
U.no_jump_safe = U.safe_call(U.no_jump)

U.refresh = function(file)
    -- https://codereview.stackexchange.com/questions/90177/get-file-name-with-extension-and-get-only-extension
    local extension
    -- If no file provided, assume current buffer
    if file == nil then
        file = vim.fn.expand("%:p")
        extension = vim.bo.filetype
    else
        file = vim.fn.system("realpath " .. file)
        extension = string.lower(string.match(file, "^.+(%..+)$"))
    end

    --file = U.surround_string(file)
    local mapping = {
        lua = "source " .. file,
        vim = "source " .. file,
        py = "IPythonCellRun",
        R = 'RSend source("' .. file .. '")',
        r = 'RSend source("' .. file .. '")',
        bash = "!. " .. file,
        sh = "!. " .. file,
    }
    cmd = mapping[extension]

    if cmd == nil then
        print("Don't know how to handle extension " .. extension)
        return
    end
    print(cmd)
    vim.cmd(cmd)
end

-- Mostly copied from https://vi.stackexchange.com/questions/11310/what-is-a-scratch-window
-- Makes a scratch buffer
U.make_scratch = function(command_fn)
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
U.capture_output = function(cmd)
    local output = vim.fn.execute(cmd)
    local register = "z"
    vim.fn.setreg(register, output)
    local func = function()
        vim.cmd("put " .. register)
    end
    U.make_scratch(func)
end
U.capture_output = U.with_register(U.capture_output, "z")

-- Open scratch buffer containing terminal history so you can browse and rerun commands
-- TODO fix syntax highlighting in scratch
U.term_edit = function(history_command, syntax)
    history_command = history_command or "history -w /tmp/history.txt"
    syntax = syntax or "bash"
    U.term_exec(history_command)
    U.make_scratch(
        U.compose_commands(
            "read /tmp/history.txt",
            "setlocal number syntax=" .. syntax,
            "normal G",
            "autocmd "
        )
    )
end

U.get_pair = function(char)
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

U.get_char = function(offset, mode)
    --Given an editor mode and offset, returns the character {offset}
    --columns from the current character in the current line in that mode
    local which = offset or 0
    mode = mode or vim.fn.mode()
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
U.expand_pair = function(char, mode)
    --Credit  https://stackoverflow.com/questions/23323747/vim-vimscript-get-exact-character-under-the-cursor
    local next_char = U.get_char(1, mode)
    out = string.find(next_char, "%w") and char
        or char .. U.get_pair(char) .. U.t("<left>")
    return out
end

--Move cursor one index right if next character matches char position, otherwise put character
U.match_pair = function(char)
    local next_char = U.get_char(1)
    return next_char == char and U.t("<right>") or char
end

U.compose_commands = function(...)
    local args = { ... }
    return function()
        for _, cmd in ipairs(args) do
            vim.cmd(cmd)
        end
    end
end

U.surround = function()
    vim.fn.setline(
        ".",
        vim.fn.input("function: ") .. "(" .. vim.fn.getline(".") .. ")"
    )
end

--Buffer
U.yank_visual = function(buffer)
    buffer = U.default_arg(buffer, 0)
    -- Col value for ">" mark in linewise selection is the 32-bit integer limit
    -- TODO fix blockwise selection
    local linewise_col = 2 ^ 31 - 1
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

    --return vim.fn.getreg(register)
end
--U.yank_visual = U.with_register(U.yank_visual, "z")

-- Operator
-- Translated from https://vim.fandom.com/wiki/Search_for_visually_selected_text
U.visual_search = function(target)
    -- Abort current visual mode
    vim.cmd.normal(U.t("<Esc>"))
    target = U.default_arg(target, "/")
    local text = U.yank_visual(0)
    vim.fn.setreg("/", text, "c")
    return text
end

--Operator
-- Get start and end of operator-pending register
U.get_operator_pos = function(buffer)
    local start_pos = vim.api.nvim_buf_get_mark(buffer, "[")
    --(row, col)
    local end_pos = vim.api.nvim_buf_get_mark(buffer, "]")
    return start_pos, end_pos
end

-- Operator
-- Extract text from the latest motion;
-- intended to help define custom operators
U.capture_motion_text = function(buffer, type)
    local start_pos, end_pos = U.get_operator_pos(buffer)
    --(row, col)
    -- Mark positions are 1-indexed, text extractors 0-indexed, go figure
    if type == "char" or type == "block" then
        text = vim.api.nvim_buf_get_text(
            buffer,
            start_pos[1] - 1,
            start_pos[2],
            end_pos[1] - 1,
            end_pos[2] + 1,
            {}
        )
    elseif type == "line" then
        text = vim.api.nvim_buf_get_lines(
            buffer,
            start_pos[1] - 1,
            end_pos[1] - 1,
            {}
        )
    else
        print("Unknown selection type " .. type)
        return nil
    end

    return table.concat(text, "\n")
end

--Operator
U.term_motion_impl = function(type)
    local text = U.capture_motion_text(vim.api.nvim_get_current_buf(), type)

    -- Need special escaping for Python files
    if vim.bo.filetype == "python" or vim.bo.filetype == "quarto" then
        vim.fn["slime#send"]("%cpaste -q\n")
        vim.fn["slime#send"](collapse_text(text))
        vim.fn["slime#send"]("\n--\n")
    else
        U.term_exec(text, true, false)
    end
end

-- Creates a function that implements an operator that takes two motions,
-- then swaps text selected by the first one with the second
-- Cross-buffer capable
-- Operator
U.swap_impl_factory = function()
    local memo = {}
    -- Helper to replace text in correct position
    local replace_text = function(target_buffer, start, ends, text)
        local start_row, start_col = unpack(start)
        local end_row, end_col = unpack(ends)
        -- Maybe pcall wrapper?
        local old_put_start = vim.api.nvim_buf_get_mark(target_buffer, "[")
        local old_put_end = vim.api.nvim_buf_get_mark(target_buffer, "]")
        print(vim.inspect(text))
        -- Clear text and replace
        -- print(start_row)
        -- print(start_col)
        -- print(end_row)
        -- print(end_col)
        -- Clear old before pasting new
        vim.api.nvim_buf_set_text(
            target_buffer,
            start_row,
            start_col,
            end_row,
            end_col,
            {}
        )

        -- TODO fix multiple-line swapping; maybe insert dummy spaces before swap?
        vim.api.nvim_buf_set_text(
            target_buffer,
            start_row,
            start_col,
            start_row,
            start_col,
            text
        )

        -- -- Manually reset marks to their values before the pasting just done
        vim.api.nvim_buf_set_mark(
            target_buffer,
            "[",
            old_put_start[1],
            old_put_start[2],
            {}
        )
        vim.api.nvim_buf_set_mark(
            target_buffer,
            "]",
            old_put_end[1],
            old_put_end[2],
            {}
        )
    end

    -- Change indices of row-col tuples as required
    local correct_positions = function(start_pos, end_pos)
        start_pos[1] = start_pos[1] - 1
        end_pos[1] = end_pos[1] - 1
        --start_pos[2] = math.max(start_pos[2] - 1, 0)
        end_pos[2] = math.min(end_pos[2] + 1, vim.fn.col("$") - 1)
        return start_pos, end_pos
    end

    local swap = function(selection_type)
        local n_captured = #memo
        local current_buffer = vim.api.nvim_get_current_buf()
        if n_captured > 2 then
            print(
                "Cannot store more than 2 text selections, but have "
                .. n_captured
            )
            memo = {}
            return
        end

        local new_text = U.capture_motion_text(current_buffer, selection_type)
        -- Newlines disallowed by API function, so split into   table
        if type(new_text) == "string" then
            if string.match(new_text, "\n") then
                processed_text = U.str_split(new_text, "\n")
            else
                processed_text = { new_text }
            end
        end
        print(new_text)

        local start_pos, end_pos =
        correct_positions(U.get_operator_pos(current_buffer))

        -- No stored text to swap with, so add to cache with position data
        if n_captured < 2 then
            table.insert(memo, {
                current_buffer,
                { start_pos = start_pos, end_pos = end_pos },
                processed_text,
            })
            n_captured = n_captured + 1
        end
        --print("n_captured " .. n_captured)
        if n_captured == 2 then
            local old_buffer = memo[1][1]
            local old_positions = memo[1][2]
            local old_start = old_positions["start_pos"]
            local old_end = old_positions["end_pos"]
            local old_text = memo[1][3]
            --print(old_text)
            --(tostring(vim.inspect(memo)))
            -- print(tostring(vim.inspect(old_text)))
            -- Text to replace is that recently captured
            --
            -- Clear cache if error
            --local old_line_length = vim.fn.col("$")

            old_text = U.map(old_text, U.str_trim)
            processed_text = U.map(processed_text, U.str_trim)
            local result, err = pcall(function()
                replace_text(old_buffer, old_start, old_end, processed_text)
            end)
            -- If swapping on same line, account for offset from swapping old for new, which
            -- throws off target col indices
            local line_difference = string.len(U.demote(old_text))
                - string.len(U.demote(processed_text))
            print(line_difference)
            if not result then
                memo = {}
                print("Error inserting text")
                print(err)
                return
            end

            -- Have to refresh location because position will have changed after
            -- old replacement (if both are in same buffer)
            local new_buffer = memo[2][1]
            local new_start, new_end =
            correct_positions(U.get_operator_pos(new_buffer))
            -- Adust indices to account for replacement offset
            -- TODO test same-line case
            -- print(vim.inspect(old_start))
            -- print(vim.inspect(old_end))
            -- print(vim.inspect(new_start))
            -- print(vim.inspect(new_end))
            if U.all_equal(old_start[1], old_end[1], new_start[1], new_end[1])
            then
                new_start[2] = new_start[2] - line_difference
                new_end[2] = new_end[2] - line_difference
            end
            result, err = pcall(function()
                replace_text(new_buffer, new_start, new_end, old_text)
            end)
            if not result then
                print("Error inserting text")
                print(err)
            end
            memo = {}
        end
    end
    return swap
end
-- Operator
U.swap_impl = U.swap_impl_factory()

U.define_operator = function(func, name, err)
    return function(type)
        if type == nil or type == "" then
            vim.go.operatorfunc = "v:lua." .. name
            return "g@"
        end

        local out = pcall(func(type), err)
        U.restore_default("operatorfunc")

        return out
    end
end

U.term_motion = U.define_operator(
    U.term_motion_impl,
    "U.term_motion",
    "Error sending text to terminal"
)

U.swap =
U.define_operator(U.swap_impl, "U.swap", "Error swapping text selections")

-- Util
-- From https://stackoverflow.com/questions/4990990/check-if-a-file-exists-with-lua
-- Also returns false for directory that does exist
U.file_exists = function(path)
    if path == nil then
        return false
    end
    path = vim.fn.expand(path)
    local f = io.open(path, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

-- Utils
-- Check if path is valid directory
-- From https://stackoverflow.com/questions/2833675/using-lua-check-if-file-is-a-directory
U.dir_exists = function(path)
    if path == nil then
        return false
    end
    path = vim.fn.expand(path)
    local f = io.open(path, "r")
    if f == nil then
        return false
    end

    local _, _, code = f:read(1)
    io.close(f)

    return code == 21 -- Is-directory error
end

--Utils
U.make_session = function()
    vim.b.sessiondir = os.getenv("HOME") .. "/.vim/sessions" .. vim.fn.getcwd()
    if vim.fn.filewritable(vim.b.sessiondir) ~= 2 then
        vim.cmd("silent !mkdir -p " .. vim.b.sessiondir)
        vim.cmd("redraw!")
    end
    vim.b.filename = vim.b.sessiondir .. "/session.vim"
    vim.cmd("mksession! " .. vim.b.filename)
end

-- From https://stackoverflow.com/questions/1642611/how-to-save-and-restore-multiple-different-sessions-in-vim, with my modifications
U.save_session = function()
    local session_dir = os.getenv("VIM_SESSION_DIR")
    if session_dir == nil then
        print("Session directory not specified")
        return
    end
    if not U.dir_exists(session_dir) then
        print("Session directory " .. session_dir(" does not exist"))
        return
    end
    local this_session = vim.g.current_session
        or (
        vim.v.this_session ~= nil
            and vim.v.this_session ~= ""
            and vim.fn.systemlist(--Check if session file exists with current session name
                'basename -s ".vim" ' .. U.surround_string(vim.v.this_session)
            )[1]
        )
        or nil
    -- If no current session name found, prompt user for one, warning if already in use
    local name_provided = false
    if this_session == nil then
        this_session = vim.fn.input("Enter session name (enter to skip): ")
        --if not ok then
        --print("\n Error saving session")
        --return
        if this_session == "" then
            print("\nInvalid session name")
            return
        end
        name_provided = true
    end
    local current_session = this_session

    local path = session_dir .. "/" .. current_session .. ".vim"
    if name_provided and U.file_exists(path) then
        local choice = vim.fn.input(
            "Session "
            .. U.surround_string(current_session)
            .. " already exists. Overwrite (y to overwrite, any other key to abort)? "
        )
        if choice ~= "y" then
            return
        end
    end
    vim.g.current_session = current_session
    vim.cmd("mksession! " .. path)
end

U.load_session = function()
    local session_dir = os.getenv("VIM_SESSION_DIR")
    if session_dir == nil then
        print("Session directory not specified")
        return
    end
    if not U.dir_exists(session_dir) then
        print("Session directory " .. session_dir(" does not exist"))
        return
    end
    -- Shell-quote for safety
    local latest_session =
    vim.fn.systemlist("lastn " .. session_dir .. " 1 echo")[1]
    local session_name = vim.fn.systemlist(
        "basename -s '.vim' " .. U.surround_string(latest_session, "'")
    )[1]
    local safe_source = function(file)
        vim.cmd("source " .. file)
    end

    if vim.fn.filereadable(latest_session) ~= 1 then
        print(
            "Session file "
            .. U.surround_string(latest_session)
            .. " does not exist or cannot be read"
        )
        return
    end
    vim.cmd("source " .. latest_session)
    vim.g.current_session = session_name
    print("Loading session " .. U.surround_string(session_name))
end

-- Utils
-- Knit an Rmarkdown file
U.knit = function(file, quiet, view_result)
    -- We have to get the full path of the output in case the YAML specifies a different output directory

    file = U.default_arg(file, U.recents["filetype"]["rmd"])
    if not U.file_exists(file) then
        print(U.surround_string(file) .. " does not exist")
        return
    end
    view_result = U.default_arg(view_result, true)
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
        U.surround_string(os.getenv("HOME") .. "/.*%.pdf", "\n(", ")")
    )

    if U.file_exists(outfile) then
        print("Rendered " .. U.surround_string(outfile))
        if view_result then
            vim.cmd("!zathura " .. vim.fn.shellescape(outfile) .. " &")
        end
    end
end

-- Buffer
U.count_pairs = function(str, char, close)
    local open = 0
    for i = 1, string.len(str) do
        cur = string.sub(str, i, i)
        if cur == char then
            open = open + 1
        elseif cur == close then
            open = open - 1
        end
        --TODO find correct stopping condition
        if open < 1
            and not string.find(string.sub(str, i + 1, -1), "%" .. close)
        then
            return i
        end
    end
    return string.len(str)
end

-- Util
U.match_paren = function()
    local char = U.get_char(0)
    local line = vim.fn.getline(".")
    local remainder = string.sub(line, vim.fn.col("."), -1)
    local close = U.get_pair(char)
    --pattern = char .. '.[^' .. char ..']+' .. close
    if string.len(remainder) == 1 then
        vim.fn.setline(".", line .. close)
        return
    end
    local i = U.count_pairs(string.sub(remainder, 2, -1), char, close) + 1

    --Insert closing character at appropriate position
    vim.fn.setline(
        ".",
        string.sub(line, 1, vim.fn.col(".") - 1)
        .. string.sub(remainder, 1, i)
        .. close
        .. string.sub(remainder, i + 1, -1)
    )
end

-- Util
-- Display lines of command output (e.g., autocmd) matching pattern
U.grep_output = function(cmd, print_output, ...)
    print_output = U.default_arg(print_output, true)
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
        U.print_table(out)
    else
        return out
    end
end

-- Util
-- TODO recursively print tables
U.inspect = function(x)
    print(vim.inspect(x))
end

U.print_table = function(table)
    for _, val in ipairs(table) do
        if type(val) ~= "table" then
            print(val)
        else
            U.print_table(val)
        end
    end
end

-- Util
-- Standard string split. Credit https://stackoverflow.com/questions/1426954/split-string-in-lua
U.str_split = function(a_string, sep)
    sep = sep or "%s"
    local result = {}
    local pattern = "([^" .. sep .. "]+)"
    for str in string.gmatch(a_string, pattern) do
        table.insert(result, str)
    end
    return result
end

-- Evaluate inline R code chunk
U.inline_send = function()
    if not os.getenv("NVIMR_ID") then
        print("Nvim-R is not running")
        return
    end
    local old_pos = vim.fn.getpos(".")
    vim.cmd([[normal F`2w"zyt`]]) -- "just to fix syntax highlighting
    vim.cmd("RSend " .. vim.fn.getreg("z"))
    vim.fn.setpos(".", old_pos)
end

--Buffer
U.open_in_hidden = function(pattern)
    local current_file = vim.fn.expand("%")
    -- Default to matching current file extension
    pattern = U.default_arg(
        pattern,
        "*" .. string.sub(current_file, string.find(current_file, "%.[^.]+$"))
    )
    local files = vim.fn.systemlist("ls " .. pattern)
    -- Shell-quote and add all files matched, except current
    local cmd = "argadd"
    local current_buffer = vim.api.nvim_buf_get_number(0)
    for i, _ in ipairs(files) do
        cmd = cmd .. (files[i] ~= current_file)
            and U.surround_string(files[i], " ", "")
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
U.clean_buffers = function(remove_nonempty)
    remove_nonempty = U.default_arg(remove_nonempty, false)
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

-- Util
-- Based on https://stackoverflow.com/questions/23120266/lua-advancing-to-the-next-letter-of-the-alphabet
-- Finds next free register and saves string in it
U.next_free_register = function(content, start_register)
    local alphabet = "abcdefghijklmnopqrstuvwxyz"
    content = U.default_arg(content, vim.fn.getreg('"'))
    start_register = U.default_arg(start_register, "a")
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
                U.surround_string(content, "'", "'") .. " written to @" .. cur
            )
            return content
        end
    end
    print("All registers full")
end

-- Buffer
-- Open window to edit ftplugin file for current filetype
U.edit_filetype = function(filetype, extension)
    filetype = U.default_arg(filetype, vim.bo.filetype)
    extension = U.default_arg(extension, "lua")
    if filetype == "" then
        print("Invalid filetype")
        return
    end

    local ftplugin = vim.api.nvim_get_runtime_file("ftplugin", false)
    if #ftplugin == 0 then
        print(U.surround_string(ftplugin) .. " does not exist")
        return
    end
    local file = ftplugin[1] .. "/" .. filetype .. "." .. extension
    -- Works whether or not file exists
    vim.cmd("split " .. file)
end

-- Util
-- Check conditions for saving session
U.do_save_session = function(min_buffers)
    min_buffers = U.default_arg(min_buffers, 2)
    if U.count_bufs_by_type(true)["normal"] >= min_buffers
        and U.summarize_option("ft")["anki_vim"] == nil
    then
        U.save_session()
    end
end

-- Util
-- Collapse table into string
U.join = function(tab, join)
    join = U.default_arg(join, "")
    local out = table.remove(tab)
    for i = #tab, 1, -1 do
        out = tab[i] .. join .. out
    end
    return out
end

--Reddit user Rafat913
U.open_uri_under_cursor = function()
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
    if open_uri(
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

--Util
U.clamp = function(x, lower, upper)
    return math.min(math.max(x, lower), upper)
end

-- Buffer
-- Given a command and number, applies the command to the range of lines between the current line and
-- the number inclusive, clamping to file length
U.range_command = function(command, range, invert)
    range = U.default_arg(range, vim.v.count1)
    if range == "$" then
        range = vim.fn.line("$")
    end
    invert = U.default_arg(invert, false)
    local bound = (invert and -1 * range) or range
    local current_line = vim.fn.line(".")
    bound = U.clamp(current_line + bound, 1, vim.fn.line("$")) - current_line
    -- Needed to avoid range-swapping prompt
    local substring
    if bound < 0 then
        substring = current_line + bound .. "," .. current_line
    else
        substring = ".,.+" .. bound
    end
    vim.cmd(substring .. " normal " .. command)
end

-- Provided by https://github.com/milanglacier/nvim/blob/9bde2a70c95be121eb814d00a792f8192fc6ff85/lua/conf/builtin_extend.lua#L224
function U.create_tags_for_yanked_columns(df)
    local ft = vim.bo.filetype
    if not (ft == "r" or ft == "rmd" or ft == "python") then
        return
    end

    local ft_mapping = { r = "r", rmd = "r", python = "python" }

    local bufid = vim.api.nvim_get_current_buf()
    local filename = vim.fn.expand("%:t")
    local filename_without_extension = filename:match("(.+)%..+")
    local newfile = filename_without_extension .. "_tags"

    vim.cmd(string.format("e %s", newfile)) -- open a file whose name is xxx_tags.extension
    local newtag_bufid = vim.api.nvim_get_current_buf()

    vim.cmd([[normal! Go]]) -- go to the end of the buffer and create a new line
    --vim.cmd([[normal! "0p]]) -- paste the content just yanked into this buffer

    -- flag ge means: replace every occurrences in every line, and
    -- when there are no matched patterns in the document, do not issue an error
    if ft == "python" then
        vim.cmd([[%s/,//ge]]) -- remove every occurrence of ,
    else
        --vim.cmd([[g/^r?\$>.\+$/d]]) -- remove line starts with r$> which usually is the REPL prompt
        --vim.cmd([[%s/\[\d\+\]//ge]]) -- remove every occurrence of [xxx], where xxx is a number
        --append column names to file
        vim.cmd(
            "RSend "
            .. string.format(
                [[cat(paste(colnames(%s), "'%s'", sep=" <- "), sep = "\n", file= "%s", append = TRUE)]],
                df,
                df,
                newfile
            )
        )
    end

    vim.cmd([[%s/\s\+/\r/ge]]) -- break multiple spaces into a new line
    vim.cmd([[g/^$/d]]) -- remove any blank lines

    if ft == "python" then
        vim.cmd([[%s/'//ge]]) -- remove '
        vim.cmd([[g/^\w\+$/normal! A="]] .. df .. [["]]) -- show which dataframe this column belongs to
        -- use " instead of ', for incremental tagging, since ' will be removed.
    else
        --vim.cmd([[%s/"//ge]])
        --vim.cmd([[g/^\w\+$/normal! A=']] .. df .. [[']])
        -- r use " to quote strings, in contrary to python
    end
    print()

    --vim.cmd([[sort u]]) -- remove duplicated entry
    --vim.cmd([[%!sort | uniq -u]])
    vim.cmd([[w]]) -- save current buffer

    local newfile_shell_escaped = vim.fn.shellescape(newfile)
    -- replace . by \. such that it is recognizable by vim regex
    -- replace / by \/
    local newfile_vim_regexed = newfile_shell_escaped:gsub("%.", [[\.]])
    newfile_vim_regexed = newfile_vim_regexed:gsub("/", [[\/]])
    newfile_vim_regexed = newfile_vim_regexed:sub(2, -2) -- remove the first and last chars, i.e. ' and '
    print(newfile_vim_regexed)

    vim.cmd([[e tags]]) -- open the file where ctags stores the tags
    local tag_bufid = vim.api.nvim_get_current_buf()

    vim.cmd([[g/^\w\+\s\+]] .. newfile_vim_regexed .. [[\s.\+/d]]) -- remove existed entries for the current newtag file in tags file
    vim.cmd([[w]])

    -- This actually stores tags
    vim.cmd(
        [[!ctags -a --language-force=]]
        .. ft_mapping[ft]
        .. " "
        .. newfile_shell_escaped
    ) -- let ctags tag current newtag file

    vim.api.nvim_win_set_buf(0, bufid)
    vim.cmd([[bd!]] .. newtag_bufid) -- delete the buffer created for tagging
    vim.cmd([[bd!]] .. tag_bufid) -- delete the ctags tag buffer
    vim.cmd([[noh]]) -- remove matched pattern highlight
end

local command = vim.api.nvim_create_user_command

command("TagYankedColumns", function(options)
    local df = options.args
    U.create_tags_for_yanked_columns(df)
end, {
    nargs = "?",
})

U.grow_list = function()

    --TODO grow list of item in document by inserting next line with correct preceding mark (e.g., * if * opens current line,
    --3 if 2 does, c if d does, etc.)
    --To be triggered by insert mapping
end

U.extract_to_default_arg = function(name)
    name = name or vim.fn.expand("<cword>")
    local old_pos = vim.fn.getpos(".")
    -- Get value bound to name
    vim.cmd('normal 2w"zyW')
    local value = vim.fn.getreg("z")
    -- Remove trailing paren
    if not string.match(value, "%(") and string.match(value, "%)$") then
        value = string.gsub(value, "%)$", "")
    end
    local fn_line = vim.fn.search([[<-\s*function]], "b")
    vim.fn.cursor(fn_line, 1)
    if fn_line == 0 then
        return
    end
    local target_line = vim.fn.search([[)\s*{\s*$]])
    if target_line == 0 then
        return
    end
    vim.fn.setline(
        target_line,
        vim.fn.substitute(
            vim.fn.getline(target_line),
            [[)\s*{]],
            string.format(", %s = %s) {", name, value),
            ""
        )
    )
    vim.fn.setpos(".", old_pos)
    U.clean_definition(name)
end

-- Buffer
-- Alters a parameter in a function call, or a variable assignment, to reflect that
-- variable having been turned into a function argument (and therefore without a fixed value)
U.clean_definition = function(name)
    name = name or vim.fn.expand("<cword>")
    line = vim.fn.getline(".")
    -- in function call, so replace name = 5 with name = name
    local trailing_comma = string.match(line, ",%s*$")
    if trailing_comma
        or string.match(line, "^[a-zA-Z_.]+%(")
        or (
        vim.fn.line(".") > 1
            and string.match(vim.fn.getline(vim.fn.line(".") - 1), ",%s*$")
        )
    then
        vim.cmd("normal 2wcW" .. name .. (trailing_comma and "," or ""))
        -- assignment statement, so delete entire assingment
    else
        vim.cmd("normal dd")
    end
end
U.clean_definition = U.with_position(U.clean_definition)

-- Get rid of empty undo files
-- Util
U.delete_undo = function()
    local pattern = "Not%san%sundo%sfile:%s"
    local lines = U.grep_output("messages", false, pattern)
    if lines == {} then
        return
    end
    for _, line in ipairs(lines) do
        vim.fn.system("rm " .. string.gsub(line, pattern, ""))
    end
end

-- Util
-- Insert `sub` every `stride` characters in `str`
-- May want to add break_line that inserts newline in first space of each chunk
U.replace_indices = function(str, sub, stride)
    local length = string.len(str)
    local last = stride * math.ceil(length / stride)
    if last > length then
        return str
    end
    local out = ""
    for i = stride, last, stride do
        out = out .. string.sub(str, i - stride + 1, i) .. sub
    end
    return out
end

-- Util
-- Identity function
U.identity = function(x)
    return x
end

--Locate function, class, etc. in buffer by name
--@param type: kind of identifier to match. Options are keyword (e.g, "def foo")
--or "name" (e.g., "foo = function")
--@param keyword Word to match
U.locate = function(args)
    local keyword = args["keyword"]
    local type = args["type"]
    local pattern
    if type == "keyword" then
        pattern = "%s*" .. keyword .. "%s+"
        -- = function
    elseif type == "name" then
        pattern = "%s*=%s*" .. keyword
    end

    return function(name)
        -- Order depends on type of code being matched
        -- Create fresh so it isn't preserved in enclosing environment
        this_pattern = (type == "keyword") and pattern .. name
            or name .. pattern
        local lines = vim.api.nvim_buf_get_lines(0, 0, vim.fn.line("$"), {})
        for i = 1, #lines, 1 do
            -- Set cursor to line of first match from top
            if string.match(lines[i], this_pattern) then
                vim.fn.cursor(i, 0)
                return i
            end
        end
        print(name .. " not found")
    end
end
--test = U.locate({keyword = "function", type = "name"})

-- TODO enhance to only show options for which capabilities are defined, and disable
-- if LSP off
-- LSP
U.choose_picker = function()
    -- Abort if no servers active
    if vim.lsp.get_active_clients() == {} then
        print("No active language server clients found")
        return
    end
    vim.ui.select(
        {
            "lsp_references",
            "lsp_incoming_calls", --callHierarchyProvider
            "lsp_outgoing_calls", --callHierarchyProvider
            "lsp_document_symbols",
            "lsp_workspace_symbols",
            "lsp_dynamic_workspace_symbols",
            "diagnostics",
            "lsp_implementations", --implementationProvider
            "lsp_definitions",
            "lsp_type_definitions",
        },
        {
            prompt = "Select LSP picker:",
            format_item = function(item)
                --Remove lsp namespace and underscores
                item = string.gsub(string.gsub(item, "^lsp_", ""), "_", " ")
                --Capitalize
                return string.upper(string.sub(item, 1, 1))
                    .. string.sub(item, 2)
            end,
        },
        -- Run selected picker, or abort if none chosen
        function(choice, _)
            if choice == nil then
                return
            end
            vim.cmd("Telescope " .. choice)
        end
    )
end
--Util
U.table_menu = function(map, prompt, action)
    local choices = {}
    for key, _ in pairs(map) do
        table.insert(choices, key)
    end

    table.sort(choices)
    action = U.default_arg(action, function(choice, _)
        local chosen = map[choice]
        if chosen == nil then
            return
        end
        map[choice]()
    end)

    return function()
        vim.ui.select(choices, prompt, action)
    end
end

-- Set environment variable to value
U.setenv = function(variable, value, quote)
    if quote then
        value = U.surround_string(value, "'")
    end
    vim.fn.system("export " .. variable .. "=" .. value)
end

--Basic set data type implementation, suggested by docs
U.set = function(keys)
    local out = {}
    for _, k in ipairs(keys) do
        out[k] = true
    end
    return out
end

-- Roxygen generation
-- parse_query({lang}, {query}) to create query from string
-- Query:iter_captures({self}, {node}, {source}, {start}, {stop})
-- start, stop as line bounds of function signature

U.promote = function(x)
    return (type(x) == "table" and x) or { x }
end

U.demote = function(x)
    return (type(x) == "table" and (#x > 0 and x[1]) or x) or x
end

-- Util
-- Confirm all values are equal
U.all_equal = function(...)
    local args = { ... }
    while #args > 1 do
        if args[1] ~= args[2] then
            return false
        end
        table.remove(args, 1)
    end
    return true
end

U.str_trim = function(string)
    return string.gsub(string.gsub(string, "^%s+", ""), "%s+$", "")
end

-- Util
-- The higher-order function
U.map = function(x, f)
    for i, val in ipairs(x) do
        x[i] = f(val)
    end
    return x
end

--Term
U.term_toggle = function()
    if term_state ~= nil then
        hidden =
        vim.fn.getbufinfo(term_state["last_terminal_buf_id"])[1]["hidden"]
        if hidden == 1 then --open if not displayed
            vim.cmd.vsplit()
            vim.cmd.buffer(term_state["last_terminal_buf_id"])
            vim.cmd.normal(U.t("<C-w>L"))
        else -- close if displayed
            vim.api.nvim_win_close(term_state["last_terminal_win_id"], false)
        end
    else
        U.term_setup()
    end
end

-- Operator
U.record_motion = function()
    local motion = vim.fn.input("")
    -- local _, err = pcall(function()
    --     vim.cmd.normal(" " .. motion)
    -- end)
    -- if err then
    --     return
    -- end
    vim.fn.setreg("z", motion)
end

U.get_term_history = function(cmd_gen)
    local temp_file = os.tmpname()
    if U.file_exists(temp_file) then
        os.remove(temp_file)
    end
    local cmd = cmd_gen(temp_file)

    U.term_exec(cmd, false, false)
    os.execute("sleep 1")

    result = {}
    for line in io.lines(temp_file) do
        print(line)
        table.insert(result, line)
    end
    -- Ignore command sent to get history
    table.remove(result, #result)
    os.remove(temp_file)
    return result
end

U.display_term_history = function(lines, syntax)
    -- Clear old buffer if it exists
    if term_state["last_terminal_history"] ~= nil
        and vim.fn.bufwinnr(term_state["last_terminal_history"]) ~= -1
    then
        vim.api.nvim_buf_delete(
            term_state["last_terminal_history"],
            { force = true, unload = false }
        )
    end
    local current_bufs = vim.api.nvim_list_bufs()
    local lookup = {}
    for _, buf in ipairs(current_bufs) do
        lookup[buf] = true
    end
    -- Send line and close history window
    local send_line = function()
        local line = get_single_line(0, vim.fn.line("."))[1]
        U.term_exec(line, false, false)
        vim.cmd.q()
    end

    vim.api.nvim_win_call(term_state["last_terminal_win_id"], function()
        U.make_scratch(function()
            vim.bo.syntax = syntax
            vim.wo.number = true
            vim.wo.relativenumber = true
            vim.keymap.set(
                { "n", "v" },
                "<CR>",
                send_line,
                { buffer = true, silent = true, noremap = true }
            )
            vim.api.nvim_create_autocmd("BufUnload", {
                callback = function()
                    term_state["last_terminal_history"] = nil
                end,
            })
        end)
    end)

    local new_bufs = vim.api.nvim_list_bufs()
    for _, buf in ipairs(new_bufs) do
        if not lookup[buf] then
            term_state["last_terminal_history"] = buf
            break
        end
    end
    -- Reset ID on close
    vim.api.nvim_buf_set_lines(
        term_state["last_terminal_history"],
        0,
        0,
        false,
        lines
    )
end

U.history = function(syntax)
    local functions = {
        bash = function(f)
            return [[history  | sed -E 's/\s*[0-9]*\s*//' > ]]
                .. U.surround_string(f)
        end,
        python = function(f)
            return "%history -f " .. f
        end,
        R = function(f)
            return "utils::savehistory(file = '" .. f .. "')"
        end,
    }
    local command = functions[syntax]
    if command == nil then
        print("Unsupported syntax " .. syntax)
        return
    end
    local lines = U.get_term_history(command)
    U.display_term_history(lines, syntax)
end

return U
