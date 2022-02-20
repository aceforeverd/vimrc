-- Copyright (C) 2021  Ace <teapot@aceforeverd.com>
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
local M = {}

function M.gitsigns()
  require('gitsigns').setup({
    signs = {
      delete = { show_count = true },
      topdelete = { show_count = true },
      changedelete = { show_count = true },
    },
    keymaps = {
      -- Default keymap options
      noremap = true,
      buffer = true,

      ['n ]c'] = {
        expr = true,
        "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'",
      },
      ['n [c'] = {
        expr = true,
        "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'",
      },

      ['n <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
      ['n <leader>hu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
      ['n <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
      ['n <leader>hR'] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
      ['n <leader>hp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
      ['n <leader>bb'] = '<cmd>lua require"gitsigns".blame_line(true)<CR>',

      -- Text objects
      ['o ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
      ['x ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
    },
    diff_opts = { internal = true },
    numhl = true,
    linehl = false,
    watch_gitdir = { interval = 1000 },
    attach_to_untracked = false,
    current_line_blame = true,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = 'eol',
      delay = 1000,
      ignore_whitespace = false,
    },
    update_debounce = 100,
    status_formatter = nil,
  })
end

function M.gitlinker()
  require('gitlinker').setup({
    opts = {
      remote = 'upstream',
    }
  })

  local set_map = vim.api.nvim_set_keymap

  set_map('n', '<leader>gY', [[<cmd>lua require('gitlinker').get_repo_url()<cr>]], { silent = true })
  set_map(
    'n',
    '<leader>gb',
    [[<cmd>lua require('gitlinker').get_buf_range_url("n", {action_callback = require"gitlinker.actions".open_in_browser})<cr>]],
    { silent = true }
  )
  set_map(
    'v',
    '<leader>gb',
    [[<cmd>lua require('gitlinker').get_buf_range_url("v", {action_callback = require"gitlinker.actions".open_in_browser})<cr>]],
    {}
  )
  set_map(
    'n',
    '<leader>gB',
    [[<cmd>lua require('gitlinker').get_repo_url({action_callback = require"gitlinker.actions".open_in_browser})<cr>]],
    { silent = true }
  )
end

return M
