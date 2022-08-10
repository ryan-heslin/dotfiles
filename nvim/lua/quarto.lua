-- Patterns to match chunk beginning and end lines
--
chunk_start = "^%s*```{python.*$"
chunk_end = "^%s*```$"

-- Send a code chunk to a slime REPL
run_chunk = function(buffer)
    if buffer == nil then
        buffer = 0
    end
    -- 1-based index!
    local current_line = vim.fn.line(".")
    local last_line = vim.fn.line("$")
    -- This function is 0-indexed
    local buffer_lines = vim.api.nvim_buf_get_lines(buffer, 0, last_line, {})
    local error_prefix = "Invalid line: "
    local line
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
    --local n_lines = nearest_end - nearest_start + 1
    --local lines_to_send = {}
    --
    --for i = nearest_start, nearest_end, 1 do
    --lines_to_send.insert(buffer_lines[i])
    --end
    --send_to_repl(table.concat(lines_to_send, "\n"))
end

send_to_repl = function(text) end

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
function parse_code_chunks(buffer)
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
    local code = {}
    local chunk_started, chunk_ended
    local in_chunk = false
    for _, line in ipairs(buffer_lines) do
        chunk_started = string.match(line, chunk_start)
        chunk_ended = string.match(line, chunk_end)
        -- Case 1: in chunk in last iteration
        if in_chunk then
            if chunk_started then
                print("Invalid buffer: chunk start inside chunk")
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
            if chunk_ended then
                print("Invalid buffer: chunk end outside chunk")
                return {}
            end
            if chunk_started then
                in_chunk = true
            end
            -- If outside chunk and not start or end, do nothing
        end
        --local slime_config = vim.api.nvim_buf_get_var(buffer, "slime_config")
    end
    return code
end

-- Wrapper to parse all chunks, then run code
run_all_chunks = function(buffer)
    -- Wrapper to parse all chunks, then run code
    local code = parse_code_chunks(buffer)
    -- Have to join with newlines
    vim.fn["slime#send"](table.concat(code, "\n"))
end
