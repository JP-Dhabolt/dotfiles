return { -- nerdcommenter
  'scrooloose/nerdcommenter',
  config = function()
    vim.keymap.set('v', '<C-/>', '<Plug>NERDCommenterToggle', { desc = 'Toggle commented line' })
    vim.keymap.set('n', '<C-/>', '<Plug>NERDCommenterToggle', { desc = 'Toggle commented line' })
    -- In some terminals, <C-_> maps to Ctrl+/
    vim.keymap.set('v', '<C-_>', '<Plug>NERDCommenterToggle', { desc = 'Toggle commented line' })
    vim.keymap.set('n', '<C-_>', '<Plug>NERDCommenterToggle', { desc = 'Toggle commented line' })
    vim.keymap.set('v', '<M-_>', '<Plug>NERDCommenterToggle', { desc = 'Toggle commented line' })
    vim.keymap.set('n', '<M-_>', '<Plug>NERDCommenterToggle', { desc = 'Toggle commented line' })
    -- Add spaces after comment delimiters by default
    vim.g.NERDSpaceDelims = 1
    -- Use compact syntax for prettified multi-line comments
    vim.g.NERDCompactSexyComs = 1
    -- Align line-wise comment delimiters flush left instead of following code indentation
    vim.g.NERDDefaultAlign = 'left'
    -- Allow commenting and inverting empty lines (useful when commenting a region)
    vim.g.NERDCommentEmptyLines = 1
    -- Enable trimming of trailing whitespace when uncommenting
    vim.g.NERDTrimTrailingWhitespace = 1
    -- Enable Toggle to check if all selected lines are commented or not
    vim.g.NerdToggleCheckAllLines = 1
  end,
}
