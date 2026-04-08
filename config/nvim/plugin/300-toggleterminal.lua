if vim.g.vscode then
  return
end

local state = {
  bottom = {
    buf = -1,
    win = -1,
  },
}

local function create_bottom_terminal(opts)
  opts = opts or {}
  local height = opts.height or math.floor(vim.o.lines * 0.25)

  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end
  vim.bo[buf].buflisted = false

  local win_config = {
    split = 'below',
    win = 0,
    height = height,
    style = 'minimal',
  }
  local win = vim.api.nvim_open_win(buf, true, win_config)
  return { buf = buf, win = win }
end

local toggle_terminal = function()
  if not vim.api.nvim_win_is_valid(state.bottom.win) then
    state.bottom = create_bottom_terminal { buf = state.bottom.buf }
    if vim.bo[state.bottom.buf].buftype ~= 'terminal' then
      vim.cmd.term()
    end
    vim.cmd 'startinsert!'
  else
    vim.api.nvim_win_hide(state.bottom.win)
  end
end

vim.api.nvim_create_user_command('Floaterminal', toggle_terminal, {})

vim.keymap.set({ 'n', 't' }, '<leader>tt', toggle_terminal, { desc = '[T]oggle [T]erminal' })
