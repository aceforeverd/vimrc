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
    on_attach = function(bufnr)
      local map = function(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        require('aceforeverd.utility.map').set_map(mode, l, r, opts)
      end
      local gs = package.loaded.gitsigns

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then
          return ']c'
        end
        vim.schedule(function()
          gs.next_hunk()
        end)
        return '<Ignore>'
      end, { expr = true })

      map('n', '[c', function()
        if vim.wo.diff then
          return '[c'
        end
        vim.schedule(function()
          gs.prev_hunk()
        end)
        return '<Ignore>'
      end, { expr = true })

      -- Actions
      map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')
      map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')
      map('n', '<leader>hS', gs.stage_buffer)
      map('n', '<leader>hu', gs.undo_stage_hunk)
      map('n', '<leader>hR', gs.reset_buffer)
      map('n', '<leader>hp', gs.preview_hunk)
      map('n', '<leader>hb', function()
        gs.blame_line({ full = true })
      end)
      map('n', '<leader>tb', gs.toggle_current_line_blame)
      map('n', '<leader>hd', gs.diffthis)
      map('n', '<leader>hD', function()
        gs.diffthis('~')
      end)
      map('n', '<leader>td', gs.toggle_deleted)

      -- Text object
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    end,
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
      -- the lower take the priority
      virt_text_priority = 200,
    },
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil,
  })
end

function M.gitlinker()
  require('gitlinker').setup({
    opts = {
      remote = 'upstream',
    },
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

function M.diffview()
  require('diffview').setup({
    enhanced_diff_hl = true,
  })
end

function M.git_conflict()
  require('git-conflict').setup({})
end

function M.octo()
  require('octo').setup({
    user_icon = '👴',
    timeline_marker = '📣',
  })
end

return M
