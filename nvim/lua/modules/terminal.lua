local M = {}
-- Configure standard options when entering terminal, and record metadata in global variables
M.set_term_opts = function()
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
M.term_yank = function(term_id, prompt_pattern, offset)
    if term_state == nil or term_state == {} then
        return
    end
    prompt_pattern = U.utils.default_arg(prompt_pattern, [[>\s[^ ]\+]])
    offset = U.utils.default_arg(offset, -1)
    term_id = U.utils.default_arg(term_id, term_state["last_terminal_win_id"])
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
    return string.gsub(U.utils.join(text, ""), "^.+>", "")
end
--
-- Given a table of global variables, invert the value of each if it exists (1 -> 0, true -> false)
--Data
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

-- Start new terminal buffer
M.term_setup = function()
    vim.cmd.vsplit()
    vim.cmd([[normal l]])
    vim.cmd.terminal()
    vim.cmd([[normal k]])
    U.utils.win_exec("startinsert", "l")
end

-- Building on https://vi.stackexchange.com/questions/21449/send-keys-to-a-terminal-buffer/21466
M.term_exec = function(keys, scroll_down, use_count)
    if term_state == nil or term_state["last_terminal_chan_id"] == nil then
        return false
    end

    --Use count only if specified
    use_count = U.utils.default_arg(use_count, true)
    scroll_down = U.utils.default_arg(scroll_down, true)
    local count = (use_count and vim.v.count1) or 1
    local command = (string.find(keys, [[\]]) and U.utils.t(keys)) or keys

    for _ = 1, count, 1 do
        vim.fn.chansend(term_state["last_terminal_chan_id"], command)
    end
    vim.fn.chansend(term_state["last_terminal_chan_id"], U.utils.t("<CR>"))
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

-- Mostly copied from https://vi.stackexchange.com/questions/11310/what-is-a-scratch-window
-- Makes a scratch buffer
M.make_scratch = function(command_fn)
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

M.term_edit = function(history_command, syntax)
    history_command = history_command or "history -w /tmp/history.txt"
    syntax = syntax or "bash"
    U.utils.term_exec(history_command)
    U.utils.make_scratch(
        U.utils.compose_commands(
            "read /tmp/history.txt",
            "setlocal number syntax=" .. syntax,
            "normal G",
            "autocmd "
        )
    )
end
--Term
M.term_toggle = function()
    if term_state ~= nil then
        hidden =
        vim.fn.getbufinfo(term_state["last_terminal_buf_id"])[1]["hidden"]
        if hidden == 1 then --open if not displayed
            vim.cmd.vsplit()
            vim.cmd.buffer(term_state["last_terminal_buf_id"])
            vim.cmd.normal(U.utils.t("<C-w>L"))
        else -- close if displayed
            vim.api.nvim_win_close(term_state["last_terminal_win_id"], false)
        end
    else
        M.term_setup()
    end
end

M.get_term_history = function(cmd_gen)
    local temp_file = os.tmpname()
    if U.utils.file_exists(temp_file) then
        os.remove(temp_file)
    end
    local cmd = cmd_gen(temp_file)

    M.term_exec(cmd, false, false)
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

M.display_term_history = function(lines, syntax)
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
        M.term_exec(line, false, false)
        vim.cmd.q()
    end

    vim.api.nvim_win_call(term_state["last_terminal_win_id"], function()
        U.buffer.make_scratch(function()
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

M.history = function(syntax)
    local functions = {
        bash = function(f)
            return [[history  | sed -E 's/\s*[0-9]*\s*//' > ]]
                .. U.utils.surround_string(f)
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
    local lines = M.get_term_history(command)
    M.display_term_history(lines, syntax)
end
return M
