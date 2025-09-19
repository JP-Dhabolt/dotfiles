if not vim.g.vscode then
  return
end

-- Without the keymap plugin, I need a longer timeout
vim.o.timeoutlen = 1000

local vs = require 'vscode'

-- Formatting is handled by VS Code, not Neovim LSPs
vim.keymap.set('n', '<leader>f', function()
  vs.call 'editor.action.formatDocument'
end, { desc = '[F]ormat document' })

-- Comment keymaps
vim.keymap.set('v', '<C-/>', '<Plug>VSCodeCommentaryLine', { desc = 'Toggle commented line' })
vim.keymap.set('n', '<C-/>', '<Plug>VSCodeCommentaryLine', { desc = 'Toggle commented line' })
-- In some terminals, <C-_> maps to Ctrl+/
vim.keymap.set('v', '<C-_>', '<Plug>VSCodeCommentaryLine', { desc = 'Toggle commented line' })
vim.keymap.set('n', '<C-_>', '<Plug>VSCodeCommentaryLine', { desc = 'Toggle commented line' })

-- Open settings
vim.keymap.set('n', '<leader>os', function()
  vs.call 'workbench.action.openSettings'
end, { desc = '[O]pen [S]ettings' })

-- Restart Neovim Extension
vim.keymap.set('n', '<leader>rn', function()
  vs.call 'vscode-neovim.restart'
end, { desc = '[R]estart [N]eovim' })

-- Search Files
vim.keymap.set('n', '<leader>sf', function()
  vs.call 'workbench.action.quickOpen'
end, { desc = '[S]earch [F]iles' })

-- Search Grep
vim.keymap.set('n', '<leader>sg', function()
  vs.call 'workbench.action.findInFiles'
end, { desc = '[S]earch by [G]rep' })

-- Show Commands
vim.keymap.set('n', '<leader>sc', function()
  vs.call 'workbench.action.showCommands'
end, { desc = '[S]how [C]ommands' })

-- Go to next problem
vim.keymap.set('n', 'gp', function()
  vs.call 'editor.action.marker.next'
end, { desc = '[G]oto next [P]roblem' })

-- Go to next problem in workspace
vim.keymap.set('n', 'gP', function()
  vs.call 'editor.action.marker.nextInFiles'
end, { desc = '[G]oto next [P]roblem in workspace' })

-- Toggle Terminal
vim.keymap.set('n', '<leader>tt', function()
  vs.call 'workbench.action.terminal.toggleTerminal'
end, { desc = '[T]oggle [T]erminal' })

-- Toggle Copilot Chat
vim.keymap.set('n', '<leader>cc', function()
  vs.call 'workbench.action.chat.openagent'
end, { desc = '[C]opilot [C]hat' })

-- Explorer
vim.keymap.set('n', '-', function()
  vs.call 'workbench.view.explorer'
end, { desc = 'Open [E]xplorer' })

-- Rename
vim.keymap.set('n', 'grn', function()
  vs.call 'editor.action.rename'
end, { desc = '[G]oto [R]e[N]ame' })

-- Open File Symbols
vim.keymap.set('n', 'gO', function()
  vs.call 'workbench.action.gotoSymbol'
end, { desc = 'Open Document Symbols' })

-- Open Workspace Symbols
vim.keymap.set('n', 'gW', function()
  vs.call 'workbench.action.showAllSymbols'
end, { desc = 'Open Workspace Symbols' })
