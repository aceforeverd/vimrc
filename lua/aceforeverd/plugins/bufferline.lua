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

require("bufferline").setup{
    options = {
        numbers = function(opts)
            return string.format('%s|%s.)', opts.id, opts.raise(opts.ordinal))
        end,
        always_show_bufferline = true
    }
}

local set_map = vim.api.nvim_set_keymap
local map_opt = { noremap = true, silent = true }

set_map('n', '<M-.>', '<Cmd>BufferLineCycleNext<CR>', map_opt)
set_map('n', '<M-,>', '<Cmd>BufferLineCyclePrev<CR>', map_opt)
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
