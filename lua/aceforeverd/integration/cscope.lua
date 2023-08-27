local M = {}

local cmds = {
  { 'a', 'Assignments to this symbol', '<C-R><C-W><cr>' },
  { 'c', 'Functions calling this function', '<C-R><C-W><cr>' },
  { 'd', 'Functions called by this function', '<C-R><C-W><cr>' },
  { 'e', 'Egrep pattern', '<C-R><C-W><cr>' },
  { 'f', 'Find the file', '<C-R>=expand("<cfile>")<cr><cr>' },
  { 'g', 'Find definition', '<C-R><C-W><cr>' },
  { 'i', 'Files #including this file', '<C-R>=expand("<cfile>")<cr><cr>' },
  { 's', 'C symbol', '<C-R><C-W><cr>' },
  { 't', 'Text string', '<C-R><C-W><cr>' },
}

---@param selection string|function
local function cscope_select(selection)
  local text = ''
  if type(selection) == 'string' then
    text = selection
  elseif type(selection) == 'function' then
    text = selection()
  else
    vim.notify('unsupported type: ' .. type(selection), vim.log.levels.WARN, {})
    return
  end

  if text == '' or text == nil then
    vim.notify('no text selected, skipping', vim.log.levels.WARN, {})
    return
  end

  vim.ui.select(cmds, {
    prompt = 'Find a usage for "' .. text .. '"',
    format_item = function(item)
      return string.format('%s (%s)', item[1], item[2])
    end,
  }, function(choice)
    if choice ~= nil then
      vim.cmd(string.format('Cscope find %s %s', choice[1], text))
    end
  end)
end

local function cscope_select_cword()
  cscope_select(vim.fn.expand('<cword>'))
end

local function cscope_select_visual()
  cscope_select(function()
    local mode = vim.api.nvim_get_mode().mode
    if mode == 'v' or mode == 'V' then
      vim.cmd([[normal! "cy]])
    end

    return vim.fn.getreg('c')
  end)
end

local function cscope_select_operator()
  local old_func = vim.go.operatorfunc
  _G.op_func_cscope = function()
    vim.cmd([[normal! `[v`]"cy]])
    local selection = vim.fn.getreg('c')
    cscope_select(selection)

    vim.go.operatorfunc = old_func
    _G.op_func_cscope = nil
  end

  vim.go.operatorfunc = 'v:lua.op_func_cscope'
  vim.api.nvim_feedkeys('g@', 'n', false)
end

function M.cscope_maps()
  require('cscope_maps').setup({
    disable_maps = true,
    cscope = {
      exec = 'gtags-cscope',
    },
  })

  local prefix = [[<c-\>]]
  for _, value in ipairs(cmds) do
    vim.keymap.set(
      'n',
      prefix .. value[1],
      string.format([[:Cscope find %s %s]], value[1], value[3]),
      { noremap = true, silent = true, desc = value[2] }
    )
  end

  vim.keymap.set(
    'n',
    prefix .. '<space>',
    cscope_select_cword,
    { noremap = true, silent = true, desc = 'Cscope cword' }
  )
  vim.keymap.set(
    'n',
    prefix .. '<cr>',
    cscope_select_operator,
    { noremap = true, silent = true, desc = 'Cscope operator' }
  )
  vim.keymap.set(
    'x',
    prefix .. '<space>',
    cscope_select_visual,
    { noremap = true, silent = true, desc = 'Cscope cword' }
  )
  vim.api.nvim_create_user_command('CsFindCWord', cscope_select_cword, { nargs = 0 })
end

return M
