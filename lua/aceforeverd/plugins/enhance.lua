-- Copyright (C) 2022  Ace <teapot@aceforeverd.com>
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.

-- enhance nvim behaviors

local M = {}

function M.pretty_fold()
  require('pretty-fold').setup({})
  -- 'h' preview fold, 'l' open fold
  require('pretty-fold.preview').setup_keybinding()
end

function M.hop()
  require('hop').setup()
end

function M.which_key()
  require('which-key').setup({ plugins = { registers = false } })
end

function M.registers_pre()
  -- disable visual mode cause it won't work in quickfix or floaterm
  vim.g.registers_delay = 200
  vim.g.paste_in_normal_mode = 2
  vim.g.registers_visual_mode = 0
end

function M.spectre()
  require('spectre').setup()

  vim.cmd([[
    command! Spectre lua require('spectre').open()
    command! SpectreCFile lua require('spectre').open_file_search()
  ]])
end

function M.hlslens()
  vim.api.nvim_set_keymap('n', '*', "*<Cmd>lua require('hlslens').start()<CR>", { silent = true, noremap = true })
  vim.api.nvim_set_keymap('n', '#', "#<Cmd>lua require('hlslens').start()<CR>", { silent = true, noremap = true })
  vim.api.nvim_set_keymap('n', 'g*', "g*<Cmd>lua require('hlslens').start()<CR>", { silent = true, noremap = true })
  vim.api.nvim_set_keymap('n', 'g#', "g#<Cmd>lua require('hlslens').start()<CR>", { silent = true, noremap = true })

  if vim.fn.has('nvim-0.6.0') == 0 then
    -- nvim 0.6.0's <c-l> set nohlsearch by default
    vim.api.nvim_set_keymap('n', '<leader>l', '<Cmd>noh<CR>', { silent = true, noremap = true })
  end

  require('hlslens').setup({ calm_down = false })
end

function M.light_bulb()
  vim.cmd([[
  augroup gp_light_bulb
    autocmd!
    autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()
  augroup END]])
end

function M.toggle_term()
  require('toggleterm').setup({
    open_mapping = [[<C-\>x]],
  })
end

return M
