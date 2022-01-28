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

local set_map = vim.api.nvim_set_keymap
local map_opt = { noremap = false, silent = true }

function M.bufferline()
  require('bufferline').setup({
    options = {
      numbers = function(opts)
        return string.format('%s|%s.)', opts.id, opts.raise(opts.ordinal))
      end,
      always_show_bufferline = true,
      diagnostics = vim.g.my_cmp_source,
      separator_style = 'slant',
    },
  })

  set_map('n', '<M-.>', '<Cmd>BufferLineCycleNext<CR>', map_opt)
  set_map('n', '<M-,>', '<Cmd>BufferLineCyclePrev<CR>', map_opt)
  -- override unimpaired mappings
  set_map('n', ']b', '<Cmd>BufferLineCycleNext<CR>', map_opt)
  set_map('n', '[b', '<Cmd>BufferLineCyclePrev<CR>', map_opt)

  set_map('n', '<M-<>', '<Cmd>BufferLineMovePrev<CR>', map_opt)
  set_map('n', '<M->>', '<Cmd>BufferLineMoveNext<CR>', map_opt)

  set_map('n', '<M-1>', '<Cmd>BufferLineGoToBuffer 1<CR>', map_opt)
  set_map('n', '<M-2>', '<Cmd>BufferLineGoToBuffer 2<CR>', map_opt)
  set_map('n', '<M-3>', '<Cmd>BufferLineGoToBuffer 3<CR>', map_opt)
  set_map('n', '<M-4>', '<Cmd>BufferLineGoToBuffer 4<CR>', map_opt)
  set_map('n', '<M-5>', '<Cmd>BufferLineGoToBuffer 5<CR>', map_opt)
  set_map('n', '<M-6>', '<Cmd>BufferLineGoToBuffer 6<CR>', map_opt)
  set_map('n', '<M-7>', '<Cmd>BufferLineGoToBuffer 7<CR>', map_opt)
  set_map('n', '<M-7>', '<Cmd>BufferLineGoToBuffer 8<CR>', map_opt)
  set_map('n', '<M-9>', '<Cmd>BufferLineGoToBuffer 9<CR>', map_opt)
end

function M.cokeline()
  require('cokeline').setup({})

  set_map('n', '<M-.>', '<Plug>(cokeline-focus-next)', map_opt)
  set_map('n', '<M-,>', '<Plug>(cokeline-focus-prev)', map_opt)
  -- override unimpaired mappings
  set_map('n', ']b', '<Plug>(cokeline-focus-next)', map_opt)
  set_map('n', '[b', '<Plug>(cokeline-focus-prev)', map_opt)

  set_map('n', '<M->>', '<Plug>(cokeline-switch-next)', map_opt)
  set_map('n', '<M-<>', '<Plug>(cokeline-switch-prev)', map_opt)

  set_map('n', '<M-1>', '<Plug>(cokeline-focus-1)', map_opt)
  set_map('n', '<M-2>', '<Plug>(cokeline-focus-2)', map_opt)
  set_map('n', '<M-3>', '<Plug>(cokeline-focus-3)', map_opt)
  set_map('n', '<M-4>', '<Plug>(cokeline-focus-4)', map_opt)
  set_map('n', '<M-5>', '<Plug>(cokeline-focus-5)', map_opt)
  set_map('n', '<M-6>', '<Plug>(cokeline-focus-6)', map_opt)
  set_map('n', '<M-7>', '<Plug>(cokeline-focus-7)', map_opt)
  set_map('n', '<M-7>', '<Plug>(cokeline-focus-8)', map_opt)
  set_map('n', '<M-9>', '<Plug>(cokeline-focus-9)', map_opt)
end

return M
