vim.pack.add { 'https://codeberg.org/mfussenegger/nvim-dap' }

local function get_debugpy_python()
  if vim.fn.executable 'pipx' == 0 then
    vim.notify('pipx is not installed, cannot find debugpy', vim.log.levels.WARN)
    return nil
  end
  local result = vim.fn.systemlist { 'pipx', 'environment', '--value', 'PIPX_LOCAL_VENVS' }
  if vim.v.shell_error ~= 0 or #result == 0 then
    vim.notify('Failed to get pipx venvs path: ' .. table.concat(result, '\n'), vim.log.levels.WARN)
    return nil
  end
  local venvs_path = result[1]:gsub('[\r\n]', '')
  if venvs_path and venvs_path ~= '' then
    if vim.fn.has 'win32' == 1 then
      return venvs_path .. '\\debugpy\\Scripts\\python.exe'
    else
      return venvs_path .. '/debugpy/bin/python'
    end
  end
end

local dap = require 'dap'
dap.adapters.python = function(cb, config)
  if config.request == 'attach' then
    local port = (config.connect or config).port
    local host = (config.connect or config).hsot or '127.0.0.1'
    cb {
      type = 'server',
      port = assert(port, '`connect.port` is required for a python `attach` configuration'),
      host = host,
      options = {
        source_filetype = 'python',
      },
    }
  else
    local debugpy_python = os.getenv 'NVIM_DEBUGPY_PYTHON' or get_debugpy_python() or 'python'
    vim.notify('Using debugpy from: ' .. debugpy_python)
    cb {
      type = 'executable',
      command = debugpy_python,
      args = { '-m', 'debugpy.adapter' },
      options = {
        source_filetype = 'python',
      },
    }
  end
end

dap.configurations.python = {
  {
    type = 'python',
    request = 'launch',
    name = 'Launch file',

    program = '${file}',
    pythonPath = function()
      local venv_path = os.getenv 'VIRTUAL_ENV'
      if venv_path then
        if vim.fn.has 'win32' == 1 then
          return venv_path .. '\\Scripts\\python.exe'
        else
          return venv_path .. '/bin/python'
        end
      else
        return 'python'
      end
    end,
  },
}
