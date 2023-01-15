local dap_python = require("dap-python")
dap_python.setup("~/.virtualenvs/debugpy/bin/python")
-- Use virtualenv interpreter if available
dap_python.resolve_python = function()
    local virtualenv = os.getenv("VIRTUALENV")
    return (virtualenv ~= "" and virtualenv) or "/usr/bin/python3.11"
end
