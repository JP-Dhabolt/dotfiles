return { -- Vimwiki
  'vimwiki/vimwiki',
  event = 'BufEnter *.md',
  keys = { '<leader>k' },
  init = function()
    vim.g.vimwiki_list = {
      {
        path = os.getenv 'WIKI_LOC',
        auto_tags = 1,
        syntax = 'markdown',
        ext = '.md',
        nested_syntaxes = {
          py = 'python',
          ['c++'] = 'cpp',
          yaml = 'yaml',
          json = 'json',
          js = 'javascript',
          ts = 'typescript',
        },
      },
    }
    vim.g.vimwiki_global_ext = 0
    vim.g.vimwiki_ext2syntax = {
      ['.md'] = 'markdown',
      ['.markdown'] = 'markdown',
      ['.mdown'] = 'markdown',
    }
    vim.api.nvim_create_augroup('vimwikigroup', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
      group = 'vimwikigroup',
      pattern = 'diary.md',
      command = 'VimwikiDiaryGenerateLinks',
    })
  end,
  config = function()
    -- Remap away from <leader>w prefix
    vim.keymap.set('n', '<leader>kw', '<Plug>VimwikiIndex', { desc = 'vimwiki [W]indow' })
    vim.keymap.set('n', '<leader>kt', '<Plug>VimwikiTabIndex', { desc = 'vimwiki in new [T]ab' })
    vim.keymap.set('n', '<leader>ki', '<Plug>VimwikiDiaryIndex', { desc = 'vimwiki Diary [I]ndex' })
    vim.keymap.set('n', '<leader>ks', '<Plug>VimwikiUISelect', { desc = 'vimwiki UI [S]elect' })
    vim.keymap.set('n', '<leader>k<leader>i', '<Plug>VimwikiDiaryGenerateLinks', { desc = 'vimwiki generate [I]ndex links' })
    vim.keymap.set('n', '<leader>k<leader>t', '<Plug>VimwikiTabMakeDiaryNote', { desc = 'vimwiki make wiki diary in [T]ab' })
    vim.keymap.set('n', '<leader>k<leader>y', '<Plug>VimwikiMakeYesterdayDiaryNote', { desc = 'vimwiki make [Y]esterday wiki diary' })
    vim.keymap.set('n', '<leader>k<leader>m', '<Plug>VimwikiMakeTomorrowDiaryNote', { desc = 'vimwiki make to[M]orrow wiki diary' })
    vim.keymap.set('n', '<leader>k<leader>w', '<Plug>VimwikiMakeDiaryNote', { desc = 'vimwiki make [W]iki diary' })

    -- Clear existing
    vim.keymap.del('n', '<leader>ww')
    vim.keymap.del('n', '<leader>wt')
    vim.keymap.del('n', '<leader>wi')
    vim.keymap.del('n', '<leader>ws')
    vim.keymap.del('n', '<leader>w<leader>i')
    vim.keymap.del('n', '<leader>w<leader>t')
    vim.keymap.del('n', '<leader>w<leader>y')
    vim.keymap.del('n', '<leader>w<leader>m')
    vim.keymap.del('n', '<leader>w<leader>w')
  end,
}
