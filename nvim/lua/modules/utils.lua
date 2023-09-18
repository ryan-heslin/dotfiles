local M = {}
-- Utility
-- Decorator that modifies a function so it restores the previous value of a register
-- after using it
M.with_register = function(_func, register)
    return function(...)
        local old_register = M.default_arg(register, vim.v.register)
        local old_register_value = vim.fn.getreg(old_register)
        local old_register_type = vim.fn.getregtype(old_register)
        local out = _func(...)
        vim.fn.setreg(old_register, old_register_value, old_register_type)
        return out
    end
end

--Utility
-- Decorator to execute function, then return cursor to original position
M.with_position = function(func)
    return function(...)
        local old_line = vim.fn.line(".")
        local old_col = vim.fn.col(".")
        local result = func(...)
        vim.fn.setpos(old_line, old_col)
        return result
    end
end

-- Returns function that retrieves table element keyed to filetype, then calls another function with that value
M.switch_filetype = function(mapping, default)
    return function(func)
        return function(...)
            local value = mapping[vim.bo.filetype]
            if value == nil then
                default = M.default_arg(default, nil)
                value = M.default_arg(value, default)
            end
            return func(value, ...)
        end
    end
end

--Util
--Wrap a function so it may be called safely
M.safe_call = function(func, ...)
    pre_args = { ... }
    return function(...)
        return pcall(func, ...)
    end
end

-- Suggested by official guide to automatically escape terminal codes
M.t = function(str)
    --Last arg is "special"
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

M.get_opposite_window = function(dir)
    local dir_pairs = { h = "l", l = "h", j = "k", k = "j" }
    return dir_pairs[dir]
end

M.win_exec = function(keys, direction, ignore_single)
    -- Can abort if no other window in tab to jump to
    if direction == nil
        or (ignore_single and #(vim.api.nvim_tabpage_list_wins(0)) == 1)
    then
        return
    end
    if keys == nil then
        keys = vim.fn.input("Window command: ")
    end

    local count = vim.v.count1
    local command =
    string.gsub(M.t(keys), "^normal%s", "normal " .. tostring(count), 1)
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
M.win_put = function(register, win_id)
    win_id = M.default_arg(win_id, U.data.recents["window"])
    if win_id == nil then
        return
    end
    register = M.default_arg(register, "+")
    local command = "put " .. register
    vim.fn.win_execute(win_id, command)
end

--Substitute default value for omitted argument
M.default_arg = function(arg, default)
    return (arg == nil and default) or arg
end

-- double controls whether to concatenate if string already has prefix/suffix
M.surround_string = function(string, prefix, postfix, double)
    prefix = M.default_arg(prefix, "'")
    postfix = M.default_arg(postfix, "'")
    double = M.default_arg(double, false)
    prefix = (double or string.sub(string, 1, 1) ~= prefix) and prefix or ""
    postfix = (double or string.sub(string, -1, -1) ~= postfix) and postfix
        or ""
    return string ~= "" and (prefix .. string .. postfix) or string
end

-- Modify register with function
M.modify_register = function(func, register, ...)
    register = M.default_arg(register, "+")
    local current = vim.fn.getreg(register)
    local new = func(current, ...)
    vim.fn.setreg(register, new)
    --return new
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
            .. tostring(vim.o[opt])
        )
    end
end
-- Count each value of a given option across all buffers
M.summarize_option = function(opt)
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

M.get_input = function(str)
    return vim.fn.input("Enter expansion for " .. str)
end

M.no_jump = function(cmd)
    cmd = cmd or ("normal " .. vim.fn.input("Normal command: "))
    print("\n")
    local old_pos = vim.fn.getpos(".")
    M.repeat_cmd(cmd)
    vim.fn.setpos(".", old_pos)
end
M.no_jump_safe = M.safe_call(M.no_jump)

M.refresh = function(file)
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

-- Dump command output to scratch buffer
M.capture_output = function(cmd)
    local output = vim.fn.execute(cmd)
    local register = "z"
    vim.fn.setreg(register, output)
    local func = function()
        vim.cmd("put " .. register)
    end
    U.buffer.make_scratch(func)
end
M.capture_output = M.with_register(M.capture_output, "z")

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
M.expand_pair = function(char, mode)
    --Credit  https://stackoverflow.com/questions/23323747/vim-vimscript-get-exact-character-under-the-cursor
    local next_char = M.get_char(1, mode)
    out = string.find(next_char, "%w") and char
        or char .. M.get_pair(char) .. M.t("<left>")
    return out
end

--Move cursor one index right if next character matches char position, otherwise put character
M.match_pair = function(char)
    local next_char = M.get_char(1)
    return next_char == char and M.t("<right>") or char
end
M.compose_commands = function(...)
    local args = { ... }
    return function()
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

M.file_exists = function(path)
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
M.dir_exists = function(path)
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
    if not M.dir_exists(session_dir) then
        print("Session directory " .. session_dir(" does not exist"))
        return
    end
    local this_session = vim.g.current_session
        or (
        vim.v.this_session ~= nil
            and vim.v.this_session ~= ""
            and vim.fn.systemlist(--Check if session file exists with current session name
                'basename -s ".vim" ' .. M.surround_string(vim.v.this_session)
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
    if name_provided and M.file_exists(path) then
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
    if not M.dir_exists(session_dir) then
        print("Session directory " .. session_dir(" does not exist"))
        return
    end
    -- Shell-quote for safety
    local latest_session =
    vim.fn.systemlist("lastn " .. session_dir .. " 1 echo")[1]
    local session_name = vim.fn.systemlist(
        "basename -s '.vim' " .. M.surround_string(latest_session, "'")
    )[1]
    local safe_source = function(file)
        vim.cmd("source " .. file)
    end

    if vim.fn.filereadable(latest_session) ~= 1 then
        print(
            "Session file "
            .. M.surround_string(latest_session)
            .. " does not exist or cannot be read"
        )
        return
    end
    vim.cmd("source " .. latest_session)
    vim.g.current_session = session_name
    print("Loading session " .. M.surround_string(session_name))
end

-- Utils
-- Knit an Rmarkdown file
M.knit = function(file, quiet, view_result)
    -- We have to get the full path of the output in case the YAML specifies a different output directory

    file = M.default_arg(file, M.recents["filetype"]["rmd"])
    if not M.file_exists(file) then
        print(M.surround_string(file) .. " does not exist")
        return
    end
    view_result = M.default_arg(view_result, true)
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

    if M.file_exists(outfile) then
        print("Rendered " .. M.surround_string(outfile))
        if view_result then
            vim.cmd("!zathura " .. vim.fn.shellescape(outfile) .. " &")
        end
    end
end
-- Buffer
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
        if open < 1
            and not string.find(string.sub(str, i + 1, -1), "%" .. close)
        then
            return i
        end
    end
    return string.len(str)
end

-- Util
M.match_paren = function()
    local char = M.get_char(0)
    local line = vim.fn.getline(".")
    local remainder = string.sub(line, vim.fn.col("."), -1)
    local close = M.get_pair(char)
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

-- Util
-- Display lines of command output (e.g., autocmd) matching pattern
M.grep_output = function(cmd, print_output, ...)
    print_output = M.default_arg(print_output, true)
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

-- Util
-- TODO recursively print tables
M.inspect = function(x)
    print(vim.inspect(x))
end

M.print_table = function(table)
    for _, val in ipairs(table) do
        if type(val) ~= "table" then
            print(val)
        else
            M.print_table(val)
        end
    end
end

-- Util
-- Standard string split. Credit https://stackoverflow.com/questions/1426954/split-string-in-lua
M.str_split = function(a_string, sep)
    sep = sep or "%s"
    local result = {}
    local pattern = "([^" .. sep .. "]+)"
    for str in string.gmatch(a_string, pattern) do
        table.insert(result, str)
    end
    return result
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

M.do_save_session = function(min_buffers)
    min_buffers = M.default_arg(min_buffers, 2)
    if U.buffer.count_bufs_by_type(true)["normal"] >= min_buffers
        and M.summarize_option("ft")["anki_vim"] == nil
    then
        M.save_session()
    end
end

-- Util
-- Collapse table into string
M.join = function(tab, join)
    join = M.default_arg(join, "")
    local out = table.remove(tab)
    for i = #tab, 1, -1 do
        out = tab[i] .. join .. out
    end
    return out
end

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
M.clamp = function(x, lower, upper)
    return math.min(math.max(x, lower), upper)
end

-- Buffer
-- Given a command and number, applies the command to the range of lines between the current line and
-- the number inclusive, clamping to file length
M.range_command = function(command, range, invert)
    range = M.default_arg(range, vim.v.count1)
    if range == "$" then
        range = vim.fn.line("$")
    end
    invert = M.default_arg(invert, false)
    local bound = (invert and -1 * range) or range
    local current_line = vim.fn.line(".")
    bound = M.clamp(current_line + bound, 1, vim.fn.line("$")) - current_line
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
function M.create_tags_for_yanked_columns(df)
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
    M.create_tags_for_yanked_columns(df)
end, {
    nargs = "?",
})

M.grow_list = function()

    --TODO grow list of item in document by inserting next line with correct preceding mark (e.g., * if * opens current line,
    --3 if 2 does, c if d does, etc.)
    --To be triggered by insert mapping
end

M.extract_to_default_arg = function(name)
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
    M.clean_definition(name)
end

-- Buffer
-- Alters a parameter in a function call, or a variable assignment, to reflect that
-- variable having been turned into a function argument (and therefore without a fixed value)
M.clean_definition = function(name)
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
M.clean_definition = M.with_position(M.clean_definition)

-- Get rid of empty undo files
-- Util
M.delete_undo = function()
    local pattern = "Not%san%sundo%sfile:%s"
    local lines = M.grep_output("messages", false, pattern)
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
M.replace_indices = function(str, sub, stride)
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
M.identity = function(x)
    return x
end
locate = function(args)
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
M.choose_picker = function()
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
M.table_menu = function(map, prompt, action)
    local choices = {}
    for key, _ in pairs(map) do
        table.insert(choices, key)
    end

    table.sort(choices)
    action = M.default_arg(action, function(choice, _)
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
M.setenv = function(variable, value, quote)
    if quote then
        value = M.surround_string(value, "'")
    end
    vim.fn.system("export " .. variable .. "=" .. value)
end

--Basic set data type implementation, suggested by docs
M.set = function(keys)
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

M.promote = function(x)
    return (type(x) == "table" and x) or { x }
end

M.demote = function(x)
    return (type(x) == "table" and (#x > 0 and x[1]) or x) or x
end

-- Util
-- Confirm all values are equal
M.all_equal = function(...)
    local args = { ... }
    while #args > 1 do
        if args[1] ~= args[2] then
            return false
        end
        table.remove(args, 1)
    end
    return true
end

M.str_trim = function(string)
    return string.gsub(string.gsub(string, "^%s+", ""), "%s+$", "")
end

-- The higher-order function
M.map = function(x, f)
    for i, val in ipairs(x) do
        x[i] = f(val)
    end
    return x
end
return M
