local function set_python_path(command)
  local path = command.args
  local clients = vim.lsp.get_clients {
    bufnr = vim.api.nvim_get_current_buf(),
    name = 'pyright',
  }
  for _, client in ipairs(clients) do
    if client.settings then
      client.settings.python = vim.tbl_deep_extend('force', client.settings.python --[[@as table]], { pythonPath = path })
    else
      client.config.settings = vim.tbl_deep_extend('force', client.config.settings, { python = { pythonPath = path } })
    end
    client:notify('workspace/didChangeConfiguration', { settings = nil })
  end
end

local function get_poetry_venv_python(workspace)
  local handle = io.popen('cd ' .. vim.fn.shellescape(workspace) .. ' && poetry env info -p 2>/dev/null', 'r')
  if handle then
    local venv_path = handle:read '*l'
    handle:close()
    if venv_path and #venv_path > 0 then
      local suffix = vim.fn.has 'win32' == 1 and '/Scripts/python.exe' or '/bin/python'
      return venv_path .. suffix
    end
  end
  return nil
end

---@type vim.lsp.Config
return {
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'LspPyrightSetPythonPath', set_python_path, {
      desc = 'Reconfigure pyright with the provided python path',
      nargs = 1,
      complete = 'file',
    })
    local set_poetry_venv_cmd = function()
      local workspace = client.config.root_dir or vim.fn.getcwd()
      set_python_path { args = get_poetry_venv_python(workspace) or '' }
    end
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lp', '', {
      desc = 'Set pyright python path to poetry venv',
      callback = set_poetry_venv_cmd,
    })
  end,
}
