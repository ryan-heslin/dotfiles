-- Patterns to match chunk beginning and end lines
--
-- TODO use unpack to handle parser with multiple return values

-- Form text into newline-separated string, adding
-- space to ensure last line is evaluated
collapse_text = function(text)
    table.insert(text, " ")
    return table.concat(text, "\n")
end

create_send_function = function(parser, sender)
    return function(...)
        local result = parser(...)
        return sender(result)
    end
end
chunk_start = "^%s*```{python.*$"
-- Vim pattern, not Lua
any_chunk_start = [[^\s*```{[a-z]\+]]
chunk_end = "^%s*```$"

-- Send a code chunk to a slime REPL
run_current_chunk = function(buffer)
    if buffer == nil then
        buffer = 0
    end
    local buffer_name = vim.api.nvim_buf_get_name(buffer)

    -- 1-based index!
    local current_line = vim.fn.line(".", vim.fn.bufwinid(buffer_name))
    local last_line = vim.fn.line("$")
    -- This function is 0-indexed
    local buffer_lines = vim.api.nvim_buf_get_lines(buffer, 0, last_line, {})
    local error_prefix = "Invalid line: "
    -- Both loops include current line
    -- Find nearest chunk start
    local nearest_start = get_table_match_index(
        buffer_lines,
        current_line,
        0,
        -1,
        chunk_start,
        chunk_end
    )
    if nearest_start == nil then
        return
    end

    local nearest_end = get_table_match_index(
        buffer_lines,
        current_line,
        last_line + 1,
        1,
        chunk_end,
        chunk_start
    )
    if nearest_end == nil then
        return
    end
    -- Fail on empty chunk
    if nearest_end - nearest_start < 2 then
        return
    end
    -- Exclude start and end lines, which lack valid Python code
    vim.fn["slime#send_range"](nearest_start + 1, nearest_end - 1)
    return nearest_start + 1, nearest_end - 1
end

-- Gets first index of table that matches pattern, or nil if an "abort" pattern is encountered before it
get_table_match_index =
    function(lines, start, stop, step, match_pattern, abort_pattern)
        local line
        for i = start, stop, step do
            line = lines[i]
            if string.match(line, match_pattern) then
                return i
            elseif i ~= start and string.match(line, abort_pattern) then
                -- Indicates invalid arrangement of lines
                break
            end
        end
        return nil
    end

-- Extract code in chunks from buffer, then join into string
function parse_code_chunks(buffer, stop_line)
    -- Get lines from buffer
    if buffer == nil then
        buffer = 0
    end
    local buffer_lines = vim.api.nvim_buf_get_lines(
        buffer,
        0,
        vim.fn.line("$"),
        {}
    )
    if stop_line == nil then
        stop_line = table.getn(buffer_lines)
    end
    local code = {}
    local chunk_started, chunk_ended
    local in_chunk = false
    -- Iterate over whole table even if stop_line specified in order to run contaiing
    -- chunk if stop_line part of a chunk
    for i, line in ipairs(buffer_lines) do
        chunk_started = string.match(line, chunk_start)
        chunk_ended = string.match(line, chunk_end)
        -- Case 1: in chunk in last iteration
        if in_chunk then
            if chunk_started then
                print("Invalid buffer: chunk start inside chunk at line" .. i)
                return {}
            end
            -- Reached chunk end
            if chunk_ended then
                in_chunk = false
                -- Add code line to output
            else
                table.insert(code, line)
            end
            -- Case 2: code inside chunk
        else
            -- Break early if stop line exceeded
            if i >= stop_line then
                break
            end
            if chunk_ended then
                print("Invalid buffer: chunk end outside chunk at line " .. i)
                return {}
            end
            if chunk_started then
                in_chunk = true
            end
            -- If outside chunk and not start or end, do nothing
        end
        --local slime_config = vim.api.nvim_buf_get_var(buffer, "slime_config")
    end
    --IPython indent escaping
    --table.insert(code, 1,"%cpaste -q\n" )
    --table.insert(code, "--\n")
    return code
    --return ["%cpaste -q\n", g:slime_dispatch_ipython_pause, a:text, "--\n"]
end

-- Disable autoindent to send text, to prevent indentation errors
toggle_autoindent = function(func)
    return function(...)
        M.term_exec("%autoindent on")
        local out = func(...)
        --M.term_exec("%autoindent on")
        return out
    end
end

run_all_chunks = create_send_function(parse_code_chunks, function(text)
    -- Janky but partially working
    vim.fn["slime#send"]("%cpaste -q\n")
    vim.fn["slime#send"](collapse_text(text))
    vim.fn["slime#send"]("\n--\n")
end)

run_current_chunks_above = create_send_function(function()
    return parse_code_chunks(
        0,
        vim.fn.line(".", vim.fn.bufwinid(vim.api.nvim_buf_get_name(0)))
    )
end, function(text)
    vim.fn["slime#send"](collapse_text(text))
end)

-- Run current line from a buffer
run_line = function(buffer)
    if buffer == nil then
        buffer = 0
    end
    local buffer_name = vim.api.nvim_buf_get_name(buffer)
    -- bufwinid takes a buffer name, not number
    local current_line = vim.fn.line(".", vim.fn.bufwinid(buffer_name))
    local line = vim.api.nvim_buf_get_lines(
        buffer,
        current_line - 1,
        current_line,
        {}
    )
    vim.fn["slime#send"](collapse_text(line))
end

-- Yank a specified text object (e.g., "ip") and process for sending to REPL
extract_text_object = function(buffer, text_object)
    -- Prserve old register contents, to be restored
    local old_register = vim.fn.getreg("z")
    if old_register == nil then
        old_register = ""
    end

    if buffer == nil then
        buffer = 0
    end
    local buf_win_id = vim.fn.bufwinid(vim.api.nvim_buf_get_name(buffer))

    local line = vim.fn.line(".", buf_win_id)
    local column = vim.fn.col(".")

    vim.fn.setreg("z", "")
    vim.cmd([[silent normal "zy]] .. text_object) -- "
    -- Reset cursor (moved by yank)
    vim.fn.cursor(line, column)
    local text = string.gsub(vim.fn.getreg("z"), "```[^\n]*\n", "\n")
    -- Yanking paragraphs gets chunk boundaries - remove them
    vim.fn.setreg("z", old_register)
    return text .. "\n "
end
run_paragraph = create_send_function(function()
    return extract_text_object(nil, "ip")
end, vim.fn["slime#send"])
run_word = create_send_function(function()
    return extract_text_object(nil, "iW")
end, vim.fn["slime#send"])

-- Returns the most recent visual selection in a buffer, regardless of the
-- mode used
parse_visual_selection = function(buffer)
    if buffer == nil then
        buffer = 0
    end
    -- Define visual registers "'<", "'>" marking selection bounds
    -- If either missing, return empty string
    -- Get visual mode (char, line, block)
    local mode = vim.fn.visualmode()
    local visual_start = "'<"
    local visual_end = "'>"
    local start_line = vim.fn.line(visual_start)
    local end_line = vim.fn.line(visual_end)
    local start_col = vim.fn.col(visual_start)
    local end_col = vim.fn.col(visual_end)
    -- Change order if needed so start line is higher in buffer
    if end_line < start_line then
        start_line, end_line = end_line, start_line
    end
    local selected_lines = vim.api.nvim_buf_get_lines(
        buffer,
        start_line - 1,
        end_line,
        {}
    )
    --print(vim.inspect(selected_lines))
    local n_lines = table.getn(selected_lines)
    -- If only one line selected, start and end col both occur on it, hence
    -- special case
    if n_lines == 1 then
        selected_lines[1] = string.sub(selected_lines[1], start_col, end_col)
    else
        -- Trim non-selected parts of start and end lines
        selected_lines[1] = string.sub(selected_lines[1], start_col)
        selected_lines[n_lines] = string.sub(
            selected_lines[n_lines],
            1,
            end_col
        )
    end
    return selected_lines
    --if mode == "v" then
    --elseif mode == "V" then
    --elseif mode == "^V" then
    --else
    --print("Invalid visual mode " .. mode)
    --return ""
    --end
end

send_visual_selection = create_send_function(
    parse_visual_selection,
    function(text)
        vim.fn["slime#send"](collapse_text(text))
    end
)

-- Move cursor `n_chunks` forward or backward
find_chunk = function(n_chunks)
    local match_line = nil
    local i = 0
    local flags = "W"
    local step = 1
    if n_chunks < 0 then
        -- Needed to use < condition for loop for both positive and negative cases
        n_chunks = n_chunks * -1
        -- Add flag to search backward
        flags = "b" .. flags
    end

    while match_line ~= 0 and i < n_chunks do
        -- Do not wrap around
        match_line = vim.fn.search(any_chunk_start, flags)
        i = i + step
    end
    return match_line
end

-- Find chunk by chunk name
-- If duplicate names, finds first, going down and wrapping
find_named_chunk = function(name)
    local pattern = [[^\s*```{.*\s*]] .. name .. [[}\s*$]]
    local flags = "w" -- Wrap
    return vim.fn.search(pattern, flags)
end

find_nth_chunk = function(n_chunks)
    if n_chunks < 1 then
        print("Invalid chunk offset " .. n_chunks)
        return
    end

    -- If new chunk not found, restore old position
    local old_pos = vim.fn.getpos(".")
    local new_pos = find_chunk(n_chunks)
    if new_pos == nil then
        vim.fn.setpos(old_pos)
    end
end

run_next_chunk = function()
    local next_chunk_start = find_chunk(1)

    -- Do not run if no next chunk found (i.e., cursor in last chunk in buffer)
    if next_chunk_start ~= 0 then
        run_current_chunk()
    end
end
--TODO:
-- 1. Jump to chunks by name/position (absolute or relative)
-- 2.  Run next chunk
--
-- TODO parse specific languages
