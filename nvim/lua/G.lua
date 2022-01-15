--For special global variable denoting Lua functions callable from Vimscript
--
--Suggested by official guide: Print lua objects

function _G.put(...)
  local objects = {}
  for i = 1, select('#', ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end


  print(table.concat(objects, '\n'))
  return ...
end
function _G.refresh(file)
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
    print(cmd)
    vim.cmd(cmd)
end
