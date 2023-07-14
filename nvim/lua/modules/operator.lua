local M = {}

--Operator
-- Get start and end of operator-pending register
M.get_operator_pos = function(buffer)
    local start_pos = vim.api.nvim_buf_get_mark(buffer, "[")
    --(row, col)
    local end_pos = vim.api.nvim_buf_get_mark(buffer, "]")
    return start_pos, end_pos
end

-- Operator
-- Extract text from the latest motion;
-- intended to help define custom operators
M.capture_motion_text = function(buffer, type)
    local start_pos, end_pos = M.get_operator_pos(buffer)
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
M.term_motion_impl = function(type)
    local text = M.capture_motion_text(vim.api.nvim_get_current_buf(), type)

    -- Need special escaping for Python files
    if vim.bo.filetype == "python" or vim.bo.filetype == "quarto" then
        vim.fn["slime#send"]("%cpaste -q\n")
        vim.fn["slime#send"](collapse_text(text))
        vim.fn["slime#send"]("\n--\n")
    else
        U.terminal.term_exec(text, true, false)
    end
end

-- Creates a function that implements an operator that takes two motions,
-- then swaps text selected by the first one with the second
-- Cross-buffer capable
-- Operator
M.swap_impl_factory = function()
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

        local new_text = M.capture_motion_text(current_buffer, selection_type)
        -- Newlines disallowed by API function, so split into   table
        if type(new_text) == "string" then
            if string.match(new_text, "\n") then
                processed_text = U.utils.str_split(new_text, "\n")
            else
                processed_text = { new_text }
            end
        end
        print(new_text)

        local start_pos, end_pos =
        correct_positions(M.get_operator_pos(current_buffer))

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

            old_text = U.utils.map(old_text, U.utils.str_trim)
            processed_text = U.utils.map(processed_text, U.utils.str_trim)
            local result, err = pcall(function()
                replace_text(old_buffer, old_start, old_end, processed_text)
            end)
            -- If swapping on same line, account for offset from swapping old for new, which
            -- throws off target col indices
            local line_difference = string.len(U.utils.demote(old_text))
                - string.len(U.utils.demote(processed_text))
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
            correct_positions(M.get_operator_pos(new_buffer))
            -- Adust indices to account for replacement offset
            -- TODO test same-line case
            -- print(vim.inspect(old_start))
            -- print(vim.inspect(old_end))
            -- print(vim.inspect(new_start))
            -- print(vim.inspect(new_end))
            if U.utils.all_equal(
                old_start[1],
                old_end[1],
                new_start[1],
                new_end[1]
            )
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
M.swap_impl = M.swap_impl_factory()

M.define_operator = function(func, name, err)
    return function(type)
        if type == nil or type == "" then
            vim.go.operatorfunc = "v:lua." .. name
            return "g@"
        end

        local out = pcall(func(type), err)
        U.data.restore_default("operatorfunc")

        return out
    end
end

M.term_motion = M.define_operator(
    M.term_motion_impl,
    "U.operator.term_motion",
    "Error sending text to terminal"
)

M.swap = M.define_operator(
    M.swap_impl,
    "U.operator.swap",
    "Error swapping text selections"
)

M.record_motion = function()
    local motion = vim.fn.input("")
    -- local _, err = pcall(function()
    --     vim.cmd.normal(" " .. motion)
    -- end)
    -- if err then
    --     return
    -- end
    vim.fn.setreg("z", motion)
end
return M
