vim.keymap.set('n', '<leader><space>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<space>', 'za', { desc = 'Toggle fold' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', 'J', 'mzJ`z', { desc = '[J]oin lines' })

-- This won't work in all terminals, fallback to <C-\><C-n>
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Automatically execute and/or source
vim.keymap.set('n', '<leader><leader>x', '<cmd>source %<CR>', { desc = 'Source current file' })
vim.keymap.set('n', '<leader>x', ':.lua<CR>', { desc = 'e[X]ecute the file' })
vim.keymap.set('v', '<leader>x', ':lua<CR>', { desc = 'e[X]ecute the selection' })
