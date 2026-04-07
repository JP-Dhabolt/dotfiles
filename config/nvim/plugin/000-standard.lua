if vim.g.vscode then
  return
end

-- Build Requirements {{{
local function has_make()
  return vim.fn.executable 'make' == 1
end

local hooks = function(ev)
  -- Use available |event-data|
  local name, kind, path = ev.data.spec.name, ev.data.kind, ev.data.path

  vim.notify(string.format('Plugin %s has been %s', name, kind))
  -- Run build script after plugin's code has changed
  if not (kind == 'install' or kind == 'update') then
    return
  end

  if name == 'LuaSnip' and vim.fn.has 'win32' == 0 and has_make() then
    vim.notify 'Building LuaSnip for regex support in snippets...'
    -- Build LuaSnip for regex support in snippets
    vim.system({ 'make', 'install_jsregexp' }, { cwd = path })
  end

  if name == 'nvim-treesitter' then
    vim.notify 'Updating nvim-treesitter parsers...'
    if not ev.data.active then
      vim.cmd.packadd 'nvim-treesitter'
    end
    vim.cmd 'TSUpdate'
  end

  if name == 'telescope-fzf-native.nvim' and has_make() then
    vim.notify 'Building telescope-fzf-native for faster sorting in Telescope...'
    -- Build telescope-fzf-native.nvim for faster sorting in Telescope
    vim.system({ 'make' }, { cwd = ev.data.path })
  end

  if name == 'CopilotChat.nvim' and has_make() then
    vim.notify 'Building tiktoken for Copilot Chat token counting...'
    -- Build tiktoken for Copilot Chat token counting
    vim.system({ 'make', 'tiktoken' }, { cwd = ev.data.path })
  end
end
vim.api.nvim_create_autocmd('PackChanged', { callback = hooks })

local build_plugins = {
  'LuaSnip',
  'nvim-treesitter',
  'telescope-fzf-native.nvim',
  'CopilotChat.nvim',
}
-- }}}

vim.pack.add { 'https://github.com/tomasiser/vim-code-dark' } -- Theme
vim.cmd.colorscheme 'codedark'
vim.g.lightline = { colorscheme = 'codedark' }

if vim.g.have_nerd_font then
  vim.pack.add { 'https://github.com/nvim-tree/nvim-web-devicons' } -- Optional dependency for oil.nvim if you want file icons
end

vim.pack.add {
  'https://github.com/NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically
  'https://github.com/windwp/nvim-autopairs', -- Automatically insert pairs of characters
  'https://github.com/folke/lazydev.nvim', -- LuaLS Fast Setup.  Also dependency for blink.cmp
  { src = 'https://github.com/L3MON4D3/LuaSnip', version = vim.version.range '2.x' }, -- Dependency for blink.cmp
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range '1.x' }, -- Autocompletion plugin with built in LSP capabilities and snippet support
  'https://github.com/stevearc/conform.nvim', -- Autoformat
  'https://github.com/github/copilot.vim', -- Github Copilot
  { src = 'https://github.com/nvim-lua/plenary.nvim', version = 'master' }, -- Dependency for Copilot Chat AND todo-comments.nvim AND telescope.nvim
  'https://github.com/CopilotC-Nvim/CopilotChat.nvim', -- Copilot Chat
  'https://github.com/lewis6991/gitsigns.nvim', -- Git signs in the gutter
  'https://github.com/lukas-reineke/indent-blankline.nvim', -- Add indentation guides even on blank lines
  'https://github.com/echasnovski/mini.nvim', -- Collection of various small independent plugins/modules
  'https://github.com/scrooloose/nerdcommenter', -- Commenting plugin
  'https://github.com/stevearc/oil.nvim', -- File explorer that opens in the current buffer's window
  'https://github.com/folke/todo-comments.nvim', -- Highlight todo, notes, etc in comments
  'https://github.com/folke/which-key.nvim', -- Useful plugin to show you pending keybinds.
  'https://github.com/nvim-telescope/telescope-ui-select.nvim', -- Extension for telescope.nvim that allows you to use Telescope to select items in the UI (e.g. LSP code actions)
  'https://github.com/nvim-telescope/telescope-fzf-native.nvim', -- Extension for telescope.nvim that makes sorting faster
  'https://github.com/nvim-telescope/telescope.nvim', -- Fuzzy Finder (files, lsp, etc)
  'https://github.com/mason-org/mason.nvim', -- Useful for install LSP servers, DAP servers, linters, and formatters
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim', -- Wrapper around mason.nvim to install tools directly
  'https://github.com/j-hui/fidget.nvim', -- Useful status updates for LSP
  'https://github.com/neovim/nvim-lspconfig', -- Collection of common configurations for built-in LSP client
  'https://github.com/nvim-treesitter/nvim-treesitter', -- Treesitter configurations and abstraction layer
}

require('guess-indent').setup {} -- guess-indent configuration
require('nvim-autopairs').setup {} -- nvim-autopairs configuration

-- blink.cmp configuration {{{
require('luasnip').setup {}
require('blink-cmp').setup {
  keymap = {
    -- See :h blink-cmp-config-keymap for defining your own keymap
    preset = 'default',
    -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
    --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
  },
  appearance = {
    -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    -- Adjusts spacing to ensure icons are aligned
    nerd_font_variant = 'mono',
  },
  completion = {
    -- By default, you may press `<c-space>` to show the documentation.
    -- Optionally, set `auto_show = true` to show the documentation after a delay.
    documentation = { auto_show = false, auto_show_delay_ms = 500 },
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'lazydev' },
    providers = {
      lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
    },
  },
  snippets = { preset = 'luasnip' },
  -- See :h blink-cmp-config-fuzzy for more information
  fuzzy = { implementation = 'prefer_rust_with_warning' },
  -- Shows a signature help window while you type arguments for a function
  signature = { enabled = true },
}
-- }}}

-- conform.nvim configuration {{{
require('conform').setup {
  notify_on_error = false,
  format_on_save = function(bufnr)
    -- Disable "format_on_save lsp_fallback" for languages that don't
    -- have a well standardized coding style. You can add additional
    -- languages here or re-enable it for the disabled ones.
    local disable_filetypes = { c = true, cpp = true }
    if disable_filetypes[vim.bo[bufnr].filetype] then
      return nil
    else
      return {
        timeout_ms = 500,
        lsp_format = 'fallback',
      }
    end
  end,
  formatters_by_ft = {
    lua = { 'stylua' },
    -- Conform can also run multiple formatters sequentially
    -- python = { "isort", "black" },
    -- You can use 'stop_after_first' to run the first available formatter from the list
    -- javascript = { "prettierd", "prettier", stop_after_first = true },
  },
}
vim.api.nvim_set_keymap('', '<leader>f', '', {
  desc = '[F]ormat buffer',
  callback = function()
    require('conform').format { async = true, lsp_format = 'fallback' }
  end,
})
-- }}}

-- Copilot Chat Configuration {{{
require('CopilotChat').setup {
  model = 'claude-sonnet-4.6', -- AI model to use
  temperature = 0.1, -- Lower = focused, higher = creative
  window = {
    layout = 'vertical', -- 'vertical', 'horizontal', 'float'
    width = 0.3, -- 50% of screen width
    height = 1, -- 80% of screen height
    -- border = 'rounded', -- Border style
    title = '🤖 AI Assistant',
    -- zindex = 100,
  },
  auto_insert_mode = true, -- Enter insert mode when opening
}

vim.keymap.set('n', '<leader>gt', '<cmd>CopilotChatToggle<cr>', { desc = '[T]oggle Copilot Chat' })
vim.keymap.set('n', '<leader>go', '<cmd>CopilotChatOpen<cr>', { desc = '[O]pen Copilot Chat' })
vim.keymap.set('n', '<leader>gr', '<cmd>CopilotChatReset<cr>', { desc = '[R]eset Copilot Chat' })
vim.keymap.set('n', '<leader>gs', function()
  vim.ui.input({ prompt = 'Save chat as: ' }, function(name)
    if name and name ~= '' then
      local timestamp = os.date '%Y-%m-%dT%H-%M-%S'
      vim.cmd('CopilotChatSave ' .. timestamp .. '-' .. name)
    end
  end)
end, { desc = '[S]ave Copilot Chat' })
vim.keymap.set('n', '<leader>gl', function()
  local cc = require 'CopilotChat'
  local files = vim.fn.glob(cc.config.history_path .. '/*.json', false, true)
  if #files == 0 then
    vim.notify('No saved Copilot Chat conversations found', vim.log.levels.WARN)
    return
  end
  local names = vim.tbl_map(function(f)
    return vim.fn.fnamemodify(f, ':t:r')
  end, files)
  vim.ui.select(names, { prompt = 'Load Copilot Chat: ' }, function(name)
    if name and name ~= '' then
      vim.cmd('CopilotChatLoad ' .. name)
    end
  end)
end, { desc = '[L]oad Copilot Chat' })
vim.keymap.set('n', '<leader>gd', function()
  local cc = require 'CopilotChat'
  local files = vim.fn.glob(cc.config.history_path .. '/*.json', false, true)
  if #files == 0 then
    vim.notify('No saved Copilot Chat conversations found', vim.log.levels.WARN)
    return
  end
  local names = vim.tbl_map(function(f)
    return vim.fn.fnamemodify(f, ':t:r')
  end, files)
  vim.ui.select(names, { prompt = 'Delete Copilot Chat: ' }, function(name)
    if name and name ~= '' then
      vim.ui.input({ prompt = 'Delete "' .. name .. '"? (y/N): ' }, function(confirm)
        if confirm and confirm:lower() == 'y' then
          local path = cc.config.history_path .. '/' .. name .. '.json'
          local ok, err = os.remove(path)
          if ok then
            vim.notify('Deleted Copilot Chat: ' .. name)
          else
            vim.notify('Failed to delete: ' .. err, vim.log.levels.ERROR)
          end
        end
      end)
    end
  end)
end, { desc = '[D]elete Copilot Chat' })
vim.keymap.set('n', '<leader>gm', '<cmd>CopilotChatModels<cr>', { desc = 'Select [M]odel' })
-- vim.treesitter.language.register('off', { 'copilot-chat', 'copilot-diff', 'copilot-overlay' })
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = 'copilot-*',
  callback = function()
    local cc_config = require 'CopilotChat.config'
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
    vim.opt_local.conceallevel = 0
    vim.wo.winbar = '%=model: %#Comment#' .. (cc_config.model or 'unknown') .. ' '
  end,
})
-- }}}

-- Copilot.vim configuration {{{
vim.keymap.set('i', '<C-j>', 'copilot#Accept("")', {
  expr = true,
  replace_keycodes = false,
})
vim.g.copilot_no_tab_map = true
-- }}}

-- gitsigns configuration {{{
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
  on_attach = function(bufnr)
    local gitsigns = require 'gitsigns'

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal { ']c', bang = true }
      else
        gitsigns.nav_hunk 'next'
      end
    end, { desc = 'Jump to next git [c]hange' })

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal { '[c', bang = true }
      else
        gitsigns.nav_hunk 'prev'
      end
    end, { desc = 'Jump to previous git [c]hange' })

    -- Actions
    -- visual mode
    map('v', '<leader>hs', function()
      gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, { desc = 'git [s]tage hunk' })
    map('v', '<leader>hr', function()
      gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, { desc = 'git [r]eset hunk' })
    -- normal mode
    map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
    map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
    map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
    map('n', '<leader>hu', gitsigns.stage_hunk, { desc = 'git [u]ndo stage hunk' })
    map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
    map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
    map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
    map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
    map('n', '<leader>hD', function()
      gitsigns.diffthis '@'
    end, { desc = 'git [D]iff against last commit' })
    -- Toggles
    map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
    map('n', '<leader>tD', gitsigns.preview_hunk_inline, { desc = '[T]oggle git show [D]eleted' })
  end,
}
-- }}}

require('ibl').setup {} -- indent-blankline configuration

-- lazydev configuration {{{
require('lazydev').setup {
  library = {
    -- Load luvit types when the `vim.uv` word is found
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  },
}
-- }}}

-- lspconfig configuration {{{
require('mason').setup {} -- mason configuration
require('fidget').setup {} -- fidget configuration
local fidget = require 'fidget'
vim.notify = fidget.notify
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    -- NOTE: Remember that Lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself.
    --
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    -- Rename the variable under your cursor.
    --  Most Language Servers support renaming across files, etc.
    map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

    -- Execute a code action, usually your cursor needs to be on top of an error
    -- or a suggestion from your LSP for this to activate.
    map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

    -- Find references for the word under your cursor.
    map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

    -- Jump to the implementation of the word under your cursor.
    --  Useful when your language has ways of declaring types without an actual implementation.
    map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

    -- Jump to the definition of the word under your cursor.
    --  This is where a variable was first declared, or where a function is defined, etc.
    --  To jump back, press <C-t>.
    map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

    -- This is Goto Declaration, not Goto Definition.
    --  For example, in C this would take you to the header.
    map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    -- Fuzzy find all the symbols in your current document.
    --  Symbols are things like variables, functions, types, etc.
    map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

    -- Fuzzy find all the symbols in your current workspace.
    --  Similar to document symbols, except searches over your entire project.
    map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

    -- Jump to the type of the word under your cursor.
    --  Useful when you're not sure what type a variable is and you want to see
    --  the definition of its *type*, not where it was *defined*.
    map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

    -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
    ---@param client vim.lsp.Client
    ---@param method vim.lsp.protocol.Method
    ---@param bufnr? integer some lsp support methods only in specific files
    ---@return boolean
    local function client_supports_method(client, method, bufnr)
      if vim.fn.has 'nvim-0.11' == 1 then
        return client:supports_method(method, bufnr)
      else
        return client.supports_method(method, { bufnr = bufnr })
      end
    end

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
        end,
      })
    end

    -- The following code creates a keymap to toggle inlay hints in your
    -- code, if the language server you are using supports them
    --
    -- This may be unwanted, since they displace some of your code
    if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, '[T]oggle Inlay [H]ints')
    end
  end,
})

-- Diagnostic Config
-- See :help vim.diagnostic.Opts
vim.diagnostic.config {
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = vim.g.have_nerd_font and {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
  } or {},
  virtual_text = {
    source = 'if_many',
    spacing = 2,
    format = function(diagnostic)
      local diagnostic_message = {
        [vim.diagnostic.severity.ERROR] = diagnostic.message,
        [vim.diagnostic.severity.WARN] = diagnostic.message,
        [vim.diagnostic.severity.INFO] = diagnostic.message,
        [vim.diagnostic.severity.HINT] = diagnostic.message,
      }
      return diagnostic_message[diagnostic.severity]
    end,
  },
}

-- Set the default capabilities of all LSP servers to the capabilities provided by blink.cmp
vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities(),
})

local mason_tool_names = {
  -- LSP
  'stylua',
  'gopls',
  'pyright',
  'typescript-language-server',
  'gdtoolkit',
  'lua-language-server',
  'zls',
}
local lsp_servers = {
  'stylua', -- Used to format Lua code
  'gopls', -- Go LSP Server
  'pyright', -- Python LSP Server
  'ts_ls', -- TypeScript/JavaScript LSP Server
  'gdtoolkit', -- Game Development Toolkit LSP Server
  'lua_ls', -- Lua LSP Server
  'zls', -- Zig LSP Server
}
require('mason-tool-installer').setup { ensure_installed = mason_tool_names }

for _, server in ipairs(lsp_servers) do
  vim.lsp.enable(server)
end
-- }}}

-- mini_nvim configuration {{{
-- Better Around/Inside textobjects
--
-- Examples:
--  - va)  - [V]isually select [A]round [)]paren
--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
--  - ci'  - [C]hange [I]nside [']quote
require('mini.ai').setup { n_lines = 500 }

-- Add/delete/replace surroundings (brackets, quotes, etc.)
--
-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
-- - sd'   - [S]urround [D]elete [']quotes
-- - sr)'  - [S]urround [R]eplace [)] [']
require('mini.surround').setup()

-- Simple and easy statusline.
--  You could remove this setup call if you don't like it,
--  and try some other statusline plugin
local statusline = require 'mini.statusline'
-- set use_icons to true if you have a Nerd Font
statusline.setup { use_icons = vim.g.have_nerd_font }

require('mini.tabline').setup {
  show_tabs_only = true,
}
vim.cmd [[
      highlight MiniTablineCurrent guibg=#FFD700 guifg=#000000 gui=bold
    ]]

-- You can configure sections in the statusline by overriding their
-- default behavior. For example, here we set the section for
-- cursor location to LINE:COLUMN
---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function()
  return '%2l:%-2v'
end
-- }}}

-- nerdcommenter configuration {{{
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
-- }}}

-- oil_nvim configuration {{{
require('oil').setup()
vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
vim.keymap.set('n', '<Leader>-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
-- }}}

-- telescope configuration {{{
-- Telescope is a fuzzy finder that comes with a lot of different things that
-- it can fuzzy find! It's more than just a "file finder", it can search
-- many different aspects of Neovim, your workspace, LSP, and more!
--
-- The easiest way to use Telescope, is to start by doing something like:
--  :Telescope help_tags
--
-- After running this command, a window will open up and you're able to
-- type in the prompt window. You'll see a list of `help_tags` options and
-- a corresponding preview of the help.
--
-- Two important keymaps to use while in Telescope are:
--  - Insert mode: <c-/>
--  - Normal mode: ?
--
-- This opens a window that shows you all of the keymaps for the current
-- Telescope picker. This is really useful to discover what Telescope can
-- do as well as how to actually do it!

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  -- You can put your default mappings / updates / etc. in here
  --  All the info you're looking for is in `:help telescope.setup()`
  --
  -- defaults = {
  --   mappings = {
  --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
  --   },
  -- },
  -- pickers = {}
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_dropdown(),
    },
  },
}

-- Enable Telescope extensions if they are installed
pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'ui-select')
pcall(require('telescope').load_extension, 'fidget')

-- See `:help telescope.builtin`
local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>sN', require('telescope').extensions.fidget.fidget, { desc = '[S]earch [N]otifications' })

-- Slightly advanced example of overriding default behavior and theme
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to Telescope to change the theme, layout, etc.
  builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

-- It's also possible to pass additional configuration options.
--  See `:help telescope.builtin.live_grep()` for information about particular keys
vim.keymap.set('n', '<leader>s/', function()
  builtin.live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end, { desc = '[S]earch [/] in Open Files' })

-- Shortcut for searching your Neovim configuration files
vim.keymap.set('n', '<leader>sn', function()
  builtin.find_files { cwd = vim.fn.stdpath 'config' }
end, { desc = '[S]earch [N]eovim files' })
-- }}}

-- todo_comments configuration {{{
require('todo-comments').setup {
  signs = false, -- Don't show signs in the gutter since I have gitsigns
}
-- }}}

-- treesitter configuration {{{
local ensure_installed = {
  'bash',
  'c',
  'diff',
  'html',
  'lua',
  'luadoc',
  'markdown',
  'markdown_inline',
  'python',
  'query',
  'vim',
  'vimdoc',
}
require('nvim-treesitter').setup {
  -- Autoinstall languages that are not installed
  auto_install = true,
  highlight = {
    enable = true,
    -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
    --  If you are experiencing weird indenting issues, add the language to
    --  the list of additional_vim_regex_highlighting and disabled languages for indent.
    additional_vim_regex_highlighting = { 'ruby' },
  },
  indent = { enable = true, disable = { 'ruby' } },
}
require('nvim-treesitter').install(ensure_installed)
-- }}}

-- which_key configuration {{{
require('which-key').setup {
  -- delay between pressing a key and opening which-key (milliseconds)
  -- this setting is independent of vim.o.timeoutlen
  delay = 0,
  icons = {
    -- set icon mappings to true if you have a Nerd Font
    mappings = vim.g.have_nerd_font,
    -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
    -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
    keys = vim.g.have_nerd_font and {} or {
      Up = '<Up> ',
      Down = '<Down> ',
      Left = '<Left> ',
      Right = '<Right> ',
      C = '<C-…> ',
      M = '<M-…> ',
      D = '<D-…> ',
      S = '<S-…> ',
      CR = '<CR> ',
      Esc = '<Esc> ',
      ScrollWheelDown = '<ScrollWheelDown> ',
      ScrollWheelUp = '<ScrollWheelUp> ',
      NL = '<NL> ',
      BS = '<BS> ',
      Space = '<Space> ',
      Tab = '<Tab> ',
      F1 = '<F1>',
      F2 = '<F2>',
      F3 = '<F3>',
      F4 = '<F4>',
      F5 = '<F5>',
      F6 = '<F6>',
      F7 = '<F7>',
      F8 = '<F8>',
      F9 = '<F9>',
      F10 = '<F10>',
      F11 = '<F11>',
      F12 = '<F12>',
    },
  },

  -- Document existing key chains
  spec = {
    { '<leader>s', group = '[S]earch' },
    { '<leader>t', group = '[T]oggle' },
    { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
    { '<leader>k', group = 'Vimwi[K]i' },
    { '<leader>k<leader>', group = 'Vimwiki Create' },
    { '<leader>g', group = '[G]enAI' },
    { '<leader>d', group = '[D]ebug' },
    mode = { 'n' },
  },
}
-- }}}
-- vim: foldmethod=marker foldlevel=0
