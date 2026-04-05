vim.pack.add {
  'https://codeberg.org/mfussenegger/nvim-dap',
  'https://github.com/nvim-neotest/nvim-nio',
  'https://github.com/rcarriga/nvim-dap-ui',
  'https://github.com/guysoft/vscodium.nvim',
}

local is_windows = vim.fn.has 'win32' == 1 or vim.fn.has 'win64' == 1
local python_bin = is_windows and 'Scripts/python' or 'bin/python'
local dap = require 'dap'
local dapui = require 'dapui'
dapui.setup()
vim.keymap.set({ 'n' }, '<leader>du', dapui.toggle, { desc = 'Toggle DAP [U]I' })
vim.keymap.set({ 'n' }, '<leader>dd', '<cmd>DapNew<CR>', { desc = 'Start [D]ebug' })
vim.keymap.set({ 'n' }, '<F5>', '<cmd>DapNew<CR>', { desc = 'Start Debug' })
vim.keymap.set({ 'n' }, '<leader>db', '<cmd>DapToggleBreakpoint<CR>', { desc = 'Toggle [B]reakpoint' })
vim.keymap.set({ 'n' }, '<leader>dB', '<cmd>DapClearBreakpoints<CR>', { desc = 'Clear [B]reakpoints' })
vim.keymap.set({ 'n' }, '<F9>', '<cmd>DapToggleBreakpoint<CR>', { desc = 'Toggle Breakpoint' })
vim.keymap.set({ 'n' }, '<leader>do', '<cmd>DapStepOver<CR>', { desc = 'Step [O]ver' })
vim.keymap.set({ 'n' }, '<F10>', '<cmd>DapStepOver<CR>', { desc = 'Step Over' })
vim.keymap.set({ 'n' }, '<leader>di', '<cmd>DapStepInto<CR>', { desc = 'Step [I]nto' })
vim.keymap.set({ 'n' }, '<F11>', '<cmd>DapStepInto<CR>', { desc = 'Step Into' })
vim.keymap.set({ 'n' }, '<leader>dO', '<cmd>DapStepOut<CR>', { desc = 'Step [O]ut' })
vim.keymap.set({ 'n' }, '<S-F11>', '<cmd>DapStepOut<CR>', { desc = 'Step Out' })
vim.keymap.set({ 'n' }, '<leader>dr', '<cmd>DapContinue<CR>', { desc = '[D]ebug [R]esume' })
vim.keymap.set({ 'n' }, '<C-F5>', '<cmd>DapContinue<CR>', { desc = 'Debug Resume' })
vim.keymap.set({ 'n' }, '<leader>dl', '<cmd>DapOpenLog<CR>', { desc = '[D]ebug [L]og' })
vim.keymap.set({ 'n' }, '<leader>ds', '<cmd>DapDisconnect<CR>', { desc = '[D]ebug [S]top' })
vim.keymap.set({ 'n' }, '<S-F5>', '<cmd>DapDisconnect<CR>', { desc = '[D]ebug [S]top' })
vim.keymap.set({ 'n' }, '<leader>de', function()
  dapui.eval(nil, { enter = true })
end, { desc = '[D]ebug [E]valuate' })

require('nvim-launch').setup {
  tmux_pane = 1,
  tmux_clear = true,
  type_to_command = {
    debugpy = 'debugpy',
    python = 'debugpy',
    node = 'node',
    ['pwa-node'] = 'node',
  },
  quickui_menu = true, -- Set to false if using quickui_config.vim
}

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
    local mason_debugpy = vim.fn.stdpath 'data' .. '/mason/packages/debugpy/venv/' .. python_bin
    local debugpy_python = os.getenv 'NVIM_DEBUGPY_PYTHON' or (vim.fn.executable(mason_debugpy) == 1 and mason_debugpy) or 'python'
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
        return venv_path .. '/' .. python_bin
      else
        return 'python'
      end
    end,
  },
}
