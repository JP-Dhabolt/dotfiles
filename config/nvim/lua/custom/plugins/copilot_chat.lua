-- Straight plugin imports
return {
  'CopilotC-Nvim/CopilotChat.nvim',
  dependencies = {
    { 'nvim-lua/plenary.nvim', branch = 'master' },
  },
  build = 'make tiktoken',
  opts = {
    model = 'gpt-4.1', -- AI model to use
    temperature = 0.1, -- Lower = focused, higher = creative
    window = {
      layout = 'float', -- 'vertical', 'horizontal', 'float'
      width = 0.8, -- 50% of screen width
      height = 0.8, -- 80% of screen height
      border = 'rounded', -- Border style
      title = '🤖 AI Assistant',
      zindex = 100,
    },
    auto_insert_mode = true, -- Enter insert mode when opening
  },
  config = function(_, opts)
    require('CopilotChat').setup(opts)
    vim.keymap.set('n', '<leader>gt', '<cmd>CopilotChatToggle<cr>', { desc = '[T]oggle Copilot Chat' })
    vim.keymap.set('n', '<leader>go', '<cmd>CopilotChatOpen<cr>', { desc = '[O]pen Copilot Chat' })
    vim.keymap.set('n', '<leader>gr', '<cmd>CopilotChatReset<cr>', { desc = '[R]eset Copilot Chat' })
    vim.api.nvim_create_autocmd('BufEnter', {
      pattern = 'copilot-*',
      callback = function()
        vim.opt_local.relativenumber = false
        vim.opt_local.number = false
        vim.opt_local.conceallevel = 0
      end,
    })
  end,
}
