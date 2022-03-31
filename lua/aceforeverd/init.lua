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

-- config variables

if vim.g.lsp_process_provider == nil then
  vim.g.lsp_process_provider = 'fidget'
end

require('aceforeverd.plugins')

local set_map = vim.api.nvim_set_keymap

-- keep vim default maps
set_map('x', ']"', '"', { noremap = true, silent = true })
set_map('n', '{{', '{', { noremap = true, silent = true })
set_map('n', '}}', '}', { noremap = true, silent = true })

-- TODO: find one place and define maps once all
require('aceforeverd.utility.map').set_map('n', '<space>l', '<cmd>FzfLua<cr>', { noremap = true })
