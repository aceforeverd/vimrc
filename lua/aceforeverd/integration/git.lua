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
        vim.keymap.set(mode, l, r, opts)
      end
      local gs = package.loaded.gitsigns

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal({ ']c', bang = true })
        else
          gs.nav_hunk('next')
        end
      end, { desc = 'next hunk' })

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal({ '[c', bang = true })
        else
          gs.nav_hunk('prev')
        end
      end, { desc = 'previous hunk' })

      -- Actions
      map('n', '<leader>hs', gs.stage_hunk, { desc = 'stage hunk' })
      map('n', '<leader>hr', gs.reset_hunk, { desc = 'reset hunk' })
      map('v', '<leader>hs', function()
        gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end, { desc = 'stage hunk' })
      map('v', '<leader>hr', function()
        gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end, { desc = 'reset hunk' })
      map('n', '<leader>hS', gs.stage_buffer, { desc = 'stage buffer' })
      map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'undo stage hunk' })
      map('n', '<leader>hR', gs.reset_buffer, { desc = 'reset buffer' })
      map('n', '<leader>hp', gs.preview_hunk, { desc = 'preview hunk' })
      map('n', '<leader>hb', function()
        gs.blame_line({ full = true })
      end, { desc = 'blame line' })
      map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'toggle line blame' })
      map('n', '<leader>hd', gs.diffthis, { desc = 'diff buffer with HEAD' })
      map('n', '<leader>hD', function()
        gs.diffthis('~')
      end, { desc = 'diff buffer with HEAD~' })
      map('n', '<leader>td', gs.toggle_deleted, { desc = 'toggle deleted' })

      -- Text object
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'select hunk' })
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
      -- blames goes at last
      -- nvim diagnostic virt texts come default as 0x1000, take arbitrarily larger
      -- ref https://github.com/lewis6991/gitsigns.nvim/issues/605
      virt_text_priority = 5000,
    },
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil,
  })
end

return M
